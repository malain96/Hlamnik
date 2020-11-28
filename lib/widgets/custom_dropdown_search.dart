import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hlamnik/generated/locale_keys.g.dart';
import 'package:hlamnik/themes/main_theme.dart';
import 'package:easy_localization/easy_localization.dart';

///Widget used to create a searchable dropdown
class CustomDropdownSearch<T> extends StatelessWidget {
  final String label;
  final DropdownSearchOnFind<T> onFind;
  final ValueChanged<T> onChanged;
  final T selectedItem;
  final bool isRequired;
  final DropdownSearchOnCreate<T> onCreate;
  final bool showCreateButton;

  CustomDropdownSearch({
    @required this.label,
    @required this.onFind,
    @required this.onChanged,
    @required this.selectedItem,
    this.onCreate,
    this.showCreateButton = false,
    this.isRequired = false,
  });

  ///Validates the dropdown if it's required
  String _requiredValidator(T item) {
    if (item == null) {
      return LocaleKeys.errorNoAction.tr(
        gender: 'female',
        args: [
          LocaleKeys.select.tr().toLowerCase(),
          label.toLowerCase(),
        ],
      );
    } else {
      return null;
    }
  }

  ///Returns a custom [Widget] for each [item]
  Widget _customPopupItemBuilder(
    BuildContext context,
    T item,
    bool isSelected,
  ) =>
      InkWell(
        splashColor: AppColors.primaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(item.toString()),
            ),
            Divider(),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final inputDecorationTheme = Theme.of(context).inputDecorationTheme;

    return DropdownSearch<T>(
      dropdownSearchDecoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 13),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
      showSearchBox: true,
      mode: Mode.DIALOG,
      popupShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      searchBoxDecoration: InputDecoration(
        labelText: LocaleKeys.search.tr(),
        border: inputDecorationTheme.border,
        labelStyle: inputDecorationTheme.labelStyle,
      ),
      popupPadding: const EdgeInsets.symmetric(vertical: 8,),
      onFind: onFind,
      label: label,
      onChanged: onChanged,
      selectedItem: selectedItem,
      validator: isRequired ? _requiredValidator : null,
      showCreateButton: showCreateButton,
      onCreate: onCreate,
      popupItemBuilder: _customPopupItemBuilder,
      noDataText: LocaleKeys.noData.tr(),
    );
  }
}

typedef DropdownSearchOnFind<T> = Future<List<T>> Function(String text);
typedef DropdownSearchItemAsString<T> = String Function(T item);
typedef DropdownSearchFilterFn<T> = bool Function(T item, String filter);
typedef DropdownSearchCompareFn<T> = bool Function(T item, T selectedItem);
typedef DropdownSearchBuilder<T> = Widget Function(
    BuildContext context, T selectedItem, String itemAsString);
typedef DropdownSearchPopupItemBuilder<T> = Widget Function(
  BuildContext context,
  T item,
  bool isSelected,
);
typedef DropdownSearchPopupItemEnabled<T> = bool Function(T item);
typedef ErrorBuilder<T> = Widget Function(
    BuildContext context, dynamic exception);
typedef DropdownSearchOnCreate<T> = Future<T> Function(String value);

enum Mode { DIALOG, MENU }

class DropdownSearch<T> extends StatefulWidget {
  ///DropDownSearch label
  final String label;

  ///DropDownSearch hint
  final String hint;

  ///show/hide the search box
  final bool showSearchBox;

  ///true if the filter on items is applied online (via API)
  final bool isFilteredOnline;

  ///show/hide clear selected item
  final bool showClearButton;

  ///offline items list
  final List<T> items;

  ///selected item
  final T selectedItem;

  ///function that returns item from API
  final DropdownSearchOnFind<T> onFind;

  ///called when a new item is selected
  final ValueChanged<T> onChanged;

  ///to customize list of items UI
  final DropdownSearchBuilder<T> dropdownBuilder;

  ///to customize selected item
  final DropdownSearchPopupItemBuilder<T> popupItemBuilder;

  ///decoration for search box
  final InputDecoration searchBoxDecoration;

  ///the title for dialog/menu/bottomSheet
  final Color popupBackgroundColor;

  ///custom widget for the popup title
  final Widget popupTitle;

  ///customize the fields the be shown
  final DropdownSearchItemAsString<T> itemAsString;

  ///	custom filter function
  final DropdownSearchFilterFn<T> filterFn;

  ///enable/disable dropdownSearch
  final bool enabled;

  ///MENU / DIALOG/ BOTTOM_SHEET
  final Mode mode;

