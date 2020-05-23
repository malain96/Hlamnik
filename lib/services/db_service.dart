import 'package:hlamnik/database/database.dart';

class DBService {
  static Future<AppDatabase> get getDatabase async {
    // Create or connect to the database
    return await $FloorAppDatabase.databaseBuilder('hlamnik.db').build();
  }
}
