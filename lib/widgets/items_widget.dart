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
                direction: DismissDirection.startToEnd,
                dismissThresholds: {DismissDirection.startToEnd: 0.1},
                background: Container(
                  color: Theme.of(context).errorColor,
                  padding: EdgeInsets.all(12.0),
                  alignment: Alignment.centerLeft,
                  child: Icon(Icons.delete_forever),
                ),
                onDismissed: (direction) {
                  BlocProvider.of<ItemsBloc>(context).add(DeleteItem(item));
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "${item.name} deleted",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      duration: Duration(seconds: 2),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          BlocProvider.of<ItemsBloc>(context)
                              .add(AddItem(item));
                        },
                      ),
                    ),
                  );
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
