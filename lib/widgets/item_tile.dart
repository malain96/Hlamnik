import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hlamnik/database/entities/item.dart';
import 'package:hlamnik/themes/main_theme.dart';

class ItemTile extends StatelessWidget {
  final Item item;

  ItemTile(this.item);

  @override
  Widget build(BuildContext context) {
    final imageBytes = base64Decode(item.picture);

    print(item.title);

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.secondaryColor),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: <Widget>[
            GridTile(
              child: Hero(
                tag: item.id,
                child: Image.memory(
                  imageBytes,
                  fit: BoxFit.cover,
                ),
              ),
              footer: GridTileBar(
                backgroundColor: AppColors.secondaryColor.withOpacity(0.6),
                title: Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppColors.primaryColor, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Positioned(
              left: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                    color: AppColors.secondaryColor.withOpacity(0.6),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.star,
                      color: AppColors.primaryColor,
                      size: 16,
                    ),
                    Text(
                      '${item.rating}',
                      style: TextStyle(color: AppColors.primaryColor),
                    ),
                  ],
                ),
              ),
            ),
            Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: AppColors.primaryColor.withOpacity(0.4),
                    onTap: () => null, //navigate to detailed screen of the item
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
