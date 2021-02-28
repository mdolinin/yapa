import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yapa/bloc/categories/categories_bloc.dart';
import 'package:yapa/bloc/categories/categories_event.dart';
import 'package:yapa/bloc/items/items_bloc.dart';
import 'package:yapa/bloc/items/items_event.dart';
import 'package:yapa/bloc/shopping_list/shopping_items_tree_bloc.dart';
import 'package:yapa/main.dart';
import 'package:yapa/repository/mock_categories_repository.dart';
import 'package:yapa/repository/mock_items_repository.dart';

void main() {
  testWidgets('Yapa smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) =>
                  ItemsBloc(itemsRepository: MockItemsRepository())
                    ..add(LoadItems())),
          BlocProvider(
              create: (context) => CategoriesBloc(
                  categoriesRepository: MockCategoriesRepository())
                ..add(LoadCategories())),
        ],
        child: BlocProvider(
          create: (BuildContext context) => ShoppingItemsTreeBloc(
              itemsBloc: BlocProvider.of<ItemsBloc>(context),
              categoriesBloc: BlocProvider.of<CategoriesBloc>(context)),
          child: YapaApp(),
        ),
      ),
    );

    // Verify that our app shows Shopping list.
    expect(find.text('Shopping list'), findsOneWidget);
    expect(find.text('Not existing text'), findsNothing);

    // Wait for items loaded.
    await tester.pump(new Duration(milliseconds: 3000));

    // Tap the checkbox icon and trigger a frame.
    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();

    // Verify that nothing changed.
    expect(find.text('Shopping list'), findsOneWidget);
    expect(find.text('Not existing text'), findsNothing);
  });
}
