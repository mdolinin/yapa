import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yapa/bloc/items/items.dart';

class ItemsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemsBloc, ItemsState>(
      builder: (context, state) {
        if (state is ItemsLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ItemsLoaded) {
          final items = state.items;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (BuildContext context, index) {
              final item = items[index];
              return Dismissible(
                key: Key('Item__${item.id}'),
                onDismissed: (direction) {
                  BlocProvider.of<ItemsBloc>(context).add(DeleteItem(item));
                },
                child: Card(
                  child: ListTile(
                    leading: FlutterLogo(size: 44.0),
                    title: Text(item.name),
                    subtitle: Text(item.volume),
                    trailing: item.selected
                        ? Icon(Icons.check_box_outline_blank)
                        : Icon(Icons.check_box),
                  ),
                ),
              );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
