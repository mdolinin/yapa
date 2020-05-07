import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:yapa/bloc/items/items.dart';
import 'package:yapa/models/item.dart';
import 'package:yapa/screens/add_edit_screen.dart';
import 'package:yapa/screens/detail_screen.dart';
import 'package:yapa/utils/file_utils.dart';

typedef ItemFilter = bool Function(Item);

class ItemsWidget extends StatelessWidget {
  final String tagNameToFilter;

  const ItemsWidget({Key key, this.tagNameToFilter}) : super(key: key);

  ItemFilter _filterFromTagName() {
    ItemFilter defaultFilter = (item) => true;
    ItemFilter filterNoTag = (item) => item.tags.isEmpty;
    ItemFilter filterByTag = (item) => item.tags.contains(tagNameToFilter);
    ItemFilter filter;
    if (tagNameToFilter == null) {
      filter = defaultFilter;
    } else if (tagNameToFilter == '') {
      filter = filterNoTag;
    } else {
      filter = filterByTag;
    }
    return filter;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemsBloc, ItemsState>(
      builder: (context, state) {
        if (state is ItemsLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ItemsLoaded) {
          final List<Item> filteredAndSortedList = state.items
              .where(_filterFromTagName())
              .toList()
                ..sort((a, b) => a.name.compareTo(b.name))
                ..sort((a, b) => a.category.compareTo(b.category))
                ..sort((a, b) =>
                    b.selected == a.selected ? 0 : (a.selected ? 1 : -1));
          final List<MapEntry<String, List<Item>>> categoriesToItems = groupBy(
                  filteredAndSortedList,
                  (Item item) => '${item.category}__${item.selected}')
              .entries
              .toList();
          return ListView.separated(
            separatorBuilder: (context, index) {
              final category = categoriesToItems[index];
              bool selected = category.key.endsWith('__true');
              if (!selected &&
                  categoriesToItems[index + 1].key.endsWith('__true')) {
                return Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 5.0, right: 10.0),
                        child: Divider(
                          color: Theme.of(context).primaryColorDark,
                          thickness: 3.0,
                        ),
                      ),
                    ),
                    Text('ALREADY BOUGHT',
                        style: Theme.of(context).textTheme.headline5),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 10.0, right: 5.0),
                        child: Divider(
                          color: Theme.of(context).primaryColorDark,
                          thickness: 3.0,
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return SizedBox.shrink();
              }
            },
            itemCount: categoriesToItems.length,
            itemBuilder: (BuildContext context, index) {
              final category = categoriesToItems[index];
              var categoryName =
                  category.key.replaceAll(RegExp('__false|__true'), '');
              return ExpansionTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: categoryName == ''
                          ? Text(
                              'No category',
                              style: Theme.of(context).textTheme.subtitle1,
                            )
                          : Text('$categoryName'),
                    ),
                    SizedBox(width: 10.0),
                    Chip(
                      label: Text('${category.value.length}'),
                      labelStyle:
                          Theme.of(context).chipTheme.secondaryLabelStyle,
                      backgroundColor:
                          Theme.of(context).chipTheme.secondarySelectedColor,
                    ),
                  ],
                ),
                leading: categoryName == '' ? Icon(Icons.category) : null,
                key: PageStorageKey<String>(category.key),
                initiallyExpanded: true,
                children: category.value
                    .map(
                      (item) => Slidable(
                        key: Key('Item__${item.id}'),
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            caption: 'Edit',
                            color: Colors.blueGrey,
                            icon: Icons.edit,
                            onTap: () => _openEditScreen(context, item),
                          ),
                          IconSlideAction(
                            caption: 'Delete',
                            color: Theme.of(context).errorColor,
                            icon: Icons.delete,
                            onTap: () => _deleteItemWithSnackBar(context, item),
                          ),
                        ],
                        dismissal: SlidableDismissal(
                          child: SlidableDrawerDismissal(),
                          onDismissed: (actionType) {
                            if (actionType == SlideActionType.secondary) {
                              HapticFeedback.mediumImpact();
                              _deleteItemWithSnackBar(context, item);
                            }
                          },
                        ),
                        child: Card(
                          color: item.selected
                              ? Theme.of(context).buttonColor
                              : Theme.of(context).cardColor,
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
                            trailing: Checkbox(
                              value: item.selected,
                              onChanged: (bool value) {
                                BlocProvider.of<ItemsBloc>(context).add(
                                  UpdateItem(item.copyWith(selected: value)),
                                );
                              },
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => DetailsScreen(id: item.id),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }

  void _openEditScreen(BuildContext context, Item item) {
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
  }

  void _deleteItemWithSnackBar(BuildContext context, Item item) {
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
            BlocProvider.of<ItemsBloc>(context).add(AddItem(item));
          },
        ),
      ),
    );
  }
}
