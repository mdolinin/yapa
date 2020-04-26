import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yapa/repository/stores_repository.dart';
import 'package:yapa/routes.dart';
import 'package:yapa/widgets/items_widget.dart';

class CatalogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catalog'),
      ),
      body: PageView(
        children: store_names
            .map((name) => ItemsWidget(tagNameToFilter: name))
            .toList()
              ..insert(0, ItemsWidget()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.addItem);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