  ///the max height for dialog/bottomSheet/Menu
  final double maxHeight;

  ///the max width for the dialog
  final double dialogMaxWidth;

  ///select the selected item in the menu/dialog/bottomSheet of items
  final bool showSelectedItem;

  ///function that compares two object with the same type to detected if it's the selected item or not
  final DropdownSearchCompareFn<T> compareFn;

  ///dropdownSearch input decoration
  final InputDecoration dropdownSearchDecoration;

  ///custom layout for empty results
  final WidgetBuilder emptyBuilder;

  ///custom layout for loading items
  final WidgetBuilder loadingBuilder;

  ///custom layout for error
  final ErrorBuilder errorBuilder;

  ///the search box will be focused if true
  final bool autoFocusSearchBox;

  ///custom shape for the popup
  final ShapeBorder popupShape;

  ///handle auto validation
  final bool autoValidate;

  /// An optional method to call with the final value when the form is saved via
  final FormFieldSetter<T> onSaved;

  /// An optional method that validates an input. Returns an error string to
  /// display if the input is invalid, or null otherwise.
  final FormFieldValidator<T> validator;

  ///custom dropdown clear button icon widget
  final Widget clearButton;

  ///custom dropdown icon button widget
  final Widget dropDownButton;

  ///If true, the dropdownBuilder will continue the uses of material behavior
  ///This will be useful if you want to handle a custom UI only if the item !=null
  final bool dropdownBuilderSupportsNullItem;

  ///defines if an item of the popup is enabled or not, if the item is disabled,
  ///it cannot be clicked
  final DropdownSearchPopupItemEnabled<T> popupItemDisabled;

  ///set a custom color for the popup barrier
  final Color popupBarrierColor;

  ///button used to trigger the create function
  final Widget createButton;

  ///function triggered when the create button is pressed
  final DropdownSearchOnCreate onCreate;

  ///show/hide the create button
  final bool showCreateButton;

  ///padding around the popup content
  final EdgeInsets popupPadding;

  ///text displayed when no data is found
  final String noDataText;

  DropdownSearch({
    Key key,
    this.onSaved,
    this.validator,
    this.autoValidate = false,
    this.onChanged,
    this.mode = Mode.DIALOG,
    this.label,
    this.hint,
    this.isFilteredOnline = false,
    this.popupTitle,
    this.items,
    this.selectedItem,
    this.onFind,
    this.dropdownBuilder,
    this.popupItemBuilder,
    this.showSearchBox = false,
    this.showClearButton = false,
    this.searchBoxDecoration,
    this.popupBackgroundColor,
    this.enabled = true,
    this.maxHeight,
    this.filterFn,
    this.itemAsString,
    this.showSelectedItem = false,
    this.compareFn,
    this.dropdownSearchDecoration,
    this.emptyBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.autoFocusSearchBox = false,
    this.dialogMaxWidth,
    this.clearButton,
    this.dropDownButton,
    this.dropdownBuilderSupportsNullItem = false,
    this.popupShape,
    this.popupItemDisabled,
    this.popupBarrierColor,
    this.popupPadding,
    this.createButton,
    this.onCreate,
    this.showCreateButton,
    this.noDataText,
  })  : assert(autoValidate != null),
        assert(isFilteredOnline != null),
        assert(dropdownBuilderSupportsNullItem != null),
        assert(enabled != null),
        assert(showSelectedItem != null),
        assert(autoFocusSearchBox != null),
        assert(showClearButton != null),
        assert(showSearchBox != null),
        assert(!showSelectedItem || T == String || compareFn != null),
        super(key: key);

  @override
  _DropdownSearchState<T> createState() => _DropdownSearchState<T>();
}

