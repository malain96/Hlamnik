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
import 'package:hlamnik/widgets/color_picker_input.dart';
import 'package:hlamnik/widgets/custom_dropdown_search.dart';
import 'package:hlamnik/widgets/loading_indicator.dart';
import 'package:hlamnik/widgets/rating_display.dart';
import 'package:hlamnik/widgets/rating_input.dart';
import 'package:provider/provider.dart';
import 'package:hlamnik/database/entities/color.dart' as entity;

//@TODO Add a drawer to add categories and colors

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
      context.read<Items>().loadItems().then((_) =>
          setState(() {
            _isLoading = false;
          }));
    }

    _isInit = false;

    super.didChangeDependencies();
  }

  Future _refreshItems() async => await context.read<Items>().loadItems();

  void _onAddPressed(BuildContext context) =>
      Navigator.of(context).pushNamed(EditItemScreen.routeName);

  void _onFilterPressed(BuildContext context) =>
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        builder: (_) => FilterModal(),
      );

  @override
  Widget build(BuildContext context) {
    final items = Provider
        .of<Items>(context)
        .items;

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
      body: _isLoading
          ? LoadingIndicator()
          : items.isEmpty
          ? Center(
        child: Text(
          'noItems'.tr(),
        ),
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

class FilterModal extends StatefulWidget {
  @override
  _FilterModalState createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  var _isLoading = false;
  Category _selectedCategory;
  Season _selectedSeason;
  entity.Color _selectedColor;
  var filter = Filter();

  Future<List<Category>> get _categories async {
    final db = await DBService.getDatabase;
    return await db.categoryDao.listAll();
  }

  Future<List<Season>> get _seasons async {
    final db = await DBService.getDatabase;
    return await db.seasonDao.listAll();
  }

  void _setRating(double rating) => filter.rating = rating;

  void _setQuality(double quality) => filter.quality = quality;

  void _selectCategory(Category category) {
    _selectedCategory = category;
    filter.categoryId = category.id;
  }

  void _selectSeason(Season season) {
    _selectedSeason = season;
    filter.seasonId = season.id;
  }

  Future _selectColor(Color color) async {
    final db = await DBService.getDatabase;
    final dbColor = await db.colorDao
        .findByCode(color.toString().substring(10, 16).toUpperCase());
    setState(() {
      _selectedColor = dbColor;
      filter.colorId = dbColor.id;
    });
    Navigator.of(context).pop();
  }

  void _onSavePressed() async {
    setState(() {
      _isLoading = true;
    });
    await context.read<Items>().filterItems(filter);
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      height: MediaQuery
          .of(context)
          .size
          .height / 1.5,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                      'filter'.tr(),
                      style: Theme
                          .of(context)
                          .textTheme
                          .headline6,
                    )),
                IconButton(
                  icon: Icon(Icons.check, size: 30),
                  onPressed: _onSavePressed,
                ),
              ],
            ),
            _isLoading
                ? LoadingIndicator()
                : Column(
              children: <Widget>[
                RatingInput(
                  label: 'rating'.tr(),
                  initialValue: filter.rating,
                  onPress: _setRating,
                ),
                SizedBox(
                  height: 10,
                ),
                RatingInput(
                  label: 'quality'.tr(),
                  initialValue: filter.quality,
                  onPress: _setQuality,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomDropdownSearch<Category>(
                  label: 'category'.tr(),
                  onFind: (_) async => _categories,
                  onChanged: _selectCategory,
                  selectedItem: _selectedCategory,
                ),
                SizedBox(
                  height: 10,
                ),
                CustomDropdownSearch<Season>(
                  label: 'season'.tr(),
                  onFind: (_) async => _seasons,
                  onChanged: _selectSeason,
                  selectedItem: _selectedSeason,
                ),
                SizedBox(
                  height: 10,
                ),
                ColorPickerInput(
                  pickedColor: _selectedColor?.getColor,
                  onColorChanged: _selectColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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
                  onTap: () =>
                      Navigator.of(context).pushNamed(
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