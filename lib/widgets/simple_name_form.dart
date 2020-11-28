import 'package:flutter/material.dart';
import 'package:hlamnik/widgets/modal_bottom_sheet_form.dart';
import 'package:easy_localization/easy_localization.dart';

///Widget used to add a new entity with just a name
class SimpleNameForm extends StatefulWidget {
  final String title;
  final int id;
  final String oldValue;
  final void Function(int id,String value) onSave;

  const SimpleNameForm({Key key, @required this.title,@required this.onSave, this.id, this.oldValue}) : super(key: key);
  
  @override
  _SimpleNameFormState createState() => _SimpleNameFormState();
}

class _SimpleNameFormState extends State<SimpleNameForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _name = '';
  var _isLoading = false;

  ///Sets the [_name] to the selected name
  void _setName(String name) => _name = name;

  ///Validates and creates/edits the entity
  Future<void>_saveForm() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _formKey.currentState.save();

    await widget.onSave(widget.id, _name);

    setState(() {
      _isLoading = false;
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheetForm(
      title: widget.title,
      form: Form(
        key: _formKey,
        child: TextFormField(
          autofocus: true,
          initialValue: widget.oldValue,
          decoration: InputDecoration(
            labelText: 'title'.tr(),
          ),
          textCapitalization: TextCapitalization.sentences,
          autocorrect: true,
          validator: (value) {
            if (value.isEmpty) {
              return 'errorNoAction'.tr(
                gender: 'male',
                args: [
                  'enter'.tr().toLowerCase(),
                  'title'.tr().toLowerCase(),
                ],
              );
            }

            if (value.length < 3) {
              return 'errorMinLength'
                  .tr(gender: 'male', args: ['title'.tr().toLowerCase(), '3']);
            }
            return null;
          },
          onSaved: _setName,
          //Should save
          onFieldSubmitted: (_) => _saveForm(),
        ),
      ),
      saveForm: _saveForm,
      isLoading: _isLoading,
    );
  }
}
