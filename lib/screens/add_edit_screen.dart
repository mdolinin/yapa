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
  Item _item;

  bool get isEditing => widget.isEditing;

  void _showPhotoLibrary() async {
    final File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    String appDocPath = FileUtils.appDocDir.path;
    final fileName = basename(image.path);
    await image.copy('$appDocPath/$fileName');
    setState(() {
      _item = _item.copyWith(pathToImage: fileName);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    _item = _item ?? (isEditing ? widget.item : Item(''));
    return Scaffold(
      appBar: AppBar(
        title: isEditing ? Text('Edit item') : Text('Add item'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
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
                Divider(),
                TextFormField(
                  initialValue: _item.volume,
                  decoration: InputDecoration(hintText: 'Enter item volume'),
                  style: textTheme.headline5,
                  onSaved: (value) {
                    _item = _item.copyWith(volume: value);
                  },
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      flex: 6,
                      child: InputChip(
                        label: _item.tags.isEmpty
                            ? Text("Select store")
                            : Text('${_item.tags.first}'),
                        selected: _item.tags.isNotEmpty,
                        checkmarkColor: Theme.of(context).canvasColor,
                        selectedColor: Theme.of(context).accentColor,
                        onPressed: () {
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return SimpleDialog(
                                title: Center(child: Text('Select store')),
                                children: store_names
                                    .map(
                                      (name) => FilterChip(
                                        label: Text('$name'),
                                        checkmarkColor:
                                            Theme.of(context).canvasColor,
                                        selectedColor:
                                            Theme.of(context).accentColor,
                                        selected: _item.tags.contains('$name'),
                                        onSelected: (bool value) {
                                          List<String> tags =
                                              List.from(_item.tags);
                                          if (value) {
                                            tags = ['$name'];
                                          }
                                          setState(() {
                                            _item = _item.copyWith(tags: tags);
                                          });
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
                          initialValue: _item.quantityInBaseUnits == 0.0
                              ? null
                              : _item.quantityInBaseUnits.toString(),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: <TextInputFormatter>[
                            TextInputFormatter.withFunction(
                                (oldValue, newValue) =>
                                    RegExp(r'(^\d*\.?\d{0,2})$')
                                            .hasMatch(newValue.text)
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
                            _item = _item.copyWith(
                                quantityInBaseUnits: double.parse(value));
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                        child: TextFormField(
                          initialValue: _item.priceOfBaseUnit == 0.0
                              ? null
                              : _item.priceOfBaseUnit.toString(),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: <TextInputFormatter>[
                            TextInputFormatter.withFunction(
                                (oldValue, newValue) =>
                                    RegExp(r'(^\d*\.?\d{0,2})$')
                                            .hasMatch(newValue.text)
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
                            _item = _item.copyWith(
                                priceOfBaseUnit: double.parse(value));
                          },
                        ),
                      ),
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
                      final categoryNames =
                          state.categories.map((Category c) => c.name).toList();
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
                ListTile(
                  onTap: () {
                    _showPhotoLibrary();
                  },
                  leading: Icon(Icons.photo_library),
                  title: Text("Choose from photo library"),
                ),
                _item.pathToImage == ''
                    ? Image.memory(kTransparentImage)
                    : Image(
                        image: AssetImage(
                            '${FileUtils.absolutePath(_item.pathToImage)}'),
                      ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            widget.onSave(_item);
            Navigator.pop(context);
          }
        },
        child: Icon(isEditing ? Icons.check : Icons.add),
      ),
    );
  }
}
