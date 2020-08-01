import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hlamnik/services/db_service.dart';
import 'package:hlamnik/themes/main_theme.dart';
import 'package:hlamnik/database/entities/color.dart' as entity;
import 'package:easy_localization/easy_localization.dart';
import 'package:hlamnik/utils/bottom_sheet_utils.dart';
import 'package:hlamnik/widgets/color_form.dart';
import 'package:hlamnik/widgets/error_text.dart';

///Widget used to display a modal containing all available [Color]
class ColorPickerInput extends StatelessWidget {
  final Color pickedColor;
  final ValueChanged<Color> onColorChanged;
  final String error;
  final bool showCreateButton;
  final Function(entity.Color) onCreate;

  const ColorPickerInput({
    @required this.pickedColor,
    @required this.onColorChanged,
    this.error,
    this.showCreateButton = false,
    this.onCreate,
  });

  ///Loads a list of [Color]
  Future<List<entity.Color>> get _colors async {
    final db = await DBService.getDatabase;
    return await db.colorDao.listAll();
  }

  void _onCreateButtonPressed(BuildContext context) {
    Navigator.of(context).pop();
    BottomSheetUtils.showCustomModalBottomSheet(
      context: context,
      builder: (_) => ColorForm(afterSave: onCreate,),
    );
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
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                backgroundColor: AppColors.tertiaryColor,
                                title: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text('selectSomething'.tr(
                                          gender: 'female',
                                          args: ['color'.tr().toLowerCase()])),
                                    ),
                                    if (showCreateButton)
                                      IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () =>
                                            _onCreateButtonPressed(context),
                                      ),
                                  ],
                                ),
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
