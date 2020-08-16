import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hlamnik/database/entities/category.dart';
import 'package:hlamnik/database/entities/item.dart';
import 'package:hlamnik/database/entities/season.dart';
import 'package:hlamnik/models/filter.dart';
import 'package:hlamnik/providers/items.dart';
import 'package:hlamnik/screens/edit_item_screen.dart';
import 'package:hlamnik/screens/item_details_screen.dart';
import 'package:hlamnik/services/db_service.dart';
import 'package:hlamnik/themes/main_theme.dart';
import 'package:hlamnik/utils/bottom_sheet_utils.dart';
import 'package:hlamnik/widgets/color_form.dart';
import 'package:hlamnik/widgets/color_picker_input.dart';
import 'package:hlamnik/widgets/custom_dropdown_search.dart';
import 'package:hlamnik/widgets/loading_indicator.dart';
import 'package:hlamnik/widgets/modal_bottom_sheet_form.dart';
import 'package:hlamnik/widgets/rating_display.dart';
import 'package:hlamnik/widgets/rating_input.dart';
import 'package:provider/provider.dart';
import 'package:hlamnik/database/entities/color.dart' as entity;

///Screen used to display a list of [Item]
class ItemsOverviewScreen extends StatefulWidget {
  @override
  _ItemsOverviewScreenState createState() => _ItemsOverviewScreenState();
}

class _ItemsOverviewScreenState extends State<ItemsOverviewScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      context.read<Items>().loadItems().then((_) => setState(() {
            _isLoading = false;
          }));
    }

    _isInit = false;

    super.didChangeDependencies();
  }

  ///Refreshes the list of [Item]
  Future _refreshItems() async => await context.read<Items>().loadItems();

  ///Navigates to the [EditItemScreen]
  void _onAddPressed(BuildContext context) =>
      Navigator.of(context).pushNamed(EditItemScreen.routeName);

  ///Opens a bottom sheet to filter the list of [Item]
  void _onFilterPressed(BuildContext context) => showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15),
          ),
        ),
        builder: (_) => FilterModal(),
      );

  @override
  Widget build(BuildContext context) {
    final items = Provider.of<Items>(context).items;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'itemsOverviewScreenTitle'.tr(),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _onAddPressed(context),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => _onFilterPressed(context),
          ),
        ],
        centerTitle: true,
      ),
      drawer: MainDrawer(),
      body: _isLoading
          ? LoadingIndicator()
          : items.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'noItems'.tr(),
                      textAlign: TextAlign.center,
                    ),
                    IconButton(
                        icon: Icon(Icons.refresh), onPressed: _refreshItems),
                  ],
                )
              : RefreshIndicator(
                  onRefresh: _refreshItems,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                        childAspectRatio: 1,
                      ),
                      itemCount: items.length,
                      itemBuilder: (_, i) {
                        return ItemTile(items[i]);
                      },
                    ),
                  ),
                ),
      floatingActionButton: Platform.isAndroid
          ? FloatingActionButton(
              onPressed: () => _onAddPressed(context),
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}

///Widget used to filter the list of [Item]
class FilterModal extends StatefulWidget {
  @override
  _FilterModalState createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  var _isLoading = false;
  var _selectedColors = <entity.Color>[];
  Category _selectedCategory;
  Season _selectedSeason;
  final _filter = Filter();

  ///Returns a list of [Category]
  Future<List<Category>> get _categories async {
    final db = await DBService.getDatabase;
    return await db.categoryDao.listAll();
  }

  ///Returns a list of [Season]
  Future<List<Season>> get _seasons async {
    final db = await DBService.getDatabase;
    return await db.seasonDao.listAll();
  }

  ///Sets the rating of the [_filter] to the selected rating
  void _setRating(double rating) => _filter.rating = rating;

  ///Sets the quality of the [_filter] to the selected quality
  void _setQuality(double quality) => _filter.quality = quality;

  ///Sets the [Category] of the [_filter] to the selected category
  void _selectCategory(Category category) {
    _selectedCategory = category;
    _filter.categoryId = category.id;
  }

  ///Sets the [Season] of the [_filter] to the selected season
  void _selectSeason(Season season) {
    _selectedSeason = season;
    _filter.seasonId = season.id;
  }

  ///Sets the [List] of [Color] of the [_filter]
  Future<void> _selectColors(List<Color> colors) async {
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
    setState(() {
      _selectedColors = dbColors;
      _filter.colorIdList = dbColors.map((dbColor) => dbColor.id).toList();
    });
    Navigator.of(context).pop();
  }

