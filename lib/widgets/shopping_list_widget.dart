import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:yapa/bloc/items/items.dart';
import 'package:yapa/models/filtered_shopping_list.dart';
import 'package:yapa/models/item.dart';
import 'package:yapa/screens/add_edit_screen.dart';
import 'package:yapa/screens/detail_screen.dart';
import 'package:yapa/utils/file_utils.dart';

typedef ItemFilter = bool Function(Item);

class ShoppingListWidget extends StatefulWidget {
  final String tagNameToFilter;

  const ShoppingListWidget({Key key, this.tagNameToFilter}) : super(key: key);

  @override
  _ShoppingListWidgetState createState() => _ShoppingListWidgetState();
}

class _ShoppingListWidgetState extends State<ShoppingListWidget> {
  ItemFilter _filterFromTagName() {
    ItemFilter defaultFilter = (item) => true;
    ItemFilter filterNoTag = (item) => item.tags.isEmpty;
    ItemFilter filterByTag =
        (item) => item.tags.contains(widget.tagNameToFilter);
    ItemFilter filter;
    if (widget.tagNameToFilter == null) {
      filter = defaultFilter;
    } else if (widget.tagNameToFilter == '') {
      filter = filterNoTag;
    } else {
      filter = filterByTag;
    }
    return filter;
  }

  FilteredShoppingList from(String tag, List<Item> items) {
    final List<Item> filteredByTag = items.where(_filterFromTagName()).toList();
    final List<Item> sortedByName = filteredByTag
      ..sort((a, b) => a.name.compareTo(b.name));
    final Map<String, List<Item>> groupedByCategory =
        groupBy(sortedByName, (Item item) => item.category);
    final List<FilteredCategory> filteredCategories = groupedByCategory.entries
        .toList()
        .map((MapEntry<String, List<Item>> entry) =>
            FilteredCategory(entry.key, entry.value))
        .toList();
    return FilteredShoppingList(tag, filteredCategories);
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
          final FilteredShoppingList filteredShoppingList =
              from(widget.tagNameToFilter, state.items);
          return ListView(
            children: filteredShoppingList.categories.map((category) {
              return ExpansionTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: category.name == ''
                          ? Text(
                              'No category',
                              style: Theme.of(context).textTheme.subtitle1,
                            )
                          : Text('${category.name}'),
                    ),
                    SizedBox(width: 10.0),
                    Chip(
                      label: Text('${category.items.length}'),
                      labelStyle:
                          Theme.of(context).chipTheme.secondaryLabelStyle,
                      backgroundColor:
                          Theme.of(context).chipTheme.secondarySelectedColor,
                    ),
                  ],
                ),
                leading: category.name == '' ? Icon(Icons.category) : null,
                key: PageStorageKey<String>(
                    "${filteredShoppingList.tag}__${category.name}"),
                initiallyExpanded: true,
                children: category.items
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
                        child: Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 0.5,
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
                      ),
                    )
                    .toList(),
              );
            }).toList(),
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
