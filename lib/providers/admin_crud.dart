import 'package:flutter/material.dart';
import 'package:hlamnik/database/entities/brand.dart';
import 'package:hlamnik/database/entities/category.dart';
import 'package:hlamnik/services/db_service.dart';
import 'package:supercharged/supercharged.dart';

class AdminCrud with ChangeNotifier {
  List<Category> _categories = [];
  List<Brand> _brands = [];

  ///Returns the list of [Category]
  List<Category> get categories {
    return _categories;
  }

  ///Returns the list of [Brand]
  List<Brand> get brands {
    return _brands;
  }

  ///Retrieves all [Category] from the database and store it in [_categories]
  Future<void> loadCategories() async {
    final db = await DBService.getDatabase;
    _categories = await db.categoryDao.listAll();
    notifyListeners();
  }

  ///Retrieves all [Brand] from the database and store it in [_brands]
  Future<void> loadBrands() async {
    final db = await DBService.getDatabase;
    _brands = await db.brandDao.listAll();
    notifyListeners();
  }

  ///Adds a new [Category] in the database and in [_categories]
  Future<void> addCategory(String value) async {
    final db = await DBService.getDatabase;
    try {
      final id =
          await db.categoryDao.insertValue(Category(id: null, name: value));
      _categories.add(
        Category(
          id: id,
          name: value,
        ),
      );
      _categories = _categories.sortedByString((p) => p.name);
      notifyListeners();
    } catch (_) {
      rethrow;
    }
  }

  ///Removes the [Category] at the given [index] in the database and in [_categories]
  Future<void> removeCategory(int index) async {
    final db = await DBService.getDatabase;
    try {
      await db.categoryDao.deleteValue(_categories[index]);
      _categories.removeAt(index);
      notifyListeners();
    } catch (_) {
      rethrow;
    }
  }

  ///Updates the [Category] with the given [id] in the database and in [_categories]
  Future<void> editCategory(int id, String value) async {
    final db = await DBService.getDatabase;
    try {
      final category = Category(id: id, name: value);
      await db.categoryDao.updateValue(category);
      _categories.removeWhere((category) => category.id == id);
      _categories.add(category);
      _categories = _categories.sortedByString((p) => p.name);
      notifyListeners();
    } catch (_) {
      rethrow;
    }
  }

  ///Adds a new [Brand] in the database and in [_brands]
  Future<void> addBrand(String value) async {
    final db = await DBService.getDatabase;
    try {
      final id = await db.brandDao.insertValue(Brand(id: null, name: value));
      _brands.add(
        Brand(
          id: id,
          name: value,
        ),
      );
      _brands = _brands.sortedByString((p) => p.name);
      notifyListeners();
    } catch (_) {
      rethrow;
    }
  }

  ///Removes the [Brand] at the given [index] in the database and in [_brands]
  Future<void> removeBrand(int index) async {
    final db = await DBService.getDatabase;
    try {
      await db.brandDao.deleteValue(_brands[index]);
      _brands.removeAt(index);
      notifyListeners();
    } catch (_) {
      rethrow;
    }
  }

  ///Updates the [Brand] with the given [id] in the database and in [_brands]
  Future<void> editBrand(int id, String value) async {
    final db = await DBService.getDatabase;
    try {
      final brand = Brand(id: id, name: value);
      await db.brandDao.updateValue(brand);
      _brands.removeWhere((brand) => brand.id == id);
      _brands.add(brand);
      _brands = _brands.sortedByString((p) => p.name);
      notifyListeners();
    } catch (_) {
      rethrow;
    }
  }
}
