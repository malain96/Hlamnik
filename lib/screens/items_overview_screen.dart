import 'dart:io';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hlamnik/providers/items.dart';
import 'package:hlamnik/screens/edit_item_screen.dart';
import 'package:hlamnik/widgets/item_tile.dart';
import 'package:provider/provider.dart';

class ItemsOverviewScreen extends StatelessWidget {
  void _onAddPressed(BuildContext context) =>
      Navigator.of(context).pushNamed(EditItemScreen.routeName);

  @override
  Widget build(BuildContext context) {
    final items = Provider.of<Items>(context).items;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'itemsOverviewScreenTitle'.tr(),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _onAddPressed(context),
          ),
        ],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            childAspectRatio: 1,
          ),
          itemCount: items.length,
          itemBuilder: (_, i) {
            return GridTile(child: ItemTile(items[i]));
          },
        ),
      ),
      floatingActionButton: Platform.isAndroid
          ? FloatingActionButton(
              onPressed: () => _onAddPressed(context),
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
