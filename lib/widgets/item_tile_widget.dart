import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:yapa/models/item.dart';
import 'package:yapa/utils/file_utils.dart';

typedef OnSelect(Item item, bool value);
typedef OnItem(Item item);

class ItemTileWidget extends StatelessWidget {
  final Item item;
  final OnSelect onSelect;
  final OnItem onEdit;
  final OnItem onDelete;
  final OnItem onTap;

  const ItemTileWidget(
      {@required this.item,
      this.onSelect,
      this.onEdit,
      this.onDelete,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key('Item__${item.id}'),
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Edit',
          color: Colors.blueGrey,
          icon: Icons.edit,
          onTap: () => onEdit(item),
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Theme.of(context).errorColor,
          icon: Icons.delete,
          onTap: () => onDelete(item),
        ),
      ],
      dismissal: SlidableDismissal(
        child: SlidableDrawerDismissal(),
        onDismissed: (actionType) {
          if (actionType == SlideActionType.secondary) {
            HapticFeedback.mediumImpact();
            onDelete(item);
          }
        },
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 15.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 0.5,
          color: item.selected
              ? Theme.of(context).buttonColor
              : Theme.of(context).cardColor,
          child: ListTile(
            leading: CircleAvatar(
              radius: 44.0,
              backgroundColor: Colors.transparent,
              child: item.pathToImage == ''
                  ? FlutterLogo(size: 44.0)
                  : Image(
                      image: FileImage(
                          File('${FileUtils.absolutePath(item.pathToImage)}')),
                    ),
            ),
            title: Text(item.name),
            subtitle: Text(item.tags.isEmpty ? '' : item.tags.first),
            trailing: Checkbox(
              value: item.selected,
              onChanged: (bool value) => onSelect(item, value),
            ),
            onTap: () => onTap(item),
          ),
        ),
      ),
    );
  }
}
