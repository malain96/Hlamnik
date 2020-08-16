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
        ? await sqfliteDatabaseFactory.getDatabasePath(name)
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

  ItemSeasonDao _itemSeasonDaoInstance;

  ItemColorDao _itemColorDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
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
            'CREATE TABLE IF NOT EXISTS `Item` (`id` INTEGER, `title` TEXT, `quality` REAL, `rating` REAL, `picture` TEXT, `comment` TEXT, `createdAt` TEXT, `category_id` INTEGER, FOREIGN KEY (`category_id`) REFERENCES `Category` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ItemSeason` (`item_id` INTEGER, `season_id` INTEGER, FOREIGN KEY (`item_id`) REFERENCES `Item` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`season_id`) REFERENCES `Season` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`item_id`, `season_id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ItemColor` (`item_id` INTEGER, `color_id` INTEGER, FOREIGN KEY (`item_id`) REFERENCES `Item` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`color_id`) REFERENCES `Color` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`item_id`, `color_id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Season` (`id` INTEGER, `name` TEXT, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
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

  @override
  ItemSeasonDao get itemSeasonDao {
    return _itemSeasonDaoInstance ??= _$ItemSeasonDao(database, changeListener);
  }

  @override
  ItemColorDao get itemColorDao {
    return _itemColorDaoInstance ??= _$ItemColorDao(database, changeListener);
  }
}

class _$CategoryDao extends CategoryDao {
  _$CategoryDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _categoryInsertionAdapter = InsertionAdapter(
            database,
            'Category',
            (Category item) =>
                <String, dynamic>{'id': item.id, 'name': item.name}),
        _categoryUpdateAdapter = UpdateAdapter(
            database,
            'Category',
            ['id'],
            (Category item) =>
                <String, dynamic>{'id': item.id, 'name': item.name}),
        _categoryDeletionAdapter = DeletionAdapter(
            database,
            'Category',
            ['id'],
            (Category item) =>
                <String, dynamic>{'id': item.id, 'name': item.name});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _categoryMapper = (Map<String, dynamic> row) =>
      Category(id: row['id'] as int, name: row['name'] as String);

  final InsertionAdapter<Category> _categoryInsertionAdapter;

  final UpdateAdapter<Category> _categoryUpdateAdapter;

  final DeletionAdapter<Category> _categoryDeletionAdapter;

  @override
  Future<List<Category>> listAll() async {
    return _queryAdapter.queryList('SELECT * FROM Category',
        mapper: _categoryMapper);
  }

  @override
  Future<Category> findById(int id) async {
    return _queryAdapter.query('SELECT * FROM Category WHERE id = ?',
        arguments: <dynamic>[id], mapper: _categoryMapper);
  }

