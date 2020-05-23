// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? join(await sqflite.getDatabasesPath(), name)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CategoryDao _categoryDaoInstance;

  ColorDao _colorDaoInstance;

  ItemDao _itemDaoInstance;

  SeasonDao _seasonDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    return sqflite.openDatabase(
      path,
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Category` (`id` INTEGER, `name` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Color` (`id` INTEGER, `code` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Item` (`id` INTEGER, `title` TEXT, `quality` REAL, `rating` REAL, `picture` TEXT, `comment` TEXT, `createdAt` TEXT, `color_id` INTEGER, `category_id` INTEGER, FOREIGN KEY (`color_id`) REFERENCES `Color` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`category_id`) REFERENCES `Category` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ItemSeason` (`item_id` INTEGER, `season_id` INTEGER, FOREIGN KEY (`item_id`) REFERENCES `Item` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`season_id`) REFERENCES `Season` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`item_id`, `season_id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Season` (`id` INTEGER, `name` TEXT, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
  }

  @override
  CategoryDao get categoryDao {
    return _categoryDaoInstance ??= _$CategoryDao(database, changeListener);
  }

  @override
  ColorDao get colorDao {
    return _colorDaoInstance ??= _$ColorDao(database, changeListener);
  }

  @override
  ItemDao get itemDao {
    return _itemDaoInstance ??= _$ItemDao(database, changeListener);
  }

  @override
  SeasonDao get seasonDao {
    return _seasonDaoInstance ??= _$SeasonDao(database, changeListener);
  }
}

class _$CategoryDao extends CategoryDao {
  _$CategoryDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _categoryInsertionAdapter = InsertionAdapter(
            database,
            'Category',
            (Category item) =>
                <String, dynamic>{'id': item.id, 'name': item.name});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _categoryMapper = (Map<String, dynamic> row) =>
      Category(id: row['id'] as int, name: row['name'] as String);

  final InsertionAdapter<Category> _categoryInsertionAdapter;

  @override
  Future<List<Category>> listAll() async {
    return _queryAdapter.queryList('SELECT * FROM Category',
        mapper: _categoryMapper);
  }

  @override
  Future<void> insertItem(Category item) async {
    await _categoryInsertionAdapter.insert(
        item, sqflite.ConflictAlgorithm.abort);
  }
}

class _$ColorDao extends ColorDao {
  _$ColorDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _colorInsertionAdapter = InsertionAdapter(
            database,
            'Color',
            (Color item) =>
                <String, dynamic>{'id': item.id, 'code': item.code});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _colorMapper = (Map<String, dynamic> row) =>
      Color(id: row['id'] as int, code: row['code'] as String);

  final InsertionAdapter<Color> _colorInsertionAdapter;

  @override
  Future<List<Color>> listAll() async {
    return _queryAdapter.queryList('SELECT * FROM Color', mapper: _colorMapper);
  }

  @override
  Future<void> insertItem(Color item) async {
    await _colorInsertionAdapter.insert(item, sqflite.ConflictAlgorithm.abort);
  }
}

class _$ItemDao extends ItemDao {
  _$ItemDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _itemInsertionAdapter = InsertionAdapter(
            database,
            'Item',
            (Item item) => <String, dynamic>{
                  'id': item.id,
                  'title': item.title,
                  'quality': item.quality,
                  'rating': item.rating,
                  'picture': item.picture,
                  'comment': item.comment,
                  'createdAt': item.createdAt,
                  'color_id': item.colorId,
                  'category_id': item.categoryId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _itemMapper = (Map<String, dynamic> row) => Item(
      id: row['id'] as int,
      title: row['title'] as String,
      quality: row['quality'] as double,
      rating: row['rating'] as double,
      picture: row['picture'] as String,
      comment: row['comment'] as String,
      colorId: row['color_id'] as int,
      categoryId: row['category_id'] as int);

  final InsertionAdapter<Item> _itemInsertionAdapter;

  @override
  Future<List<Item>> listAll() async {
    return _queryAdapter.queryList('SELECT * FROM Item', mapper: _itemMapper);
  }

  @override
  Future<Item> findItemById(int id) async {
    return _queryAdapter.query('SELECT * FROM Item WHERE id = ?',
        arguments: <dynamic>[id], mapper: _itemMapper);
  }

  @override
  Future<void> insertItem(Item item) async {
    await _itemInsertionAdapter.insert(item, sqflite.ConflictAlgorithm.abort);
  }
}

class _$SeasonDao extends SeasonDao {
  _$SeasonDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _seasonInsertionAdapter = InsertionAdapter(
            database,
            'Season',
            (Season item) =>
                <String, dynamic>{'id': item.id, 'name': item.name});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _seasonMapper = (Map<String, dynamic> row) =>
      Season(id: row['id'] as int, name: row['name'] as String);

  final InsertionAdapter<Season> _seasonInsertionAdapter;

  @override
  Future<List<Season>> listAll() async {
    return _queryAdapter.queryList('SELECT * FROM Season',
        mapper: _seasonMapper);
  }

  @override
  Future<void> insertItem(Season item) async {
    await _seasonInsertionAdapter.insert(item, sqflite.ConflictAlgorithm.abort);
  }
}
