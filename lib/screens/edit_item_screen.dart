import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:hlamnik/database/entities/brand.dart';
import 'package:hlamnik/database/entities/category.dart';
import 'package:hlamnik/database/entities/color.dart' as entity;
import 'package:hlamnik/database/entities/item.dart' as entity;
import 'package:hlamnik/generated/locale_keys.g.dart';
import 'package:hlamnik/providers/items.dart';
import 'package:hlamnik/services/db_service.dart';
import 'package:hlamnik/themes/main_theme.dart';
import 'package:hlamnik/widgets/color_picker_input.dart';
import 'package:hlamnik/widgets/custom_dropdown_search.dart';
import 'package:hlamnik/widgets/image_input.dart';
import 'package:hlamnik/widgets/loading_indicator.dart';
import 'package:hlamnik/widgets/rating_input.dart';
import 'package:hlamnik/widgets/season_tags_input.dart';
import 'package:hlamnik/widgets/switch_input.dart';
import 'package:hlamnik/widgets/year_picker_input.dart';
import 'package:provider/provider.dart';
import 'package:supercharged/supercharged.dart';

///Screen used to edit/add new items
class EditItemScreen extends StatefulWidget {
  static const routeName = '/item/edit';

  @override
  _EditItemScreenState createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final titleController = TextEditingController();
  final commentController = TextEditingController();
  var _isLoading = false;
  entity.Item _editedItem = entity.Item(
    id: null,
    title: '',
    picture: '',
    comment: '',
    purchaseYear: DateTime.now().year.toString(),
    isBroken: false,
    rating: 2.5,
    quality: 2.5,
    categoryId: null,
    category: null,
    brandId: null,
    brand: null,
    seasons: [],
    colors: [],
  );
  String _seasonError;
  String _colorError;
  String _pictureError;
  Image img;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () {
        final entity.Item arg = ModalRoute.of(context).settings.arguments;
        if (arg != null) {
          setState(
            () {
              //Create a clone so we don't directly edit the item in the provider
              _editedItem = entity.Item.clone(arg);
              img = _editedItem.picture.isNotEmpty
                  ? Image.memory(
                      base64Decode(_editedItem.picture),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : null;
              titleController.text = _editedItem.title;
              commentController.text = _editedItem.comment;
            },
          );
        }
      },
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    commentController.dispose();
    super.dispose();
  }

  ///Sets the [List] of [entity.Color] of the [_editedItem] from the selected [List] of [Color]
  Future<void> _saveColors(List<Color> colors) async {
    final db = await DBService.getDatabase;
    var dbColors = <entity.Color>[];
    await Future.forEach(
      colors,
      (color) async => dbColors.add(
        await db.colorDao.findByCode(
          color.toString().substring(10, 16).toUpperCase(),
        ),
      ),
    );
    _setColors(dbColors);
    Navigator.of(context).pop();
    _colorValidation();
  }

  ///Adds an [entity.Color] to the [_editedItem]
  void _setColor(entity.Color dbColor) => setState(() {
        _editedItem.colors.add(dbColor);
      });

  ///Sets the [List] of [entity.Color] of the [_editedItem]
  void _setColors(List<entity.Color> dbColors) => setState(() {
        _editedItem.colors = dbColors;
      });

  ///Sets the picture of the [_editedItem] to the taken picture
  void _selectImage(String base64) {
    _editedItem.picture = base64;
    _pictureValidation();
  }

  ///Sets the [Category] of the [_editedItem] to the selected [Category]
  void _selectCategory(Category category) {
    _editedItem.category = category;
    _editedItem.categoryId = category.id;
  }

  ///Creates a new [Category] returns it
  Future<Category> _createCategory(String categoryLabel) async {
    final db = await DBService.getDatabase;
    var category = Category(name: categoryLabel);
    category.id = await db.categoryDao.insertValue(category);
    Navigator.of(context).pop();
    return category;
  }

