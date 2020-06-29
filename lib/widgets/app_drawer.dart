import 'package:flutter/material.dart';
import 'package:yapa/routes.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Theme.of(context).primaryColor,
        child: SafeArea(
          child: Theme(
            data: ThemeData(brightness: Brightness.dark),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                    leading: Text('YAPA',
                        style: Theme.of(context).textTheme.headline3)),
                Divider(thickness: 3.0),
                ListTile(
                  leading: Icon(Icons.shopping_basket),
                  title: Text('Shopping list'),
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, Routes.home),
                ),
                ListTile(
                  leading: Icon(Icons.view_list),
                  title: Text('Catalog'),
                ),
                ListTile(
                  leading: Icon(Icons.category),
                  title: Text('Categories'),
                  onTap: () => Navigator.pushReplacementNamed(
                      context, Routes.categories),
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
    );
  }
}
