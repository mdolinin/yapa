import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yapa/bloc/categories/categories.dart';
import 'package:yapa/bloc/shopping_list/shopping_items_tree.dart';
import 'package:yapa/bloc/shopping_list/shopping_items_tree_bloc.dart';
import 'package:yapa/bloc/shopping_list/shopping_items_tree_event.dart';
import 'package:yapa/models/category.dart';
import 'package:yapa/models/tagged_categorized_items.dart';
import 'package:yapa/screens/add_edit_category_screen.dart';
import 'package:yapa/widgets/category_tile_widget.dart';

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
                child: CategoryTileWidget(
                    category: findCategoryByName(context, ci),
                    onEdit: _openEditScreen(context),
                    onDelete: _deleteCategoryWithSnackBar(context),
                    onTap: (Category category) => {}),
              );
            }).toList(),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Category findCategoryByName(BuildContext context, CategorizedItems ci) {
    return BlocProvider.of<CategoriesBloc>(context)
        .findCategoryByName(ci.category.name);
  }

  Function _openEditScreen(BuildContext context) {
    return (Category category) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) {
          return AddEditCategoryScreen(
            onSave: (Category updatedCategory) {
              BlocProvider.of<CategoriesBloc>(context).add(
                UpdateCategory(updatedCategory.copyWith(id: category.id)),
              );
            },
            isEditing: true,
            category: category,
          );
        }),
      );
    };
  }

  Function _deleteCategoryWithSnackBar(BuildContext context) {
    return (Category category) {
      BlocProvider.of<CategoriesBloc>(context).add(DeleteCategory(category));
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${category.name} deleted",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          duration: Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              BlocProvider.of<CategoriesBloc>(context)
                  .add(AddCategory(category));
            },
          ),
        ),
      );
    };
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
