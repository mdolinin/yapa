import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    _item = _item != null ? _item : isEditing ? widget.item : null;
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
                initialValue: isEditing ? _item.name : '',
                autofocus: !isEditing,
                decoration: InputDecoration(hintText: 'Enter item name'),
                style: textTheme.headline5,
                validator: (val) {
                  return val.trim().isEmpty
                      ? 'Please enter some item name'
                      : null;
                },
                onSaved: (value) {
                  if (_item == null) {
                    _item = Item(value);
                  } else {
                    _item = _item.copyWith(name: value);
                  }
                },
              ),
              TextFormField(
                initialValue: isEditing ? _item.volume : '',
                decoration: InputDecoration(hintText: 'Enter item volume'),
                style: textTheme.headline5,
                onSaved: (value) {
                  if (_item != null) {
                    _item = _item.copyWith(volume: value);
                  }
                },
              ),
              SwitchListTile(
                title: Text(
                  'Select',
                  style: textTheme.headline5,
                ),
                value: isEditing ? _item.selected : false,
                onChanged: (bool value) {
                  setState(() {
                    if (_item != null) {
                      _item = _item.copyWith(selected: value);
                    }
                  });
                },
              )
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
