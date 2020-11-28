import 'package:flutter/material.dart';
import 'package:hlamnik/widgets/loading_indicator.dart';

///Widget used to display a bottom sheet
class ModalBottomSheetForm extends StatelessWidget {
  final String title;
  final Widget form;
  final Function saveForm;
  final bool isLoading;

  const ModalBottomSheetForm({
    Key key,
    @required this.title,
    @required this.form,
    @required this.saveForm,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: mediaQuery.viewInsets.bottom + 8.0,
        top: 8.0,
        right: 8.0,
        left: 8.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                title,
                style: Theme.of(context).textTheme.headline6,
              )),
              if (!isLoading)
                IconButton(
                  icon: Icon(Icons.check, size: 30),
                  onPressed: saveForm,
                ),
            ],
          ),
          isLoading ? LoadingIndicator() : form,
        ],
      ),
    );
  }
}
