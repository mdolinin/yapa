import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yapa/widgets/items_widget.dart';

class CatalogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catalog'),
      ),
      body: ItemsWidget(),
    );
  }
}
