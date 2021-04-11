import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yapa/bloc/items/items.dart';
import 'package:yapa/bloc/shopping_list/filtered_items.dart';
import 'package:yapa/models/item.dart';
import 'package:yapa/models/tagged_categorized_items.dart';
import 'package:yapa/screens/add_edit_screen.dart';
import 'package:yapa/screens/detail_screen.dart';
import 'package:yapa/widgets/category_with_items_title_widget.dart';
import 'package:yapa/widgets/item_tile_widget.dart';

class ShoppingListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilteredItemsBloc, FilteredItemsState>(
      builder: (context, state) {
        if (state is FilteredItemsStateLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is FilteredItemsStateLoaded) {
          final String tag = state.tag;
          final List<CategorizedItems> categorizedItemsList =
              state.categorizedItems;
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.linear,
            child: ListView(
              key: ValueKey<String>("${tag}__${state.selected}"),
              children: categorizedItemsList
                  .where((e) => e.items.isNotEmpty)
                  .map((ci) {
                return ExpansionTile(
                  title: CategoryWithItemsTitleWidget(
                    name: ci.category,
                    itemCount: ci.items.length,
                  ),
                  leading: ci.category == '' ? Icon(Icons.category) : null,
                  key: PageStorageKey<String>("${tag}__${ci.category}"),
                  initiallyExpanded: true,
                  children: ci.items
                      .map((item) => ItemTileWidget(
                          item: item,
                          onSelect: _toggleItemSelection(context),
                          onEdit: _openEditScreen(context),
                          onDelete: _deleteItemWithSnackBar(context),
                          onTap: _openDetailsScreen(context)))
                      .toList(),
                );
              }).toList(),
            ),
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
