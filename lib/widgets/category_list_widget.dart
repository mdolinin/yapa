import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yapa/bloc/shopping_list/shopping_items_tree.dart';
import 'package:yapa/bloc/shopping_list/shopping_items_tree_bloc.dart';
import 'package:yapa/bloc/shopping_list/shopping_items_tree_event.dart';
import 'package:yapa/models/tagged_categorized_items.dart';

class CategoryListWidget extends StatelessWidget {
  final String tag;

  const CategoryListWidget({@required this.tag});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingItemsTreeBloc, ShoppingItemsTreeState>(
      builder: (context, state) {
        if (state is ShoppingItemsTreeLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ShoppingItemsTreeLoaded) {
          final List<CategorizedItems> categorizedItemsList =
              state.taggedCategorizedItems[tag] ?? [];
          return ReorderableListView(
            onReorder: _onReorder(context, tag, categorizedItemsList),
            children: categorizedItemsList.map((ci) {
              return Card(
                key: ValueKey<String>("${tag}__${ci.category}"),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                elevation: 0.5,
                child: ListTile(
                  title: ci.category == ''
                      ? Text('No category')
                      : Text(ci.category),
                  trailing: Icon(
                    Icons.reorder,
                  ),
                  onTap: () => {},
                ),
              );
            }).toList(),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Function _onReorder(BuildContext context, String tag,
      List<CategorizedItems> categorizedItemsList) {
    return (int oldIndex, int newIndex) {
      final reorderedCategories = [...categorizedItemsList];
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final category = reorderedCategories.removeAt(oldIndex);
      reorderedCategories.insert(newIndex, category);
      BlocProvider.of<ShoppingItemsTreeBloc>(context).add(
        CategorizedItemsUpdated(tag, reorderedCategories),
      );
    };
  }
}
