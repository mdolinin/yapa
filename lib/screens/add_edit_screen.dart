import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:yapa/bloc/categories/categories.dart';
import 'package:yapa/models/category.dart';
import 'package:yapa/models/item.dart';
import 'package:yapa/models/quantity_type.dart';
import 'package:yapa/repository/stores_repository.dart';
import 'package:yapa/utils/file_utils.dart';

typedef OnSaveCallback = Function(Item item);

class AddEditScreen extends StatefulWidget {
  final OnSaveCallback onSave;
  final bool isEditing;
  final Item item;

  const AddEditScreen(
      {Key key, @required this.onSave, @required this.isEditing, this.item})
      : super(key: key);

  @override
  _AddEditScreenState createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  ScrollController _scrollController;
  bool _needsScroll = false;
  Image _preCachedItemImage;

  Item _item;
  Set<String> _selectedStores = Set();

  bool get isEditing => widget.isEditing;

  void _showPhotoLibrary(BuildContext context) async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    String appDocPath = FileUtils.appDocDir.path;
    final fileName = basename(pickedFile.path);
    final File file = File(pickedFile.path);
    await file.copy('$appDocPath/$fileName');
    _preCachedItemImage = buildImageFromLocalFile(fileName);
    await precacheImage(_preCachedItemImage.image, context);
    setState(() {
      _item = _item.copyWith(pathToImage: fileName);
      _needsScroll = true;
    });
  }

  Image buildImageFromLocalFile(String pathToFile) {
    return Image(
      image: FileImage(File('${FileUtils.absolutePath(pathToFile)}')),
    );
  }

  Image imageFrom(Item _item) {
    return _item.pathToImage == ''
        ? Image.memory(kTransparentImage)
        : (_preCachedItemImage ?? buildImageFromLocalFile(_item.pathToImage));
  }

  void _scrollToEnd() async {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  void scrollToEndAfterBuildIfNeeded() {
    if (_needsScroll) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
      _needsScroll = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool showFAB = MediaQuery.of(context).viewInsets.bottom == 0.0;
    final textTheme = Theme.of(context).textTheme;
    _item = _item ?? (isEditing ? widget.item : Item(''));
    _selectedStores = _selectedStores..addAll(_item.tags);
    _item.similarItems.forEach((item) {
      _selectedStores = _selectedStores..addAll(item.tags);
    });
    scrollToEndAfterBuildIfNeeded();
    final itemImage = imageFrom(_item);
    return Scaffold(
      appBar: AppBar(
        title: isEditing ? Text('Edit item') : Text('Add item'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    initialValue: _item.name,
                    autofocus: !isEditing,
                    decoration: InputDecoration(hintText: 'Enter item name'),
                    style: textTheme.headline5,
                    validator: (val) {
                      return val.trim().isEmpty
                          ? 'Please enter some item name'
                          : null;
                    },
                    onSaved: (value) {
                      _item = _item.copyWith(name: value);
                    },
                  ),
                  DropdownButtonFormField<QuantityType>(
                    value: (_item.qtyType == QuantityType.not_applicable &&
                            !isEditing)
                        ? null
                        : _item.qtyType,
                    decoration:
                        InputDecoration(hintText: 'Select quantity type'),
                    items: QuantityType.values.map((QuantityType qtyType) {
                      return DropdownMenuItem<QuantityType>(
                          value: qtyType, child: Text(qtyType.toStr));
                    }).toList(),
                    onChanged: (QuantityType value) {
                      setState(() {
                        _item = _item.copyWith(qtyType: value);
                      });
                    },
                  ),
                  Divider(),
                  SelectStoreRow(
                    item: _item,
                    selectedStores: _selectedStores,
                    onStoreSelected: (List<String> tags) {
                      setState(() {
                        _selectedStores = _selectedStores..addAll(tags);
                        _item = _item.copyWith(tags: tags);
                      });
                    },
                    onQtySaved: (double qty) {
                      setState(() {
                        _item = _item.copyWith(quantityInBaseUnits: qty);
                      });
                    },
                    onPriceSaved: (double price) {
                      setState(() {
                        _item = _item.copyWith(priceOfBaseUnit: price);
                      });
                    },
                  ),
                  Column(
                    children: _item.similarItems.asMap().entries.map((entry) {
                      int idx = entry.key;
                      Item val = entry.value;
                      return SelectStoreRow(
                        item: val,
                        selectedStores: _selectedStores,
                        onStoreSelected: (List<String> tags) {
                          setState(() {
                            _selectedStores = _selectedStores..addAll(tags);
                            _item.similarItems[idx] =
                                _item.similarItems[idx].copyWith(tags: tags);
                          });
                        },
                        onQtySaved: (double qty) {
                          setState(() {
                            _item.similarItems[idx] = _item.similarItems[idx]
                                .copyWith(quantityInBaseUnits: qty);
                          });
                        },
                        onPriceSaved: (double price) {
                          setState(() {
                            _item.similarItems[idx] = _item.similarItems[idx]
                                .copyWith(priceOfBaseUnit: price);
                          });
                        },
                      );
                    }).toList(),
                  ),
                  _item.similarItems.length >= store_names.length - 1
                      ? Row()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            RaisedButton.icon(
                              color: Theme.of(context).accentColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              icon: Icon(
                                Icons.plus_one,
                              ),
                              textColor: Colors.white,
                              label: Text(
                                'Store',
                                style: textTheme.subtitle1
                                    .copyWith(color: Colors.white),
                              ),
                              onPressed: () {
                                setState(() {
                                  List<Item> items =
                                      List.from(_item.similarItems);
                                  items.add(Item(
                                    _item.name,
                                    category: _item.category,
                                    pathToImage: _item.pathToImage,
                                  ));
                                  _item = _item.copyWith(similarItems: items);
                                });
                              },
                            ),
                          ],
                        ),
                  Divider(),
                  BlocBuilder<CategoriesBloc, CategoriesState>(
                    builder: (context, state) {
                      if (state is CategoriesLoading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is CategoriesLoaded) {
                        final categoryNames = state.categories
                            .map((Category c) => c.name)
                            .toList();
                        return Wrap(
                          alignment: WrapAlignment.spaceAround,
                          children: categoryNames
                              .where((n) => n != '')
                              .map(
                                (name) => ChoiceChip(
                                  label: Text('$name'),
                                  selected: _item.category == name,
                                  onSelected: (bool selected) {
                                    setState(() {
                                      _item = _item.copyWith(category: name);
                                    });
                                  },
                                ),
                              )
                              .toList(),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  Divider(),
                  SwitchListTile(
                    title: Text(
                      'Already bought',
                      style: textTheme.headline5,
                    ),
                    value: _item.selected,
                    onChanged: (bool value) {
                      setState(() {
                        _item = _item.copyWith(selected: value);
                      });
                    },
                  ),
                  Divider(),
                  SizedBox(child: itemImage),
                  ListTile(
                    onTap: () {
                      _showPhotoLibrary(context);
                    },
                    leading: Icon(Icons.photo_library),
                    title: Text("Choose from photo library"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: showFAB
          ? FloatingActionButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  widget.onSave(_item);
                  Navigator.pop(context);
                }
              },
              child: Icon(isEditing ? Icons.check : Icons.add),
            )
          : null,
    );
  }
}

class SelectStoreRow extends StatelessWidget {
  final Item item;
  final Set<String> selectedStores;
  final Function onStoreSelected;
  final Function onQtySaved;
  final Function onPriceSaved;

  const SelectStoreRow(
      {@required this.item,
      @required this.selectedStores,
      @required this.onStoreSelected,
      @required this.onQtySaved,
      @required this.onPriceSaved});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          flex: 6,
          child: InputChip(
            label: item.tags.isEmpty
                ? Text("Select store")
                : Text('${item.tags.first}'),
            selected: item.tags.isNotEmpty,
            checkmarkColor: Theme.of(context).canvasColor,
            selectedColor: Theme.of(context).accentColor,
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: Center(child: Text('Select store')),
                    children: store_names
                        .where((element) => !selectedStores.contains(element))
                        .map(
                          (name) => FilterChip(
                            label: Text('$name'),
                            checkmarkColor: Theme.of(context).canvasColor,
                            selectedColor: Theme.of(context).accentColor,
                            selected: item.tags.contains('$name'),
                            onSelected: (bool value) {
                              List<String> tags = List.from(item.tags);
                              if (value) {
                                tags = ['$name'];
                              }
                              onStoreSelected(tags);
                              Navigator.pop(context);
                            },
                          ),
                        )
                        .toList(),
                  );
                },
              );
            },
          ),
        ),
        Flexible(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
            child: TextFormField(
              autofocus: false,
              initialValue: item.quantityInBaseUnits == 0.0
                  ? null
                  : item.quantityInBaseUnits.toString(),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                TextInputFormatter.withFunction((oldValue, newValue) =>
                    RegExp(r'(^\d*\.?\d{0,2})$').hasMatch(newValue.text)
                        ? newValue
                        : oldValue)
              ],
              decoration: InputDecoration(
                labelText: 'Quantity',
                alignLabelWithHint: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: textTheme.headline6,
              onSaved: (value) {
                double qty = double.tryParse(value) ?? 0.0;
                if (qty != 0.0) {
                  onQtySaved(qty);
                }
              },
            ),
          ),
        ),
        Flexible(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
            child: TextFormField(
              initialValue: item.priceOfBaseUnit == 0.0
                  ? null
                  : item.priceOfBaseUnit.toString(),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                TextInputFormatter.withFunction((oldValue, newValue) =>
                    RegExp(r'(^\d*\.?\d{0,2})$').hasMatch(newValue.text)
                        ? newValue
                        : oldValue)
              ],
              decoration: InputDecoration(
                labelText: 'Price',
                alignLabelWithHint: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: textTheme.headline6,
              onSaved: (value) {
                double price = double.tryParse(value) ?? 0.0;
                if (price != 0.0) {
                  onPriceSaved(price);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