  @override
  Future<int> insertValue(Category value) {
    return _categoryInsertionAdapter.insertAndReturnId(
        value, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertValues(List<Category> values) {
    return _categoryInsertionAdapter.insertListAndReturnIds(
        values, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateValue(Category value) {
    return _categoryUpdateAdapter.updateAndReturnChangedRows(
        value, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateValues(List<Category> values) {
    return _categoryUpdateAdapter.updateListAndReturnChangedRows(
        values, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteValue(Category value) {
    return _categoryDeletionAdapter.deleteAndReturnChangedRows(value);
  }

  @override
  Future<int> deleteValues(List<Category> values) {
    return _categoryDeletionAdapter.deleteListAndReturnChangedRows(values);
  }
}

class _$ColorDao extends ColorDao {
  _$ColorDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _colorInsertionAdapter = InsertionAdapter(
            database,
            'Color',
            (Color item) =>
                <String, dynamic>{'id': item.id, 'code': item.code}),
        _colorUpdateAdapter = UpdateAdapter(
            database,
            'Color',
            ['id'],
            (Color item) =>
                <String, dynamic>{'id': item.id, 'code': item.code}),
        _colorDeletionAdapter = DeletionAdapter(
            database,
            'Color',
            ['id'],
            (Color item) =>
                <String, dynamic>{'id': item.id, 'code': item.code});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _colorMapper = (Map<String, dynamic> row) =>
      Color(id: row['id'] as int, code: row['code'] as String);

  final InsertionAdapter<Color> _colorInsertionAdapter;

  final UpdateAdapter<Color> _colorUpdateAdapter;

  final DeletionAdapter<Color> _colorDeletionAdapter;

  @override
  Future<List<Color>> listAll() async {
    return _queryAdapter.queryList('SELECT * FROM Color', mapper: _colorMapper);
  }

  @override
  Future<Color> findByCode(String code) async {
    return _queryAdapter.query('SELECT * FROM Color WHERE code = ?',
        arguments: <dynamic>[code], mapper: _colorMapper);
  }

  @override
  Future<Color> findById(int id) async {
    return _queryAdapter.query('SELECT * FROM Color WHERE id = ?',
        arguments: <dynamic>[id], mapper: _colorMapper);
  }

  @override
  Future<List<Color>> findByIds(List<int> ids) async {
    final valueList1 = ids.map((value) => "'$value'").join(', ');
    return _queryAdapter.queryList(
        'SELECT * FROM Color WHERE id IN ($valueList1)',
        mapper: _colorMapper);
  }

  @override
  Future<int> insertValue(Color value) {
    return _colorInsertionAdapter.insertAndReturnId(
        value, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertValues(List<Color> values) {
    return _colorInsertionAdapter.insertListAndReturnIds(
        values, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateValue(Color value) {
    return _colorUpdateAdapter.updateAndReturnChangedRows(
        value, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateValues(List<Color> values) {
    return _colorUpdateAdapter.updateListAndReturnChangedRows(
        values, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteValue(Color value) {
    return _colorDeletionAdapter.deleteAndReturnChangedRows(value);
  }

  @override
  Future<int> deleteValues(List<Color> values) {
    return _colorDeletionAdapter.deleteListAndReturnChangedRows(values);
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
                  'category_id': item.categoryId
                }),
        _itemUpdateAdapter = UpdateAdapter(
            database,
            'Item',
            ['id'],
            (Item item) => <String, dynamic>{
                  'id': item.id,
                  'title': item.title,
                  'quality': item.quality,
                  'rating': item.rating,
                  'picture': item.picture,
                  'comment': item.comment,
                  'createdAt': item.createdAt,
                  'category_id': item.categoryId
                }),
        _itemDeletionAdapter = DeletionAdapter(
            database,
            'Item',
            ['id'],
            (Item item) => <String, dynamic>{
                  'id': item.id,
                  'title': item.title,
                  'quality': item.quality,
                  'rating': item.rating,
                  'picture': item.picture,
                  'comment': item.comment,
                  'createdAt': item.createdAt,
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
      categoryId: row['category_id'] as int);

  final InsertionAdapter<Item> _itemInsertionAdapter;

  final UpdateAdapter<Item> _itemUpdateAdapter;

  final DeletionAdapter<Item> _itemDeletionAdapter;

  @override
  Future<List<Item>> listAll() async {
    return _queryAdapter.queryList('SELECT * FROM Item', mapper: _itemMapper);
  }

  @override
  Future<int> insertValue(Item value) {
    return _itemInsertionAdapter.insertAndReturnId(
        value, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertValues(List<Item> values) {
    return _itemInsertionAdapter.insertListAndReturnIds(
        values, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateValue(Item value) {
    return _itemUpdateAdapter.updateAndReturnChangedRows(
        value, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateValues(List<Item> values) {
    return _itemUpdateAdapter.updateListAndReturnChangedRows(
        values, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteValue(Item value) {
    return _itemDeletionAdapter.deleteAndReturnChangedRows(value);
  }

  @override
  Future<int> deleteValues(List<Item> values) {
    return _itemDeletionAdapter.deleteListAndReturnChangedRows(values);
  }
}

class _$SeasonDao extends SeasonDao {
  _$SeasonDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _seasonInsertionAdapter = InsertionAdapter(
            database,
            'Season',
            (Season item) =>
                <String, dynamic>{'id': item.id, 'name': item.name}),
        _seasonUpdateAdapter = UpdateAdapter(
            database,
            'Season',
            ['id'],
            (Season item) =>
                <String, dynamic>{'id': item.id, 'name': item.name}),
        _seasonDeletionAdapter = DeletionAdapter(
            database,
            'Season',
            ['id'],
            (Season item) =>
                <String, dynamic>{'id': item.id, 'name': item.name});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _seasonMapper = (Map<String, dynamic> row) =>
      Season(id: row['id'] as int, name: row['name'] as String);

  final InsertionAdapter<Season> _seasonInsertionAdapter;

  final UpdateAdapter<Season> _seasonUpdateAdapter;

  final DeletionAdapter<Season> _seasonDeletionAdapter;

  @override
  Future<List<Season>> listAll() async {
    return _queryAdapter.queryList('SELECT * FROM Season',
        mapper: _seasonMapper);
  }

  @override
  Future<List<Season>> findByIds(List<int> ids) async {
    final valueList1 = ids.map((value) => "'$value'").join(', ');
    return _queryAdapter.queryList(
        'SELECT * FROM Season WHERE id IN ($valueList1)',
        mapper: _seasonMapper);
  }

  @override
  Future<int> insertValue(Season value) {
    return _seasonInsertionAdapter.insertAndReturnId(
        value, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertValues(List<Season> values) {
    return _seasonInsertionAdapter.insertListAndReturnIds(
        values, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateValue(Season value) {
    return _seasonUpdateAdapter.updateAndReturnChangedRows(
        value, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateValues(List<Season> values) {
    return _seasonUpdateAdapter.updateListAndReturnChangedRows(
        values, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteValue(Season value) {
    return _seasonDeletionAdapter.deleteAndReturnChangedRows(value);
  }

  @override
  Future<int> deleteValues(List<Season> values) {
    return _seasonDeletionAdapter.deleteListAndReturnChangedRows(values);
  }
}

class _$ItemSeasonDao extends ItemSeasonDao {
  _$ItemSeasonDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _itemSeasonInsertionAdapter = InsertionAdapter(
            database,
            'ItemSeason',
            (ItemSeason item) => <String, dynamic>{
                  'item_id': item.itemId,
                  'season_id': item.seasonId
                }),
        _itemSeasonUpdateAdapter = UpdateAdapter(
            database,
            'ItemSeason',
            ['item_id', 'season_id'],
            (ItemSeason item) => <String, dynamic>{
                  'item_id': item.itemId,
                  'season_id': item.seasonId
                }),
        _itemSeasonDeletionAdapter = DeletionAdapter(
            database,
            'ItemSeason',
            ['item_id', 'season_id'],
            (ItemSeason item) => <String, dynamic>{
                  'item_id': item.itemId,
                  'season_id': item.seasonId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _itemSeasonMapper = (Map<String, dynamic> row) => ItemSeason(
      itemId: row['item_id'] as int, seasonId: row['season_id'] as int);

  final InsertionAdapter<ItemSeason> _itemSeasonInsertionAdapter;

  final UpdateAdapter<ItemSeason> _itemSeasonUpdateAdapter;

  final DeletionAdapter<ItemSeason> _itemSeasonDeletionAdapter;

  @override
  Future<List<ItemSeason>> findSeasonIdsByItem(int itemId) async {
    return _queryAdapter.queryList('SELECT * FROM ItemSeason WHERE item_id=?',
        arguments: <dynamic>[itemId], mapper: _itemSeasonMapper);
  }

  @override
  Future<int> insertValue(ItemSeason value) {
    return _itemSeasonInsertionAdapter.insertAndReturnId(
        value, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertValues(List<ItemSeason> values) {
    return _itemSeasonInsertionAdapter.insertListAndReturnIds(
        values, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateValue(ItemSeason value) {
    return _itemSeasonUpdateAdapter.updateAndReturnChangedRows(
        value, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateValues(List<ItemSeason> values) {
    return _itemSeasonUpdateAdapter.updateListAndReturnChangedRows(
        values, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteValue(ItemSeason value) {
    return _itemSeasonDeletionAdapter.deleteAndReturnChangedRows(value);
  }

  @override
  Future<int> deleteValues(List<ItemSeason> values) {
    return _itemSeasonDeletionAdapter.deleteListAndReturnChangedRows(values);
  }
}

class _$ItemColorDao extends ItemColorDao {
  _$ItemColorDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _itemColorInsertionAdapter = InsertionAdapter(
            database,
            'ItemColor',
            (ItemColor item) => <String, dynamic>{
                  'item_id': item.itemId,
                  'color_id': item.colorId
                }),
        _itemColorUpdateAdapter = UpdateAdapter(
            database,
            'ItemColor',
            ['item_id', 'color_id'],
            (ItemColor item) => <String, dynamic>{
                  'item_id': item.itemId,
                  'color_id': item.colorId
                }),
        _itemColorDeletionAdapter = DeletionAdapter(
            database,
            'ItemColor',
            ['item_id', 'color_id'],
            (ItemColor item) => <String, dynamic>{
                  'item_id': item.itemId,
                  'color_id': item.colorId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _itemColorMapper = (Map<String, dynamic> row) =>
      ItemColor(itemId: row['item_id'] as int, colorId: row['color_id'] as int);

  final InsertionAdapter<ItemColor> _itemColorInsertionAdapter;

  final UpdateAdapter<ItemColor> _itemColorUpdateAdapter;

  final DeletionAdapter<ItemColor> _itemColorDeletionAdapter;

  @override
  Future<List<ItemColor>> findColorIdsByItem(int itemId) async {
    return _queryAdapter.queryList('SELECT * FROM ItemColor WHERE item_id=?',
        arguments: <dynamic>[itemId], mapper: _itemColorMapper);
  }

  @override
  Future<int> insertValue(ItemColor value) {
    return _itemColorInsertionAdapter.insertAndReturnId(
        value, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertValues(List<ItemColor> values) {
    return _itemColorInsertionAdapter.insertListAndReturnIds(
        values, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateValue(ItemColor value) {
    return _itemColorUpdateAdapter.updateAndReturnChangedRows(
        value, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateValues(List<ItemColor> values) {
    return _itemColorUpdateAdapter.updateListAndReturnChangedRows(
        values, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteValue(ItemColor value) {
    return _itemColorDeletionAdapter.deleteAndReturnChangedRows(value);
  }

  @override
  Future<int> deleteValues(List<ItemColor> values) {
    return _itemColorDeletionAdapter.deleteListAndReturnChangedRows(values);
  }
}
