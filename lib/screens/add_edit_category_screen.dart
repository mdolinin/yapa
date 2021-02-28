import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yapa/models/category.dart';

typedef OnSaveCallback = Function(Category category);

class AddEditCategoryScreen extends StatefulWidget {
  final OnSaveCallback onSave;
  final bool isEditing;
  final Category category;

  const AddEditCategoryScreen(
      {Key key, @required this.onSave, @required this.isEditing, this.category})
      : super(key: key);

  @override
  _AddEditCategoryScreenState createState() => _AddEditCategoryScreenState();
}

class _AddEditCategoryScreenState extends State<AddEditCategoryScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ScrollController _scrollController;
  Category _category;

  bool get isEditing => widget.isEditing;

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
    _category = _category ?? (isEditing ? widget.category : Category(''));
    return Scaffold(
      appBar: AppBar(
        title: isEditing ? Text('Edit category') : Text('Add category'),
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
                    initialValue: _category.name,
                    autofocus: !isEditing,
                    decoration:
                        InputDecoration(hintText: 'Enter category name'),
                    style: textTheme.headline5,
                    validator: (val) {
                      return val.trim().isEmpty
                          ? 'Please enter some category name'
                          : null;
                    },
                    onSaved: (value) {
                      _category = _category.copyWith(name: value);
                    },
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
                  widget.onSave(_category);
                  Navigator.pop(context);
                }
              },
              child: Icon(isEditing ? Icons.check : Icons.add),
            )
          : null,
    );
  }
}
