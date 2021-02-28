import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yapa/repository/stores_repository.dart';
import 'package:yapa/routes.dart';
import 'package:yapa/widgets/app_drawer.dart';
import 'package:yapa/widgets/category_list_widget.dart';

class CategoriesListScreen extends StatefulWidget {
  @override
  _CategoriesListScreenState createState() => _CategoriesListScreenState();
}

class _CategoriesListScreenState extends State<CategoriesListScreen>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollViewController;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _scrollViewController = ScrollController();
    _tabController = TabController(vsync: this, length: store_names.length + 2);
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
      drawer: AppDrawer(),
      body: NestedScrollView(
        controller: _scrollViewController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text('Categories list'),
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
              bottom: TabBar(
                isScrollable: true,
                tabs: store_names.map((name) => Tab(text: name)).toList()
                  ..insert(0, Tab(icon: Icon(Icons.indeterminate_check_box)))
                  ..insert(0, Tab(icon: Icon(Icons.category))),
                controller: _tabController,
              ),
            ),
          ];
        },
        body: TabBarView(
          children:
              store_names.map((name) => CategoryListWidget(tag: name)).toList()
                ..insert(0, CategoryListWidget(tag: ''))
                ..insert(0, CategoryListWidget(tag: null)),
          controller: _tabController,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.addCategory);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
