import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:hlamnik/themes/main_theme.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomDropdownSearch<T> extends StatelessWidget {
  final String label;
  final DropdownSearchOnFind<T> onFind;
  final ValueChanged<T> onChanged;
  final T selectedItem;
  final bool isRequired;

  CustomDropdownSearch({
    @required this.label,
    @required this.onFind,
    @required this.onChanged,
    @required this.selectedItem,
    this.isRequired = false,
  });

  String _requiredValidator(T item) {
    if (item == null) {
      return 'errorNoAction'.tr(
        gender: 'female',
        args: [
          'select'.tr().toLowerCase(),
          label.toLowerCase(),
        ],
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      dropdownSearchDecoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 13),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
      mode: Mode.DIALOG,
      onFind: onFind,
      label: label,
      onChanged: onChanged,
      selectedItem: selectedItem,
      validator: isRequired ? _requiredValidator : null,
    );
  }
}