  ///Sets the [Brand] of the [_editedItem] to the selected [Brand]
  void _selectBrand(Brand brand) {
    _editedItem.brand = brand;
    _editedItem.brandId = brand.id;
  }

  ///Creates a new [Brand] returns it
  Future<Brand> _createBrand(String brandLabel) async {
    final db = await DBService.getDatabase;
    var brand = Brand(name: brandLabel);
    brand.id = await db.brandDao.insertValue(brand);
    Navigator.of(context).pop();
    return brand;
  }

  ///Adds or removes a [Season] to the [_editedItem]
  void _toggleSeason(Item tag) {
    if (tag.active) {
      _editedItem.seasons.add(tag.customData);
    } else {
      _editedItem.seasons.removeWhere((season) => season.id == tag.index);
    }
    // Remove the focus if a textfield is still focused
    _unFocus();
    _seasonValidation();
  }

  ///Sets the rating of the [_editedItem] to the selected rating
  void _setRating(double rating) {
    // Remove the focus if a textfield is still focused
    _unFocus();
    _editedItem.rating = rating;
  }

  ///Sets the quality of the [_editedItem] to the selected quality
  void _setQuality(double quality) {
    // Remove the focus if a textfield is still focused
    _unFocus();
    _editedItem.quality = quality;
  }

  ///Sets the title of the [_editedItem] to the typed title
  void _setTitle(String title) => _editedItem.title = title;

  ///Sets the comment of the [_editedItem] to the typed comment
  void _setComment(String comment) => _editedItem.comment = comment;

  ///Sets the purchase year of the [_editedItem] to the selected year
  void _setPurchaseYear(int year) => setState(() {
        _editedItem.purchaseYear = year.toString();
        Navigator.of(context).pop();
      });

  ///Toggles the isBroken flag of the [_editedItem]
  void _toggleIsBroken(bool isBroken) {
    setState(() {
      _editedItem.isBroken = isBroken;
    });
  }

  ///Returns the list of [Category]
  Future<List<Category>> get _categories async {
    final db = await DBService.getDatabase;
    final categories = await db.categoryDao.listAll();
    return categories.sortedByString((category) => category.name.toLowerCase());
  }

  ///Returns the list of [Brand]
  Future<List<Brand>> get _brands async {
    final db = await DBService.getDatabase;
    final categories = await db.brandDao.listAll();
    return categories.sortedByString((brand) => brand.name.toLowerCase());
  }

  ///Validates the [Season] of the [_editedItem] and returns an error message
  ///The [_editedItem] needs to have one or more [Season]
  void _seasonValidation() {
    if (_editedItem.seasons.isEmpty) {
      setState(() {
        _seasonError = LocaleKeys.errorNoAction.tr(
          gender: 'female',
          args: [
            LocaleKeys.select.tr().toLowerCase(),
            LocaleKeys.season.tr().toLowerCase(),
          ],
        );
      });
    } else {
      setState(() {
        _seasonError = null;
      });
    }
  }

  ///Validates the [Color] of the [_editedItem] and returns an error message
  ///The [_editedItem] needs to have a [Color]
  void _colorValidation() {
    if (_editedItem.colors.isEmpty) {
      setState(() {
        _colorError = LocaleKeys.errorNoAction.tr(
          gender: 'female',
          args: [
            LocaleKeys.select.tr().toLowerCase(),
            LocaleKeys.color.tr().toLowerCase(),
          ],
        );
      });
    } else {
      setState(() {
        _colorError = null;
      });
    }
  }

  ///Validates the picture of the [_editedItem] and returns an error message
  ///The [_editedItem] needs to have a picture
  void _pictureValidation() {
    if (_editedItem.picture.isEmpty) {
      setState(() {
        _pictureError = LocaleKeys.errorNoAction.tr(
          gender: 'female',
          args: [
            LocaleKeys.take.tr().toLowerCase(),
            LocaleKeys.picture.tr().toLowerCase(),
          ],
        );
      });
    } else {
      setState(() {
        _pictureError = null;
      });
    }
  }