class _DropdownSearchState<T> extends State<DropdownSearch<T>> {
  final ValueNotifier<T> _selectedItemNotifier = ValueNotifier(null);
  final ValueNotifier<bool> _isFocused = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _selectedItemNotifier.value = widget.selectedItem;
  }

  @override
  void didUpdateWidget(DropdownSearch<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _selectedItemNotifier.value = widget.selectedItem;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T>(
      valueListenable: _selectedItemNotifier,
      builder: (context, T data, wt) {
        return IgnorePointer(
          ignoring: !widget.enabled,
          child: GestureDetector(
            onTap: () => _selectSearchMode(data),
            child: _formField(data),
          ),
        );
      },
    );
  }

  Widget _defaultSelectItemWidget(T data) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: widget.dropdownBuilder != null
              ? widget.dropdownBuilder(
                  context,
                  data,
                  _selectedItemAsString(data),
                )
              : Text(_selectedItemAsString(data),
                  style: Theme.of(context).textTheme.subtitle1),
        ),
        _manageTrailingIcons(data),
      ],
    );
  }

  Widget _formField(T value) {
    return FormField(
      enabled: widget.enabled,
      onSaved: widget.onSaved,
      validator: widget.validator,
      autovalidate: widget.autoValidate,
      initialValue: widget.selectedItem,
      builder: (FormFieldState<T> state) {
        if (state.value != value) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            state.didChange(value);
          });
        }
        return ValueListenableBuilder(
            valueListenable: _isFocused,
            builder: (context, bool isFocused, w) {
              return InputDecorator(
                isEmpty: value == null &&
                    (widget.dropdownBuilder == null ||
                        widget.dropdownBuilderSupportsNullItem),
                isFocused: isFocused,
                decoration: _manageDropdownDecoration(state),
                child: _defaultSelectItemWidget(value),
              );
            });
      },
    );
  }

  ///manage dropdownSearch field decoration
  InputDecoration _manageDropdownDecoration(FormFieldState state) {
    return (widget.dropdownSearchDecoration ??
            InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                border: OutlineInputBorder()))
        .applyDefaults(Theme.of(state.context).inputDecorationTheme)
        .copyWith(
            enabled: widget.enabled,
            labelText: widget.label,
            hintText: widget.hint,
            errorText: state.errorText);
  }

  ///function that return the String value of an object
  String _selectedItemAsString(T data) {
    if (data == null) {
      return '';
    } else if (widget.itemAsString != null) {
      return widget.itemAsString(data);
    } else {
      return data.toString();
    }
  }

  ///function that manage Trailing icons(close, dropDown)
  Widget _manageTrailingIcons(T data) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        if (data != null && widget.showClearButton)
          IconButton(
            icon: widget.clearButton ?? const Icon(Icons.clear, size: 24),
            onPressed: () => _handleOnChangeSelectedItem(null),
          ),
        IconButton(
          icon: widget.dropDownButton ??
              const Icon(Icons.arrow_drop_down, size: 24),
          onPressed: () => _selectSearchMode(data),
        ),
      ],
    );
  }

  ///open dialog
  Future<T> _openSelectDialog(T data) {
    return showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 400),
      barrierColor: widget.popupBarrierColor ?? const Color(0x80000000),
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          shape: widget.popupShape,
          backgroundColor: widget.popupBackgroundColor,
          content: _selectDialogInstance(data),
        );
      },
    );
  }

  SelectDialog<T> _selectDialogInstance(T data, {double defaultHeight}) {
    return SelectDialog<T>(
      popupTitle: widget.popupTitle,
      maxHeight: widget.maxHeight ?? defaultHeight,
      isFilteredOnline: widget.isFilteredOnline,
      itemAsString: widget.itemAsString,
      filterFn: widget.filterFn,
      items: widget.items,
      onFind: widget.onFind,
      showSearchBox: widget.showSearchBox,
      itemBuilder: widget.popupItemBuilder,
      selectedValue: data,
      searchBoxDecoration: widget.searchBoxDecoration,
      onChanged: _handleOnChangeSelectedItem,
      showSelectedItem: widget.showSelectedItem,
      compareFn: widget.compareFn,
      emptyBuilder: widget.emptyBuilder,
      loadingBuilder: widget.loadingBuilder,
      errorBuilder: widget.errorBuilder,
      autoFocusSearchBox: widget.autoFocusSearchBox,
      dialogMaxWidth: widget.dialogMaxWidth,
      itemDisabled: widget.popupItemDisabled,
      popupPadding: widget.popupPadding,
      createButton: widget.createButton,
      onCreate: widget.onCreate,
      showCreateButton: widget.showCreateButton,
      noDataText: widget.noDataText,
    );
  }

  ///Function that manage focus listener
  ///set true only if the widget already not focused to prevent unnecessary build
  ///same thing for clear focus,
  void _handleFocus(bool isFocused) {
    if (isFocused && !_isFocused.value) {
      FocusScope.of(context).unfocus();
      _isFocused.value = true;
    } else if (!isFocused && _isFocused.value) _isFocused.value = false;
  }

  ///handle on change value , if the validation is active , we validate the new selected item
  void _handleOnChangeSelectedItem(T selectedItem) {
    _selectedItemNotifier.value = selectedItem;
    if (widget.onChanged != null) widget.onChanged(selectedItem);
    _handleFocus(false);
  }

  ///Function that return then UI based on searchMode
  ///[data] selected item to be passed to the UI
  ///If we close the popup , or maybe we just selected
  ///another widget we should clear the focus
  Future<void> _selectSearchMode(T data) async {
    _handleFocus(true);

    await _openSelectDialog(data);

    _handleFocus(false);
  }
}

