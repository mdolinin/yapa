import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yapa/bloc/shopping_list/filtered_items.dart';
import 'package:yapa/models/filtered_shopping_list.dart';

class CategoryListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilteredItemsBloc, FilteredItemsState>(
      builder: (context, state) {
        if (state is FilteredItemsStateLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is FilteredItemsStateLoaded) {
          final FilteredShoppingList filteredShoppingList =
              state.filteredShoppingList;
          return ReorderableListView(
            onReorder: _onReorder(context, filteredShoppingList.categories),
            children: filteredShoppingList.categories.map((category) {
              return Card(
                key: ValueKey<String>(
                    "${filteredShoppingList.tag}__${category.name}"),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                elevation: 0.5,
                child: ListTile(
                  title: category.name == ''
                      ? Text('No category')
                      : Text(category.name),
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

  Function _onReorder(BuildContext context, List<FilteredCategory> categories) {
    return (int oldIndex, int newIndex) {
      final reorderedCategories = [...categories];
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final category = reorderedCategories.removeAt(oldIndex);
      reorderedCategories.insert(newIndex, category);
      BlocProvider.of<FilteredItemsBloc>(context).add(
        FilteredCategoriesUpdated(reorderedCategories),
      );
    };
  }
}
