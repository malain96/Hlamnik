import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ItemListScreen extends StatelessWidget {
  static const routeName = '/item-list';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List'),
      ),
      body: Center(
        child: Text('title'.tr()),
      ),
    );
  }
}