class SelectDialog<T> extends StatefulWidget {
  final T selectedValue;
  final List<T> items;
  final bool showSearchBox;
  final bool isFilteredOnline;
  final ValueChanged<T> onChanged;
  final DropdownSearchOnFind<T> onFind;
  final DropdownSearchPopupItemBuilder<T> itemBuilder;
  final InputDecoration searchBoxDecoration;
  final DropdownSearchItemAsString<T> itemAsString;
  final DropdownSearchFilterFn<T> filterFn;
  final String hintText;
  final double maxHeight;
  final double dialogMaxWidth;
  final Widget popupTitle;
  final bool showSelectedItem;
  final DropdownSearchCompareFn<T> compareFn;
  final DropdownSearchPopupItemEnabled<T> itemDisabled;
  final String noDataText;
  final EdgeInsets popupPadding;
  final Widget createButton;
  final bool showCreateButton;
  final DropdownSearchOnCreate onCreate;

  ///custom layout for empty results
  final WidgetBuilder emptyBuilder;

  ///custom layout for loading items
  final WidgetBuilder loadingBuilder;

  ///custom layout for error
  final ErrorBuilder errorBuilder;

  ///the search box will be focused if true
  final bool autoFocusSearchBox;

  const SelectDialog({
    Key key,
    this.popupTitle,
    this.items,
    this.maxHeight,
    this.showSearchBox = false,
    this.isFilteredOnline = false,
    this.onChanged,
    this.selectedValue,
    this.onFind,
    this.itemBuilder,
    this.searchBoxDecoration,
    this.hintText,
    this.itemAsString,
    this.filterFn,
    this.showSelectedItem = false,
    this.compareFn,
    this.emptyBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.autoFocusSearchBox = false,
    this.dialogMaxWidth,
    this.itemDisabled,
    this.noDataText = 'No data found',
    this.popupPadding = const EdgeInsets.all(0),
    this.createButton,
    this.onCreate,
    this.showCreateButton = false,
  }) : super(key: key);

  @override
  _SelectDialogState<T> createState() => _SelectDialogState<T>();
}

class _SelectDialogState<T> extends State<SelectDialog<T>> {
  final FocusNode focusNode = FocusNode();
  final StreamController<List<T>> _itemsStream = StreamController();
  final ValueNotifier<bool> _loadingNotifier = ValueNotifier(false);

  final List<T> _items = <T>[];
  final _debouncer = Debouncer();

