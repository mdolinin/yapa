import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yapa/repository/stores_repository.dart';
import 'package:yapa/routes.dart';
import 'package:yapa/widgets/shopping_list_widget.dart';

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
      drawer: Drawer(
        child: Material(
          color: Theme.of(context).primaryColor,
          child: SafeArea(
            child: Theme(
              data: ThemeData(brightness: Brightness.dark),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: Text(
                      'YAPA',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.shopping_basket),
                    title: Text('Shopping list'),
                  ),
                  ListTile(
                    leading: Icon(Icons.view_list),
                    title: Text('Catalog'),
                  ),
                  ListTile(
                    leading: Icon(Icons.category),
                    title: Text('Categories'),
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
              .map((name) => ShoppingListWidget(tagNameToFilter: name))
              .toList()
                ..insert(0, ShoppingListWidget(tagNameToFilter: ''))
                ..insert(0, ShoppingListWidget()),
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
