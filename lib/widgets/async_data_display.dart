import 'package:flutter/material.dart';
import 'package:hlamnik/widgets/loading_indicator.dart';
import 'package:easy_localization/easy_localization.dart';

///Displays async Data
class AsyncDataDisplay extends StatelessWidget {
  final bool isLoading;
  final bool isEmpty;
  final Widget body;
  final Function() refresh;

  const AsyncDataDisplay({
    Key key,
    @required this.isLoading,
    @required this.isEmpty,
    @required this.body,
    @required this.refresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? LoadingIndicator()
        : isEmpty
        ? Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          'noItems'.tr(),
          textAlign: TextAlign.center,
        ),
        IconButton(
            icon: Icon(Icons.refresh), onPressed: refresh),
      ],
    )
        : RefreshIndicator(
      onRefresh: refresh,
      child: body
    );
  }
}
