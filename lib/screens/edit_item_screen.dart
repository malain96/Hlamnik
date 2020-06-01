import 'package:flutter/material.dart';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:hlamnik/database/entities/category.dart';
import 'package:hlamnik/database/entities/color.dart' as Entity;
import 'package:hlamnik/database/entities/item.dart' as Entity;
import 'package:hlamnik/database/entities/season.dart';
import 'package:hlamnik/providers/items.dart';
import 'package:hlamnik/services/db_service.dart';
import 'package:hlamnik/themes/main_theme.dart';
import 'package:hlamnik/widgets/error_text.dart';
import 'package:hlamnik/widgets/image_input.dart';
import 'package:hlamnik/widgets/input_bordered.dart';
import 'package:hlamnik/widgets/loading_indicator.dart';
import 'package:hlamnik/widgets/rating_input.dart';
import 'package:provider/provider.dart';

//@Todo Extract some widgets to make the tree more readable
//@Todo add the edit logic

class EditItemScreen extends StatefulWidget {
  static const routeName = '/edit-item';

  @override
  _EditItemScreenState createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _editedItem = Entity.Item(
      id: null,
      title: '',
      picture: '',
      comment: '',
      rating: 2.5,
      quality: 2.5,
      colorId: null,
      color: null,
      categoryId: null,
      category: null,
      seasons: []);
  var _isLoading = false;
  String _seasonError;
  String _colorError;
  String _pictureError;
  var _autoValidateTitle = false;
  var _autoValidateCategory = false;

  Future _changeColor(Color color) async {
    final db = await DBService.getDatabase;
    final dbColor = await db.colorDao
        .findByCode(color.toString().substring(10, 16).toUpperCase());
    setState(() {
      _editedItem.color = dbColor;
      _editedItem.colorId = dbColor.id;
    });
    Navigator.of(context).pop();
    _colorValidation();
  }

  void _selectImage(String path) {
    _editedItem.picture = path;
    _pictureValidation();
  }

  void _selectCategory(Category category) {
    _editedItem.category = category;
    _editedItem.categoryId = category.id;
    if (!_autoValidateCategory)
      setState(() {
        _autoValidateCategory = true;
      });
  }

  void _toggleSeason(Item tag) {
    if (tag.active)
      _editedItem.seasons.add(tag.customData);
    else
      _editedItem.seasons.removeWhere((season) => season.id == tag.index);

    _seasonValidation();
  }

  void _setRating(double rating) => _editedItem.rating = rating;

  void _setQuality(double quality) => _editedItem.quality = quality;

  void _setTitle(String title) =>_editedItem.title = title;

  void _setComment(String comment) => _editedItem.comment = comment;

  Future<List<Category>> get _categories async {
    final db = await DBService.getDatabase;
    return await db.categoryDao.listAll();
  }

  Future<List<Entity.Color>> get _colors async {
    final db = await DBService.getDatabase;
    return await db.colorDao.listAll();
  }

  Future<List<Season>> get _seasons async {
    final db = await DBService.getDatabase;
    return await db.seasonDao.listAll();
  }

  void _seasonValidation() {
    if (_editedItem.seasons.length == 0)
      setState(() {
        _seasonError = 'errorNoAction'.tr(
          gender: 'female',
          args: [
            'select'.tr().toLowerCase(),
            'season'.tr().toLowerCase(),
          ],
        );
      });
    else
      setState(() {
        _seasonError = null;
      });
  }

  void _colorValidation() {
    if (_editedItem.seasons.length == 0)
      setState(() {
        _colorError = 'errorNoAction'.tr(
          gender: 'female',
          args: [
            'select'.tr().toLowerCase(),
            'color'.tr().toLowerCase(),
          ],
        );
      });
    else
      setState(() {
        _colorError = null;
      });
  }

  void _pictureValidation() {
    if (_editedItem.picture.isEmpty)
      setState(() {
        _pictureError = 'errorNoAction'.tr(
          gender: 'female',
          args: [
            'take'.tr().toLowerCase(),
            'picture'.tr().toLowerCase(),
          ],
        );
      });
    else
      setState(() {
        _pictureError = null;
      });
  }

  void _titleValidation() {
    if (!_autoValidateTitle)
      setState(() {
        _autoValidateTitle = true;
      });
  }

