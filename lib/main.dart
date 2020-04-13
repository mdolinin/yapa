import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:yapa/bloc/items/items.dart';
import 'package:yapa/bloc/items/items_bloc.dart';
import 'package:yapa/logging_bloc_delegate.dart';
import 'package:yapa/models/item.dart';
import 'package:yapa/repository/hive_items_repository.dart';
import 'package:yapa/repository/item_entity.dart';
import 'package:yapa/routes.dart';
import 'package:yapa/screens/add_edit_screen.dart';
import 'package:yapa/screens/catalog_screen.dart';

void main() async {
  BlocSupervisor.delegate = LoggingBlocDelegate();
  await Hive.initFlutter();
  Hive.registerAdapter<ItemEntity>(ItemEntityAdapter());
  final itemsBox = await Hive.openBox<ItemEntity>('items');
  runApp(BlocProvider(
    create: (context) =>
        ItemsBloc(itemsRepository: HiveItemsRepository(itemsBox))..add(LoadItems()),
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
        Routes.home: (context) => CatalogScreen(),
        Routes.addItem: (context) => AddEditScreen(
              onSave: (Item item) {
                BlocProvider.of<ItemsBloc>(context).add(AddItem(item));
              },
              isEditing: false,
            ),
      },
    );
  }
}
