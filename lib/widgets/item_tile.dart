import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hlamnik/database/entities/item.dart';
import 'package:hlamnik/themes/main_theme.dart';

class ItemTile extends StatelessWidget {
  final Item item;

  ItemTile(this.item);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
//            Navigator.of(context).pushNamed('aroute',
//                arguments: product.id);
          },
          child: Hero(
            tag: item.id,
            child: Image.file(File(item.picture)),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: kSecondaryColor.withOpacity(0.9),
          leading: Text('${item.rating}'),
          title: Text(
            item.title,
            textAlign: TextAlign.center,
          ),
          trailing: Text(item.category.name),
        ),
      ),
    );
  }
}
