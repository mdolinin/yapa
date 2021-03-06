import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:yapa/bloc/items/items.dart';
import 'package:yapa/models/item.dart';
import 'package:yapa/models/quantity_type.dart';
import 'package:yapa/screens/add_edit_screen.dart';
import 'package:yapa/utils/file_utils.dart';

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
          child: ListView(
            children: <Widget>[
              Center(
                child: Text('${item.name}',
                    style: Theme.of(context).textTheme.headline5),
              ),
              Center(
                child: Text('${item.qtyType.toStr}',
                    style: Theme.of(context).textTheme.headline6),
              ),
              Center(
                child: Wrap(
                  runSpacing: 5.0,
                  spacing: 5.0,
                  alignment: WrapAlignment.spaceAround,
                  children: item.tags
                      .map(
                        (name) => FilterChip(
                          label: Text('$name'),
                          checkmarkColor: Theme.of(context).canvasColor,
                          selectedColor: Theme.of(context).accentColor,
                          selected: true,
                          onSelected: (bool value) {},
                        ),
                      )
                      .toList(),
                ),
              ),
              Center(
                child: item.category == ''
                    ? Chip(
                        label: Text('No category'),
                      )
                    : Chip(
                        label: Text('${item.category}'),
                        labelStyle:
                            Theme.of(context).chipTheme.secondaryLabelStyle,
                        backgroundColor:
                            Theme.of(context).chipTheme.secondarySelectedColor,
                      ),
              ),
              item.selected
                  ? Icon(Icons.check_box)
                  : Icon(Icons.check_box_outline_blank),
              item.pathToImage == ''
                  ? Image.memory(kTransparentImage)
                  : Image(
                      image: FileImage(
                          File('${FileUtils.absolutePath(item.pathToImage)}')),
                    ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: item == null
              ? null
              : () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) {
                      return AddEditScreen(
                        onSave: (Item updatedItem) {
                          BlocProvider.of<ItemsBloc>(context).add(
                            UpdateItem(updatedItem.copyWith(id: item.id)),
                          );
                        },
                        isEditing: true,
                        item: item,
                      );
                    }),
                  );
                },
          child: Icon(Icons.edit),
        ),
      );
    });
  }
}
