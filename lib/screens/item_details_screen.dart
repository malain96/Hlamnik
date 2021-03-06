import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hlamnik/database/entities/item.dart';
import 'package:hlamnik/generated/locale_keys.g.dart';
import 'package:hlamnik/providers/items.dart';
import 'package:hlamnik/screens/edit_item_screen.dart';
import 'package:hlamnik/themes/main_theme.dart';
import 'package:hlamnik/widgets/display_field.dart';
import 'package:hlamnik/widgets/rating_display.dart';
import 'package:provider/provider.dart';

///Screen used to display all the info of an [Item] as well as editing or deleting it
class ItemDetailsScreen extends StatelessWidget {
  static const routeName = '/item';

  ///Navigates to the [EditItemScreen] when the edit button is pressed
  void _onEditPressed(BuildContext context, Item item) => Navigator.of(context)
      .pushNamed(EditItemScreen.routeName, arguments: item);

  ///Shows an [AlertDialog] which asks the user the confirm or cancel the deletion
  void _onDeletePressed(BuildContext context, Item item) => showDialog(
        context: context,
        child: AlertDialog(
          title: Text(LocaleKeys.delete.tr()),
          content: Text(LocaleKeys.deleteConfirm.tr()),
          actions: <Widget>[
            SizedBox(
              width: 50,
              child: FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(LocaleKeys.no.tr()),
                textColor: AppColors.secondaryColor,
              ),
            ),
            SizedBox(
              width: 50,
              child: FlatButton(
                onPressed: () => _onDeleteConfirmed(context, item),
                child: Text(LocaleKeys.yes.tr()),
                textColor: AppColors.errorColor,
              ),
            ),
          ],
        ),
      );

  ///Deletes the [Item] and navigates back the the root screen
  Future<void> _onDeleteConfirmed(BuildContext context, Item item) async {
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
    final yearsSincePurchase =
        DateTime.now().year - int.parse(item.purchaseYear);

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
              title: LocaleKeys.title.tr(),
              value: item.title,
            ),
            DisplayField(
              title: LocaleKeys.year.tr(),
              value: yearsSincePurchase > 0
                  ? LocaleKeys.boughtYearsAgo.tr(args: [yearsSincePurchase.toString()])
                  : LocaleKeys.boughtLessYear.tr(),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: DisplayField(
                    title: LocaleKeys.rating.tr(),
                    child: RatingDisplay(item.rating),
                  ),
                ),
                Expanded(
                  child: DisplayField(
                    title: LocaleKeys.quality.tr(),
                    child: RatingDisplay(item.quality),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: DisplayField(
                    title: LocaleKeys.category.tr(),
                    value: item.category.name,
                  ),
                ),
                Expanded(
                  child: DisplayField(
                    title: LocaleKeys.brand.tr(),
                    value: item.brand.name,
                  ),
                ),
              ],
            ),
            DisplayField(
              title: LocaleKeys.color.tr(),
              child: Row(
                children: item.colors
                    .map(
                      (color) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: CircleAvatar(
                          backgroundColor: color.getColor,
                          radius: 10,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            DisplayField(
              title: LocaleKeys.seasons.tr(),
              value: item.seasons.map((season) => season.name).join(' - '),
            ),
            DisplayField(
              title: LocaleKeys.isBrokenDisplay.tr(),
              value: item.isBroken ? LocaleKeys.yes.tr() : LocaleKeys.no.tr(),
            ),
            DisplayField(
              title: LocaleKeys.comment.tr(),
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
