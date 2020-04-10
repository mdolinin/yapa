import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:yapa/models/item.dart';

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

  String _path = null;

  void _showPhotoLibrary() async {
    final file = await ImagePicker.pickImage(source: ImageSource.gallery);
    print(file.path);
    setState(() {
      _path = file.path;
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
          child: ListView(
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
              TextFormField(
                initialValue: _item.volume,
                decoration: InputDecoration(hintText: 'Enter item volume'),
                style: textTheme.headline5,
                onSaved: (value) {
                  _item = _item.copyWith(volume: value);
                },
              ),
              SwitchListTile(
                title: Text(
                  'Select',
                  style: textTheme.headline5,
                ),
                value: _item.selected,
                onChanged: (bool value) {
                  setState(() {
                    _item = _item.copyWith(selected: value);
                  });
                },
              ),
              ListTile(
                onTap: () {
                  _showPhotoLibrary();
                },
                leading: Icon(Icons.photo_library),
                title: Text("Choose from photo library"),
              ),
              _path == null
                  ? Image.memory(kTransparentImage)
                  : Image.file(File(_path)),
            ],
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
