import 'package:flutter/material.dart';

class CategoryTitleWidget extends StatelessWidget {
  final String name;
  final int itemCount;

  const CategoryTitleWidget({this.name, this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: name == ''
              ? Text(
                  'No category',
                  style: Theme.of(context).textTheme.subtitle1,
                )
              : Text('$name'),
        ),
        SizedBox(width: 10.0),
        Chip(
          label: Text('$itemCount'),
          labelStyle: Theme.of(context).chipTheme.secondaryLabelStyle,
          backgroundColor: Theme.of(context).chipTheme.secondarySelectedColor,
        ),
      ],
    );
  }
}
