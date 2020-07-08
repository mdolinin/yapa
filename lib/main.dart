import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yapa/bloc/categories/categories.dart';
import 'package:yapa/bloc/items/items.dart';
import 'package:yapa/bloc/items/items_bloc.dart';
import 'package:yapa/logging_bloc_delegate.dart';
import 'package:yapa/models/item.dart';
import 'package:yapa/repository/category_entity.dart';
import 'package:yapa/repository/hive_categories_repository.dart';
import 'package:yapa/repository/hive_items_repository.dart';
import 'package:yapa/repository/item_entity.dart';
import 'package:yapa/routes.dart';
import 'package:yapa/screens/add_edit_screen.dart';
import 'package:yapa/screens/categories_list_screen.dart';
import 'package:yapa/screens/shopping_list_screen.dart';
import 'package:yapa/utils/file_utils.dart';

import 'bloc/shopping_list/selected.dart';

void main() async {
  BlocSupervisor.delegate = LoggingBlocDelegate();
  await Hive.initFlutter();
  Hive.registerAdapter<ItemEntity>(ItemEntityAdapter());
  Hive.registerAdapter<CategoryEntity>(CategoryEntityAdapter());
  final itemsBox = await Hive.openBox<ItemEntity>(k_items_box_name);
  final categoriesBox =
      await Hive.openBox<CategoryEntity>(k_categories_box_name);
  FileUtils.appDocDir = await getApplicationDocumentsDirectory();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
          create: (context) =>
              ItemsBloc(itemsRepository: HiveItemsRepository(itemsBox))
                ..add(LoadItems())),
      BlocProvider(
          create: (context) => CategoriesBloc(
              categoriesRepository: HiveCategoriesRepository(categoriesBox))
            ..add(LoadCategories())),
    ],
    child: YapaApp(),
  ));
}

class YapaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yet another pantry app',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      routes: {
        Routes.home: (context) => BlocProvider(
            create: (BuildContext context) => SelectedBloc(),
            child: ShoppingListScreen()),
        Routes.addItem: (context) => AddEditScreen(
              onSave: (Item item) {
                BlocProvider.of<ItemsBloc>(context).add(AddItem(item));
              },
              isEditing: false,
            ),
        Routes.categories: (context) => BlocProvider(
            create: (BuildContext context) => SelectedBloc(),
            child: CategoriesListScreen()),
      },
    );
  }
}
