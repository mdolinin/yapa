import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yapa/bloc/items/items.dart';
import 'package:yapa/models/filtered_shopping_list.dart';
import 'package:yapa/models/item.dart';
import 'package:yapa/screens/add_edit_screen.dart';
import 'package:yapa/screens/detail_screen.dart';
import 'package:yapa/widgets/category_title_widget.dart';
import 'package:yapa/widgets/item_tile_widget.dart';

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
                title: CategoryTitleWidget(
                  name: category.name,
                  itemCount: category.items.length,
                ),
                leading: category.name == '' ? Icon(Icons.category) : null,
                key: PageStorageKey<String>(
                    "${filteredShoppingList.tag}__${category.name}"),
                initiallyExpanded: true,
                children: category.items
                    .map((item) => ItemTileWidget(
                        item: item,
                        onSelect: _toggleItemSelection(context),
                        onEdit: _openEditScreen(context),
                        onDelete: _deleteItemWithSnackBar(context),
                        onTap: _openDetailsScreen(context)))
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

  Function _toggleItemSelection(BuildContext context) {
    return (Item item, bool value) {
      BlocProvider.of<ItemsBloc>(context).add(
        UpdateItem(item.copyWith(selected: value)),
      );
    };
  }

  Function _openDetailsScreen(BuildContext context) {
    return (Item item) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => DetailsScreen(id: item.id),
        ),
      );
    };
  }

  Function _openEditScreen(BuildContext context) {
    return (Item item) {
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
    };
  }

  Function _deleteItemWithSnackBar(BuildContext context) {
    return (Item item) {
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
    };
  }
}
