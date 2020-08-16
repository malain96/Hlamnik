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
  final List<Color> pickedColors;
  final Function(List<Color>) onSave;
  final String error;
  final bool showCreateButton;
  final Function(entity.Color) onCreate;

  const ColorPickerInput({
    @required this.pickedColors,
    @required this.onSave,
    this.error,
    this.showCreateButton = false,
    this.onCreate,
  });

  ///Loads a list of [Color]
  Future<List<entity.Color>> get _colors async {
    final db = await DBService.getDatabase;
    return await db.colorDao.listAll();
  }

  ///Opens the color form to create a new [entity.Color]
  void _onCreateButtonPressed(BuildContext context) {
    Navigator.of(context).pop();
    BottomSheetUtils.showCustomModalBottomSheet(
      context: context,
      builder: (_) => ColorForm(
        afterSave: onCreate,
      ),
    );
  }

  ///Displays a color picker dialog
  void _showColorPickerDialog(
          BuildContext context, List<entity.Color> colors) =>
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
                      gender: 'female', args: ['colors'.tr().toLowerCase()])),
                ),
                if (showCreateButton)
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => _onCreateButtonPressed(context),
                  ),
              ],
            ),
            content: Column(
              children: [
                SingleChildScrollView(
                  child: MultipleChoiceBlockPicker(
                    pickerColors: pickedColors,
                    onColorsChanged: (colors) => print,
                    availableColors:
                        colors.map((color) => color.getColor).toList(),
                  ),
                ),
                RaisedButton(
                  onPressed: () => onSave(pickedColors),
                  child: Text('save'.tr()),
                  color: AppColors.primaryColor,
                  textColor: AppColors.secondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                )
              ],
            ),
          );
        },
      );

  ///Returns a [list] of [Widget] to render the colors of the color picker button
  List<Widget> _renderButtonColors(BoxConstraints constraints) {
    var widgets = <Widget>[];

    for (var index = 0; index < pickedColors.length; index++) {
      //Get the width of one color depending on the amount of colors
      final width = constraints.maxWidth / pickedColors.length;
      widgets.add(
        Positioned(
          //The color is positioned at the width * index
          left: width * index,
          width: width,
          height: constraints.maxHeight,
          child: Container(
            decoration: BoxDecoration(
              color: pickedColors[index],
              borderRadius: BorderRadius.only(
                //if it's the first color, the widget is rounded on the left
                topLeft: Radius.circular(index == 0 ? 30.0 : 0),
                bottomLeft: Radius.circular(index == 0 ? 30.0 : 0),
                //if it's the last color, the widget is rounded on the right
                topRight: Radius.circular(
                    index == pickedColors.length - 1 ? 30.0 : 0),
                bottomRight: Radius.circular(
                    index == pickedColors.length - 1 ? 30.0 : 0),
              ),
            ),
          ),
        ),
      );
    }

    return widgets;
  }

  ///Returns the [Color] to use a the button text color
  Color get getButtonTextColor {
    //Get teh background color located in the middle
    final backgroundColor = pickedColors.isNotEmpty
        ? pickedColors[
            pickedColors.length > 1 ? (pickedColors.length / 2).round() : 0]
        : AppColors.tertiaryColor;

    return useWhiteForeground(backgroundColor)
        ? AppColors.tertiaryColor
        : AppColors.secondaryColor;
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
                  padding: const EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(
                        color: error != null
                            ? Theme.of(context).errorColor
                            : AppColors.secondaryColor),
                  ),
                  onPressed: colorsSnapshot.hasData
                      ? () =>
                          _showColorPickerDialog(context, colorsSnapshot.data)
                      : null,
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) =>
                            Stack(
                      children: [
                        ..._renderButtonColors(constraints),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'colors'.tr(),
                            style: TextStyle(
                              color: getButtonTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  color: AppColors.tertiaryColor,
                ),
              ),
              if (error != null) ErrorText(error),
            ],
          );
        });
  }
}

///Widget used to display a color picker where the user cab choose multiple colors
class MultipleChoiceBlockPicker extends StatefulWidget {
  const MultipleChoiceBlockPicker({
    @required this.pickerColors,
    @required this.onColorsChanged,
    @required this.availableColors,
    this.layoutBuilder = BlockPicker.defaultLayoutBuilder,
    this.itemBuilder = BlockPicker.defaultItemBuilder,
  });

  final List<Color> pickerColors;
  final ValueChanged<List<Color>> onColorsChanged;
  final List<Color> availableColors;
  final PickerLayoutBuilder layoutBuilder;
  final PickerItemBuilder itemBuilder;

  @override
  State<StatefulWidget> createState() => _MultipleChoiceBlockPickerState();
}

class _MultipleChoiceBlockPickerState extends State<MultipleChoiceBlockPicker> {
  List<Color> _currentColors;

  @override
  void initState() {
    _currentColors = widget.pickerColors;
    super.initState();
  }

  ///Toggles if a color is selected or not
  void toggleColor(Color color) {
    setState(() {
      _currentColors.contains(color)
          ? _currentColors.remove(color)
          : _currentColors.add(color);
    });
    widget.onColorsChanged(_currentColors);
  }

  @override
  Widget build(BuildContext context) {
    return widget.layoutBuilder(
      context,
      widget.availableColors,
      (Color color, [bool _, Function __]) => widget.itemBuilder(
        color,
        _currentColors.contains(color),
        () => toggleColor(color),
      ),
    );
  }
}
