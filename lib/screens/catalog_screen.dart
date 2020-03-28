import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yapa/routes.dart';
import 'package:yapa/widgets/items_widget.dart';

class CatalogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catalog'),
      ),
      body: ItemsWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.addItem);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
