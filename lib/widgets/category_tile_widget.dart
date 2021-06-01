import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:yapa/models/category.dart';

typedef OnCategory(Category category);

class CategoryTileWidget extends StatelessWidget {
  final Category category;
  final OnCategory onEdit;
  final OnCategory onDelete;
  final OnCategory onTap;

  const CategoryTileWidget(
      {@required this.category, this.onEdit, this.onDelete, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key('Category__${category.id}'),
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Edit',
          color: Colors.blueGrey,
          icon: Icons.edit,
          onTap: () => onEdit(category),
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Theme.of(context).errorColor,
          icon: Icons.delete,
          onTap: () => onDelete(category),
        ),
      ],
      dismissal: SlidableDismissal(
        child: SlidableDrawerDismissal(),
        onDismissed: (actionType) {
          if (actionType == SlideActionType.secondary) {
            HapticFeedback.mediumImpact();
            onDelete(category);
          }
        },
      ),
      child: ListTile(
        title: category.name == '' ? Text('No category') : Text(category.name),
        trailing: Icon(
          Icons.reorder,
        ),
        onTap: () => onTap(category),
      ),
    );
  }
}