  var _filterText = '';

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () => manageItemsByFilter('', isFistLoad: true),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.autoFocusSearchBox) {
      FocusScope.of(context).requestFocus(focusNode);
    }
  }

  @override
  void dispose() {
    _itemsStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    var isTablet = deviceSize.width > deviceSize.height;
    var maxHeight = deviceSize.height * (isTablet ? .8 : .6);
    var maxWidth = deviceSize.width * (isTablet ? .7 : .9);

    return Container(
      padding: widget.popupPadding,
      width: widget.dialogMaxWidth ?? maxWidth,
      constraints: BoxConstraints(maxHeight: widget.maxHeight ?? maxHeight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _searchField(),
          Expanded(
            child: Stack(
              children: <Widget>[
                StreamBuilder<List<T>>(
                  stream: _itemsStream.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return _errorWidget(snapshot?.error);
                    } else if (!snapshot.hasData) {
                      return _loadingWidget();
                    } else if (snapshot.data.isEmpty) {
                      if (widget.emptyBuilder != null) {
                        return widget.emptyBuilder(context);
                      } else {
                        return Center(
                          child: Text(widget.noDataText),
                        );
                      }
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        var item = snapshot.data[index];
                        return _itemWidget(item);
                      },
                    );
                  },
                ),
                _loadingWidget()
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(dynamic error) {
    showDialog(
      context: context,
      barrierDismissible: false,
      child: AlertDialog(
        title: Text('Error while getting online items'),
        content: _errorWidget(error),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          )
        ],
      ),
    );
  }

  Widget _errorWidget(dynamic error) {
    if (widget.errorBuilder != null) {
      return widget.errorBuilder(context, error);
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            error?.toString(),
          ),
        ),
      );
    }
  }

  Widget _loadingWidget() {
    return ValueListenableBuilder(
        valueListenable: _loadingNotifier,
        builder: (context, bool isLoading, wid) {
          if (isLoading) {
            if (widget.loadingBuilder != null) {
              return widget.loadingBuilder(context);
            } else {
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }
          return Container();
        });
  }

  void _onTextChanged(String filter) async {
    setState(() {
      _filterText = filter;
    });
    manageItemsByFilter(filter);
  }

  ///Function that filter item (online and offline) base on user filter
  ///[filter] is the filter keyword
  ///[isFistLoad] true if it's the first time we load data from online, false other wises
  void manageItemsByFilter(String filter, {bool isFistLoad = false}) async {
    _loadingNotifier.value = true;

    List<T> applyFilter(String filter) {
      return _items.where((i) {
        if (widget.filterFn != null) {
          return (widget.filterFn(i, filter));
        } else if (i.toString().toLowerCase().contains(filter.toLowerCase())) {
          return true;
        } else if (widget.itemAsString != null) {
          return (widget.itemAsString(i))
                  ?.toLowerCase()
                  ?.contains(filter.toLowerCase()) ??
              false;
        }
        return false;
      }).toList();
    }

    //load offline data for the first time
    if (isFistLoad && widget.items != null) _items.addAll(widget.items);

    //manage offline items
    if (widget.onFind != null && (widget.isFilteredOnline || isFistLoad)) {
      try {
        final onlineItems = <T>[];
        onlineItems.addAll(await widget.onFind(filter) ?? []);

        //Remove all old data
        _items.clear();
        //add offline items
        if (widget.items != null) _items.addAll(widget.items);
        //add new online items to list
        _items.addAll(onlineItems);

        _itemsStream.add(applyFilter(filter));
      } catch (e) {
        _itemsStream.addError(e);
        //if offline items count > 0 , the error will be not visible for the user
        //As solution we show it in dialog
        if (widget.items != null && widget.items.isNotEmpty) {
          _showErrorDialog(e);
          _itemsStream.add(applyFilter(filter));
        }
      }
    } else {
      _itemsStream.add(applyFilter(filter));
    }

    _loadingNotifier.value = false;
  }

  Widget _itemWidget(T item) {
    if (widget.itemBuilder != null) {
      return InkWell(
        child: widget.itemBuilder(
          context,
          item,
          _manageSelectedItemVisibility(item),
        ),
        onTap: widget.itemDisabled != null &&
                (widget.itemDisabled(item) ?? false) == true
            ? null
            : () {
                Navigator.pop(context, item);
                if (widget.onChanged != null) widget.onChanged(item);
              },
      );
    } else {
      return ListTile(
        title: Text(
          widget.itemAsString != null
              ? (widget.itemAsString(item) ?? '')
              : item.toString(),
        ),
        selected: _manageSelectedItemVisibility(item),
        onTap: widget.itemDisabled != null &&
                (widget.itemDisabled(item) ?? false) == true
            ? null
            : () {
                Navigator.pop(context, item);
                if (widget.onChanged != null) widget.onChanged(item);
              },
      );
    }
  }

  /// selected item will be highlighted only when [widget.showSelectedItem] is true,
  /// if our object is String [widget.compareFn] is not required , other wises it's required
  bool _manageSelectedItemVisibility(T item) {
    if (!widget.showSelectedItem) return false;

    if (T == String) {
      return item == widget.selectedValue;
    } else {
      return widget.compareFn(item, widget.selectedValue);
    }
  }

  Widget _searchField() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          widget.popupTitle ?? const SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                if (widget.showSearchBox)
                  Flexible(
                    child: TextField(
                      focusNode: focusNode,
                      onChanged: (f) => _debouncer(() {
                        _onTextChanged(f);
                      }),
                      decoration: widget.searchBoxDecoration ??
                          InputDecoration(
                            hintText: widget.hintText,
                            border: const OutlineInputBorder(),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                          ),
                    ),
                  ),
                if (widget.showCreateButton)
                  IconButton(
                    icon:
                        widget.createButton ?? const Icon(Icons.add, size: 24),
                    onPressed: _filterText.isNotEmpty
                        ? () async {
                            var createdItem =
                                await widget.onCreate(_filterText);
                            widget.onChanged(createdItem);
                          }
                        : null,
                  ),
              ],
            ),
          ),
        ]);
  }
}

class Debouncer {
  final Duration delay;
  Timer _timer;

  Debouncer({this.delay = const Duration(milliseconds: 500)});

  void call(Function action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }
}
