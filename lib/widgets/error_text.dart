import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  ErrorText(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 13),
      child: Text(
        message,
        style: TextStyle(color: Theme.of(context).errorColor, fontSize: 12),
      ),
    );
  }
}
