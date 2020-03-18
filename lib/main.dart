import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yapa/bloc/items/items.dart';
import 'package:yapa/bloc/items/items_bloc.dart';
import 'package:yapa/logging_bloc_delegate.dart';
import 'package:yapa/repository/mock_items_repository.dart';
import 'package:yapa/screens/catalog_screen.dart';

void main() {
  BlocSupervisor.delegate = LoggingBlocDelegate();
  runApp(YapaApp());
}

class YapaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yet another pantry app',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: BlocProvider(
        create: (context) => ItemsBloc(
          itemsRepository: MockItemsRepository(),
        )..add(LoadItems()),
        child: CatalogScreen(),
      ),
    );
  }
}
