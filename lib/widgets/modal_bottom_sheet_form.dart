import 'package:flutter/material.dart';
import 'package:hlamnik/widgets/loading_indicator.dart';

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
    return Container(
      height: MediaQuery.of(context).size.height / 1.5,
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Wrap(
            runSpacing: 10,
            children: <Widget>[
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
        ),
      ),
    );
  }
}
