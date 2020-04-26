import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yapa/repository/stores_repository.dart';
import 'package:yapa/routes.dart';
import 'package:yapa/widgets/items_widget.dart';

class ShoppingListScreen extends StatefulWidget {
  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollViewController;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _scrollViewController = new ScrollController();
    _tabController =
        new TabController(vsync: this, length: store_names.length + 2);
  }

  @override
  void dispose() {
    _scrollViewController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollViewController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text('Shopping list'),
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
              bottom: TabBar(
                isScrollable: true,
                tabs: store_names.map((name) => Tab(text: name)).toList()
                  ..insert(0, Tab(icon: Icon(Icons.indeterminate_check_box)))
                  ..insert(0, Tab(icon: Icon(Icons.shopping_basket))),
                controller: _tabController,
              ),
            ),
          ];
        },
        body: TabBarView(
          children: store_names
              .map((name) => ItemsWidget(tagNameToFilter: name))
              .toList()
                ..insert(0, ItemsWidget(tagNameToFilter: ''))
                ..insert(0, ItemsWidget()),
          controller: _tabController,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.addItem);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}