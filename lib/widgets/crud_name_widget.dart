import 'package:flutter/material.dart';
import 'package:hlamnik/themes/main_theme.dart';
import 'package:hlamnik/widgets/async_data_display.dart';
import 'package:easy_localization/easy_localization.dart';

///Displays a screen to perform CRUD actrions
class CrudNameWidget<T> extends StatefulWidget {
  final String title;
  final List<T> values;
  final Future<void> Function() loadValues;
  final void Function(T value) onAddOrEditPressed;
  final Future<void> Function(int index) onDelete;

  const CrudNameWidget({
    Key key,
    @required this.title,
    @required this.values,
    @required this.onAddOrEditPressed,
    @required this.loadValues,
    @required this.onDelete,
  }) : super(key: key);

  @override
  _CrudNameWidgetState<T> createState() => _CrudNameWidgetState<T>();
}

class _CrudNameWidgetState<T> extends State<CrudNameWidget<T>> {
  var _isLoading = true;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      widget.loadValues().then(
            (_) => setState(
              () {
                _isLoading = false;
              },
            ),
          );
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  ///Tries to delete an item and displays a dialog if it fails
  void _delete(int index) async {
    try {
      await widget.onDelete(index);
    } catch (_) {
      await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('error'.tr()),
          content: Text('usedError'.tr()),
          actions: [
            FlatButton(
              child: Text('ok'.tr()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => widget.onAddOrEditPressed(null),
          ),
        ],
        centerTitle: true,
      ),
      body: AsyncDataDisplay(
        isLoading: _isLoading,
        isEmpty: widget.values.isEmpty,
        body: ListView.separated(
          itemCount: widget.values.length,
          separatorBuilder: (context, index) => Divider(),
          itemBuilder: (context, index) => ListTile(
            title: Text(
              widget.values[index].toString(),
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  color: AppColors.secondaryColor,
                  onPressed: () => widget.onAddOrEditPressed(widget.values[index]),
                ),
                IconButton(
                  icon: Icon(Icons.delete_forever),
                  color: AppColors.errorColor,
                  onPressed: () => _delete(index),
                ),
              ],
            ),
          ),
        ),
        refresh: widget.loadValues,
      ),
    );
  }
}
