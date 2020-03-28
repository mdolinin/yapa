import 'package:flutter/material.dart';
import 'package:yapa/models/item.dart';

typedef OnSaveCallback = Function(Item item);

class AddEditScreen extends StatefulWidget {
  final OnSaveCallback onSave;

  const AddEditScreen({Key key, @required this.onSave}) : super(key: key);

  @override
  _AddEditScreenState createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Item _item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add item'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            TextFormField(
              initialValue: '',
              decoration: InputDecoration(hintText: 'Enter item name'),
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
              initialValue: '',
              decoration: InputDecoration(hintText: 'Enter item volume'),
              onSaved: (value) {
                if (_item != null) {
                  _item = _item.copyWith(volume: value);
                }
              },
            ),
          ],
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
        child: Icon(Icons.add),
      ),
    );
  }
}
