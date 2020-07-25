import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hlamnik/themes/main_theme.dart';
import 'package:hlamnik/widgets/input_bordered.dart';

///Widget used to display a rating input
class RatingInput extends StatelessWidget {
  const RatingInput({
    Key key,
    @required double initialValue,
    @required String label,
    @required Function onPress,
  })  : _initialValue = initialValue,
        _label = label,
        _onPress = onPress,
        super(key: key);

  final double _initialValue;
  final String _label;
  final Function _onPress;

  @override
  Widget build(BuildContext context) {
    return InputBordered(
      label: _label,
      child: RatingBar(
        initialRating: _initialValue,
        minRating: 0.5,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        itemPadding: const EdgeInsets.symmetric(horizontal: 5),
        itemBuilder: (context, _) => Icon(
          Icons.star,
          color: AppColors.primaryColor,
        ),
        onRatingUpdate: (rating) {
          _onPress(rating);
        },
      ),
    );
  }
}