  ///Filters the list of [Item] with the given [_filter]
  void _onSavePressed() async {
    setState(() {
      _isLoading = true;
    });
    await context.read<Items>().filterItems(_filter);
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheetForm(
      title: 'filter'.tr(),
      form: Wrap(
        runSpacing: 10,
        children: <Widget>[
          RatingInput(
            label: 'rating'.tr(),
            initialValue: _filter.rating,
            onPress: _setRating,
          ),
          RatingInput(
            label: 'quality'.tr(),
            initialValue: _filter.quality,
            onPress: _setQuality,
          ),
          CustomDropdownSearch<Category>(
            label: 'category'.tr(),
            onFind: (_) async => _categories,
            onChanged: _selectCategory,
            selectedItem: _selectedCategory,
          ),
          CustomDropdownSearch<Season>(
            label: 'season'.tr(),
            onFind: (_) async => _seasons,
            onChanged: _selectSeason,
            selectedItem: _selectedSeason,
          ),
          ColorPickerInput(
            pickedColors:
                _selectedColors.map((color) => color.getColor).toList(),
            onSave: _selectColors,
          ),
        ],
      ),
      saveForm: _onSavePressed,
      isLoading: _isLoading,
    );
  }
}

///Widget used to display an [Item] as a card
class ItemTile extends StatelessWidget {
  final Item item;

  ItemTile(this.item);

  @override
  Widget build(BuildContext context) {
    final imageBytes = base64Decode(item.picture);

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.secondaryColor),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: <Widget>[
            GridTile(
              child: Hero(
                tag: item.id,
                child: Image.memory(
                  imageBytes,
                  fit: BoxFit.cover,
                ),
              ),
              footer: GridTileBar(
                backgroundColor: AppColors.secondaryColor.withOpacity(0.6),
                title: Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Positioned(
              left: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                    color: AppColors.secondaryColor.withOpacity(0.6),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: RatingDisplay(
                  item.rating,
                  textColor: AppColors.primaryColor,
                ),
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: AppColors.primaryColor.withOpacity(0.4),
                  onTap: () => Navigator.of(context).pushNamed(
                    ItemDetailsScreen.routeName,
                    arguments: item.id,
                  ), //navigate to detailed screen of the item
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///Widget used to display the drawer
class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 100,
            child: DrawerHeader(
              child: Text('menu'.tr()),
            ),
          ),
          ListTile(
              title: Text('addSomething'
                  .tr(gender: 'female', args: ['category'.tr().toLowerCase()])),
              onTap: () {
                Navigator.of(context).pop();
                BottomSheetUtils.showCustomModalBottomSheet(
                  context: context,
                  builder: (_) => CategoryForm(),
                );
              }),
          ListTile(
            title: Text('addSomething'
                .tr(gender: 'female', args: ['color'.tr().toLowerCase()])),
            onTap: () {
              Navigator.of(context).pop();
              BottomSheetUtils.showCustomModalBottomSheet(
                context: context,
                builder: (_) => ColorForm(),
              );
            },
          ),
        ],
      ),
    );
  }
}

///Widget used to add a new [Category]
class CategoryForm extends StatefulWidget {
  @override
  _CategoryFormState createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _name = '';
  var _isLoading = false;

  ///Sets the [_name] to the selected name
  void _setName(String name) => _name = name;

  ///Validates and creates the new [Category]
  Future _saveForm() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _formKey.currentState.save();

    final db = await DBService.getDatabase;
    await db.categoryDao.insertValue(Category(id: null, name: _name));

    setState(() {
      _isLoading = false;
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheetForm(
      title: 'category'.tr(),
      form: Form(
        key: _formKey,
        child: TextFormField(
          decoration: InputDecoration(
            labelText: 'title'.tr(),
          ),
          textCapitalization: TextCapitalization.sentences,
          autocorrect: true,
          validator: (value) {
            if (value.isEmpty) {
              return 'errorNoAction'.tr(
                gender: 'male',
                args: [
                  'enter'.tr().toLowerCase(),
                  'title'.tr().toLowerCase(),
                ],
              );
            }

            if (value.length < 3) {
              return 'errorMinLength'
                  .tr(gender: 'male', args: ['title'.tr().toLowerCase(), '3']);
            }
            return null;
          },
          onSaved: _setName,
          //Should save
          onFieldSubmitted: (_) => _saveForm(),
        ),
      ),
      saveForm: _saveForm,
      isLoading: _isLoading,
    );
  }
}
