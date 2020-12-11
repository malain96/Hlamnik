import 'package:flutter/material.dart';
import 'package:hlamnik/themes/main_theme.dart';
import 'package:hlamnik/widgets/input_bordered.dart';

///Displays a switch in a nice rounded input
class SwitchInput extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SwitchInput({
    Key key,
    @required this.label,
    @required this.value,
    @required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InputBordered(
      childTopPadding: 15,
      child: Row(
        children: [
          Expanded(
              child: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.w500),
          )),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.secondaryColor,
            activeColor: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }
}
