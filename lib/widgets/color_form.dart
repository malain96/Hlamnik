import 'package:flutter/material.dart';
import 'package:hlamnik/services/db_service.dart';
import 'package:hlamnik/themes/main_theme.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hlamnik/database/entities/color.dart' as entity;
import 'package:hlamnik/widgets/modal_bottom_sheet_form.dart';
import 'package:easy_localization/easy_localization.dart';

///Widget used to add a new [Color]
class ColorForm extends StatefulWidget {
  ///Function called after saving the color to the database
  final Function(entity.Color) afterSave;

  const ColorForm({Key key, this.afterSave}) : super(key: key);

  @override
  _ColorFormState createState() => _ColorFormState();
}

class _ColorFormState extends State<ColorForm> {
  var _color = AppColors.primaryColor;
  var _isLoading = false;

  ///Sets the [_color] to the selected color
  void _setColor(Color color) => _color = color;

  ///Validates and creates the new [Color]
  Future<void>_saveForm() async {
    setState(() {
      _isLoading = true;
    });

    final color = entity.Color(
      id: null,
      code: _color.value.toRadixString(16).padLeft(6, '0')
          .substring(2)
          .toUpperCase(),
    );

    final db = await DBService.getDatabase;
    color.id = await db.colorDao.insertValue(
        color
    );

    if (widget.afterSave != null) {
      widget.afterSave(color);
    }

    setState(() {
      _isLoading = false;
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheetForm(
      title: 'color'.tr(),
      form: Container(
        child: ColorPicker(
          pickerColor: _color,
          pickerAreaHeightPercent: 0.7,
          onColorChanged: _setColor,
          enableAlpha: false,
          displayThumbColor: true,
          showLabel: false,
          paletteType: PaletteType.hsl,
          pickerAreaBorderRadius: BorderRadius.circular(15),
        ),
      ),
      saveForm: _saveForm,
      isLoading: _isLoading,
    );
  }
}