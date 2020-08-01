import 'package:flutter/material.dart';

///Provides utilitary function to work with bottom sheets
class BottomSheetUtils {
  ///Opens a bottom sheet with the given content
  static void showCustomModalBottomSheet(
          {@required BuildContext context, @required WidgetBuilder builder}) =>
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15),
          ),
        ),
        builder: builder,
        isScrollControlled: true,
      );
}
