import 'package:flutter/material.dart';
import 'package:hlamnik/generated/locale_keys.g.dart';
import 'package:hlamnik/themes/main_theme.dart';
import 'package:easy_localization/easy_localization.dart';

import 'error_text.dart';

class YearPickerInput extends StatelessWidget {
  final String pickedYear;
  final ValueChanged<int> onYearChanged;
  final String error;

  const YearPickerInput(
      {Key key,
      this.error,
      @required this.onYearChanged,
      @required this.pickedYear})
      : super(key: key);

  //Opens a dialog to select a year
  void _showYearsDialog(BuildContext context, List<int> years) => showDialog(
    context: context,
    builder: (BuildContext context) => SimpleDialog(
      title: Text(
        LocaleKeys.selectSomething.tr(
          gender: 'female',
          args: [LocaleKeys.year.tr().toLowerCase()],
        ),
      ),
      children: years
          .map(
            (year) => SimpleDialogOption(
          child: Text(
            '$year',
            style: TextStyle(fontSize: 16),
          ),
          onPressed: () => onYearChanged(year),
        ),
      )
          .toList(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final years = <int>[];
    final currentYear = DateTime.now().year;

    //Generate a list containing 10 years
    for (var i = 0; i <= 10; i++) {
      years.add(currentYear - i);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          width: double.infinity,
          height: 60,
          child: RaisedButton(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: BorderSide(
                  color: error != null
                      ? Theme.of(context).errorColor
                      : AppColors.secondaryColor),
            ),
            onPressed: () => _showYearsDialog(context, years),
            child: Text(pickedYear ?? LocaleKeys.year.tr()),
            color: AppColors.tertiaryColor,
            textColor: AppColors.secondaryColor,
          ),
        ),
        if (error != null) ErrorText(error),
      ],
    );
  }
}
