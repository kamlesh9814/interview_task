import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelperClass {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();
    return _database!;
  }

  // Initialize the database
  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'fake_data.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE fake_data (
          id INTEGER PRIMARY KEY,
          title TEXT,
          imageUrl TEXT
        )
      ''');
    });
  }

  // Save data to the database
  Future<void> saveData(Map<String, dynamic> data) async {
    final db = await database;
    await db.insert('fake_data', data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Fetch saved data
  Future<List<Map<String, dynamic>>> fetchData() async {
    final db = await database;
    return await db.query('fake_data');
  }
}
