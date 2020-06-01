import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hlamnik/themes/main_theme.dart';

// Display a loading indicator
class LoadingIndicator extends StatelessWidget {
  final Color color;


  LoadingIndicator({this.color: kPrimaryColor});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoActivityIndicator()
        : CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(
        color,
      ),
    );
  }
}
