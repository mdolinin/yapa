import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yapa/bloc/items/items.dart';
import 'package:yapa/models/item.dart';
import 'package:yapa/screens/detail_screen.dart';
import 'package:yapa/utils/file_utils.dart';

typedef ItemFilter = bool Function(Item);

class ItemsWidget extends StatelessWidget {
  final String tagNameToFilter;

  const ItemsWidget({Key key, this.tagNameToFilter = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ItemFilter defaultFilter = (item) => true;
    ItemFilter filterByTag = (item) => item.tags.contains(tagNameToFilter);
    ItemFilter filter = tagNameToFilter == '' ? defaultFilter : filterByTag;
    return BlocBuilder<ItemsBloc, ItemsState>(
      builder: (context, state) {
        if (state is ItemsLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ItemsLoaded) {
          final items = state.items.where(filter).toList();
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
                    leading: CircleAvatar(
                      radius: 44.0,
                      backgroundColor: Colors.transparent,
                      child: item.pathToImage == ''
                          ? FlutterLogo(size: 44.0)
                          : Image(
                              image: AssetImage(
                                  '${FileUtils.absolutePath(item.pathToImage)}'),
                            ),
                    ),
                    title: Text(item.name),
                    subtitle: Text(item.volume),
                    trailing: item.selected
                        ? Icon(Icons.check_box)
                        : Icon(Icons.check_box_outline_blank),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => DetailsScreen(id: item.id),
                        ),
                      );
                    },
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