  ///Validates the entire form and saves the data if there is no error
  ///If the [_editedItem] has an id, updates the existing [Item] in the database
  ///Otherwise, adds a new [Item] in the database
  Future<void> _saveForm() async {
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

    setState(() {
      _isLoading = true;
    });

    _formKey.currentState.save();

    if (_editedItem.id != null) {
      await context.read<Items>().updateItem(_editedItem);
    } else {
      await context.read<Items>().addItem(_editedItem);
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  void _unFocus() => FocusScope.of(context).unfocus();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _unFocus,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            LocaleKeys.editItemScreenTitleAdd.tr(),
          ),
          actions: <Widget>[
            _isLoading
                ? LoadingIndicator(
                    color: AppColors.tertiaryColor,
                  )
                : IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: _saveForm,
                  ),
          ],
          centerTitle: true,
        ),
        body: _isLoading
            ? LoadingIndicator()
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Wrap(
                      runSpacing: 10,
                      children: <Widget>[
                        ImageInput(
                          onSelectImage: _selectImage,
                          defaultImage: img,
                          error: _pictureError,
                        ),
                        TextFormField(
                          controller: titleController,
                          decoration: InputDecoration(
                            labelText: LocaleKeys.title.tr(),
                          ),
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.next,
                          autocorrect: true,
                          validator: (value) {
                            if (value.isEmpty) {
                              return LocaleKeys.errorNoAction.tr(
                                gender: 'male',
                                args: [
                                  LocaleKeys.enter.tr().toLowerCase(),
                                  LocaleKeys.title.tr().toLowerCase(),
                                ],
                              );
                            }

                            if (value.length < 3) {
                              return LocaleKeys.errorMinLength.tr(
                                  gender: 'male',
                                  args: [LocaleKeys.title.tr().toLowerCase(), '3']);
                            }
                            return null;
                          },
                          onSaved: _setTitle,
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                        ),
                        YearPickerInput(
                          onYearChanged: _setPurchaseYear,
                          pickedYear: _editedItem.purchaseYear,
                          error: null,
                        ),
                        RatingInput(
                          label: LocaleKeys.rating.tr(),
                          initialValue: _editedItem.rating,
                          onPress: _setRating,
                        ),
                        RatingInput(
                          label: LocaleKeys.quality.tr(),
                          initialValue: _editedItem.quality,
                          onPress: _setQuality,
                        ),
                        CustomDropdownSearch<Category>(
                          label: LocaleKeys.category.tr(),
                          onFind: (_) async => _categories,
                          onChanged: _selectCategory,
                          selectedItem: _editedItem.category,
                          showCreateButton: true,
                          onCreate: _createCategory,
                        ),
                        CustomDropdownSearch<Brand>(
                          label: LocaleKeys.brand.tr(),
                          onFind: (_) async => _brands,
                          onChanged: _selectBrand,
                          selectedItem: _editedItem.brand,
                          showCreateButton: true,
                          onCreate: _createBrand,
                        ),
                        SeasonTagsInput(
                          onPress: _toggleSeason,
                          activeSeasons: _editedItem.seasons,
                          error: _seasonError,
                        ),
                        ColorPickerInput(
                          pickedColors: _editedItem.colors
                              .map((color) => color.getColor)
                              .toList(),
                          onSave: _saveColors,
                          error: _colorError,
                          showCreateButton: true,
                          onCreate: _setColor,
                        ),
                        SwitchInput(
                          label: LocaleKeys.isBrokenInput.tr(),
                          value: _editedItem.isBroken,
                          onChanged: _toggleIsBroken,
                        ),
                        TextFormField(
                          controller: commentController,
                          decoration: InputDecoration(
                            labelText: LocaleKeys.comment.tr(),
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
