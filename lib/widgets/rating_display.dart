import 'package:flutter/material.dart';

class RatingDisplay extends StatelessWidget {
  final double rating;
  final Color textColor;

  RatingDisplay(this.rating, {this.textColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          '$rating',
          style: TextStyle(color: textColor),
        ),
        Icon(
          Icons.star,
          size: 16,
        ),
      ],
    );
  }
}
