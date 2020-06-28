import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hlamnik/themes/main_theme.dart';

// Display a loading indicator
class LoadingIndicator extends StatelessWidget {
  final Color color;


  LoadingIndicator({this.color = AppColors.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Platform.isIOS
          ? CupertinoActivityIndicator()
          : CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          color,
        ),
      ),
    );
  }
}
