import 'package:flutter/material.dart';
import 'package:hlamnik/themes/main_theme.dart';
import 'package:hlamnik/widgets/error_text.dart';

class InputBordered extends StatelessWidget {
  const InputBordered({
    Key key,
    @required String label,
    @required Widget child,
    double childTopPadding = 18,
    double childLeftPadding = 8,
    String error,
  })  : _label = label,
        _child = child,
        _childTopPadding = childTopPadding,
        _childLeftPadding = childLeftPadding,
        _error = error,
        super(key: key);

  final String _label;
  final Widget _child;
  final double _childTopPadding;
  final double _childLeftPadding;
  final String _error;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _error != null
                          ? Theme.of(context).errorColor
                          : kSecondaryColor,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  height: 60,
                  child: null),
            ),
            Container(
              decoration: BoxDecoration(color: kTertiaryColor),
              padding: const EdgeInsets.only(left: 10, right: 25),
              height: 30,
              child: Text(
                _label,
                style: TextStyle(
                  fontSize: 12,
                  color: _error != null
                      ? Theme.of(context).errorColor
                      : kSecondaryColor,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: _childTopPadding,
                left: _childLeftPadding,
              ),
              child: _child,
            ),
          ],
        ),
        if (_error != null) ErrorText(_error),
      ],
    );
  }
}
