import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hlamnik/services/db_service.dart';
import 'package:hlamnik/themes/main_theme.dart';
import 'package:hlamnik/database/entities/color.dart' as entity;
import 'package:easy_localization/easy_localization.dart';
import 'package:hlamnik/widgets/error_text.dart';

///Widget used to display a modal containing all available [Color]
class ColorPickerInput extends StatelessWidget {
  final Color pickedColor;
  final ValueChanged<Color> onColorChanged;
  final String error;

  const ColorPickerInput({
    @required this.pickedColor,
    @required this.onColorChanged,
    this.error,
  });

  ///Loads a list of [Color]
  Future<List<entity.Color>> get _colors async {
    final db = await DBService.getDatabase;
    return await db.colorDao.listAll();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<entity.Color>>(
        future: _colors,
        builder: (context, colorsSnapshot) {
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
                  onPressed: colorsSnapshot.hasData
                      ? () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: AppColors.tertiaryColor,
                                title: Text('selectSomething'.tr(
                                    gender: 'female',
                                    args: ['color'.tr().toLowerCase()])),
                                content: SingleChildScrollView(
                                  child: BlockPicker(
                                    pickerColor:
                                        pickedColor ?? AppColors.tertiaryColor,
                                    onColorChanged: onColorChanged,
                                    availableColors: colorsSnapshot.data
                                        .map((color) => color.getColor)
                                        .toList(),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      : null,
                  child: Text('color'.tr()),
                  color: pickedColor ?? AppColors.tertiaryColor,
                  textColor:
                      useWhiteForeground(pickedColor ?? AppColors.tertiaryColor)
                          ? AppColors.tertiaryColor
                          : AppColors.secondaryColor,
                ),
              ),
              if (error != null) ErrorText(error),
            ],
          );
        });
  }
}
