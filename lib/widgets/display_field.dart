import 'package:flutter/material.dart';

// Display data in a nice way with a title and value
class DisplayField extends StatelessWidget {
  final String title;
  final Widget child;
  final String value;
  const DisplayField({
    @required this.title,
    this.child,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.headline1,),
          SizedBox(height: 5,),
          child ?? Text(value ?? '', style: Theme.of(context).textTheme.subtitle1,),
          Divider(),
        ],
      ),
    );
  }
}
