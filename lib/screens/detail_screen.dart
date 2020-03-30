import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yapa/bloc/items/items.dart';
import 'package:yapa/models/item.dart';

class DetailsScreen extends StatelessWidget {
  final String id;

  const DetailsScreen({@required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemsBloc, ItemsState>(builder: (context, state) {
      final Item item = (state as ItemsLoaded)
          .items
          .firstWhere((item) => item.id == id, orElse: () => null);
      return Scaffold(
        appBar: AppBar(
          title: Text('Item Details'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Container(
                child: Text('${item.name}'),
              ),
              Container(
                child: Text('${item.volume}'),
              ),
              item.selected
                  ? Icon(Icons.check_box_outline_blank)
                  : Icon(Icons.check_box),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.edit),
        ),
      );
    });
  }
}
