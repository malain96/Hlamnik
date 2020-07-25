import 'package:hlamnik/database/database.dart';

class DBService {
  ///Retrieves an instance of the database so we can query it
  static Future<AppDatabase> get getDatabase async {
    // Create or connect to the database
    return await $FloorAppDatabase.databaseBuilder('hlamnik.db').build();
  }
}