  void _saveForm() {
    _seasonValidation();
    _colorValidation();
    _pictureValidation();

    if (_formKey.currentState.validate() &&
        _seasonError == null &&
        _colorError == null &&
        _pictureError == null) {
    } else {
      return;
    }

    if (_editedItem.id != null) {
      //update
    } else
      context.read<Items>().addItem(_editedItem);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'editItemScreenTitleAdd'.tr(),
          ),
          actions: <Widget>[
            _isLoading
                ? LoadingIndicator(
                    color: kTertiaryColor,
                  )
                : IconButton(
                    icon: const Icon(Icons.save),
                    onPressed: _saveForm,
                  ),
          ],
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ImageInput(
                    onSelectImage: _selectImage,
                    error: _pictureError,
                  ),
                  SizedBox(
                    height: 17,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'title'.tr(),
                    ),
                    textInputAction: TextInputAction.next,
                    autocorrect: true,
                    autovalidate: _autoValidateTitle,
                    onChanged: (_) => _titleValidation,
                    validator: (value) {
                      if (value.isEmpty)
                        return 'errorNoAction'.tr(
                          gender: 'male',
                          args: [
                            'enter'.tr().toLowerCase(),
                            'title'.tr().toLowerCase(),
                          ],
                        );

                      if (value.length < 3)
                        return 'errorMinLength'.tr(
                            gender: 'male',
                            args: ['title'.tr().toLowerCase(), '3']);
                      return null;
                    },
                    onSaved: _setTitle,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RatingInput(
                    label: 'rating'.tr(),
                    initialValue: _editedItem.rating,
                    onPress: _setRating,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RatingInput(
                    label: 'quality'.tr(),
                    initialValue: _editedItem.quality,
                    onPress: _setQuality,
                  ),
                  SizedBox(
                    height: 17,
                  ),
                  DropdownSearch<Category>(
                    dropDownSearchDecoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 7, horizontal: 13),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: kPrimaryColor),
                      ),
                    ),
                    mode: Mode.DIALOG,
                    onFind: (_) async => await _categories,
                    label: 'category'.tr(),
                    onChanged: _selectCategory,
                    selectedItem: _editedItem.category,
                    autoValidate: _autoValidateCategory,
                    validator: (Category item) {
                      if (item == null)
                        return 'errorNoAction'.tr(
                          gender: 'female',
                          args: [
                            'select'.tr().toLowerCase(),
                            'category'.tr().toLowerCase(),
                          ],
                        );
                      else
                        return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FutureBuilder<List<Season>>(
                      future: _seasons,
                      builder: (context, seasonsSnapshot) {
                        return InputBordered(
                          childLeftPadding: 13,
                          childTopPadding: 23,
                          label: 'seasons'.tr(),
                          error: _seasonError,
                          child: Tags(
                            alignment: WrapAlignment.start,
                            itemCount: seasonsSnapshot.hasData
                                ? seasonsSnapshot.data.length
                                : 0,
                            itemBuilder: seasonsSnapshot.hasData
                                ? (int index) {
                                    final season = seasonsSnapshot.data[index];
                                    return ItemTags(
                                      key: Key(index.toString()),
                                      index: season.id,
                                      title: season.name,
                                      customData: season,
                                      active: false,
                                      combine: ItemTagsCombine.withTextBefore,
                                      icon: ItemTagsIcon(
                                        icon: Icons.add,
                                      ),
                                      color: kTertiaryColor,
                                      activeColor: kPrimaryColor,
                                      textColor: kSecondaryColor,
                                      textActiveColor: kSecondaryColor,
                                      onPressed: _toggleSeason,
                                    );
                                  }
                                : null,
                          ),
                        );
                      }),
                  SizedBox(
                    height: 17,
                  ),
                  FutureBuilder<List<Entity.Color>>(
                      future: _colors,
                      builder: (context, colorsSnapshot) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: RaisedButton(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  side: BorderSide(
                                      color: _colorError != null
                                          ? Theme.of(context).errorColor
                                          : kSecondaryColor),
                                ),
                                onPressed: colorsSnapshot.hasData
                                    ? () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              backgroundColor: kTertiaryColor,
                                              title: Text('selectSomething'.tr(
                                                  gender: 'female',
                                                  args: [
                                                    'color'.tr().toLowerCase()
                                                  ])),
                                              content: SingleChildScrollView(
                                                child: BlockPicker(
                                                  pickerColor: _editedItem
                                                          .color?.getColor ??
                                                      kTertiaryColor,
                                                  onColorChanged: _changeColor,
                                                  availableColors:
                                                      colorsSnapshot.data
                                                          .map((color) =>
                                                              color.getColor)
                                                          .toList(),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }
                                    : null,
                                child: Text('color'.tr()),
                                color: _editedItem.color?.getColor ??
                                    kTertiaryColor,
                                textColor: useWhiteForeground(
                                        _editedItem.color?.getColor ??
                                            kTertiaryColor)
                                    ? kTertiaryColor
                                    : kSecondaryColor,
                              ),
                            ),
                            if (_colorError != null) ErrorText(_colorError),
                          ],
                        );
                      }),
                  SizedBox(
                    height: 17,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'comment'.tr(),
                    ),
                    onSaved: _setComment,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
