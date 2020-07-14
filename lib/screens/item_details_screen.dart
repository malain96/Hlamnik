import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hlamnik/database/entities/item.dart';
import 'package:hlamnik/providers/items.dart';
import 'package:hlamnik/screens/edit_item_screen.dart';
import 'package:hlamnik/themes/main_theme.dart';
import 'package:hlamnik/widgets/display_field.dart';
import 'package:hlamnik/widgets/rating_display.dart';
import 'package:provider/provider.dart';

class ItemDetailsScreen extends StatelessWidget {
  static const routeName = '/item';

  void _onEditPressed(BuildContext context, Item item) => Navigator.of(context)
      .pushNamed(EditItemScreen.routeName, arguments: item);

  void _onDeletePressed(BuildContext context, Item item) => showDialog(
        context: context,
        child: AlertDialog(
          title: Text('delete'.tr()),
          content: Text('deleteConfirm'.tr()),
          actions: <Widget>[
            SizedBox(
              width: 50,
              child: FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('no'.tr()),
                textColor: AppColors.secondaryColor,
              ),
            ),
            SizedBox(
              width: 50,
              child: FlatButton(
                onPressed: () => _onDeleteConfirmed(context, item),
                child: Text('yes'.tr()),
                textColor: AppColors.errorColor,
              ),
            ),
          ],
        ),
      );

  Future _onDeleteConfirmed(BuildContext context, Item item) async {
    //Navigate to home
    Navigator.popUntil(context, ModalRoute.withName('/'));
    await context.read<Items>().deleteItem(item);
  }

  @override
  Widget build(BuildContext context) {
    final int id = ModalRoute.of(context).settings.arguments;
    final item = context.watch<Items>().getItem(id);
    final imageBytes = base64Decode(item.picture);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () => _onEditPressed(context, item),
            icon: Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () => _onDeletePressed(context, item),
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: size.width / 5,
                backgroundImage: MemoryImage(
                  imageBytes,
                ),
              ),
            ),
            DisplayField(
              title: 'title'.tr(),
              value: item.title,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: DisplayField(
                    title: 'rating'.tr(),
                    child: RatingDisplay(item.rating),
                  ),
                ),
                Expanded(
                  child: DisplayField(
                    title: 'quality'.tr(),
                    child: RatingDisplay(item.quality),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: DisplayField(
                    title: 'category'.tr(),
                    value: item.category.name,
                  ),
                ),
                Expanded(
                  child: DisplayField(
                    title: 'color'.tr(),
                    child: CircleAvatar(
                      backgroundColor: item.color.getColor,
                      radius: 10,
                    ),
                  ),
                ),
              ],
            ),
            DisplayField(
              title: 'seasons'.tr(),
              value: item.seasons.map((season) => season.name).join(' - '),
            ),
            DisplayField(
              title: 'comment'.tr(),
              value: item.comment,
            ),
          ],
        ),
      ),
      floatingActionButton: Platform.isAndroid
          ? FloatingActionButton(
              onPressed: () => _onEditPressed(context, item),
              child: Icon(Icons.edit),
            )
          : null,
    );
  }
}