import 'package:interview_task/model/FakeModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return await openDatabase(
      join(dbPath, 'fake_model.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE fake_model(id INTEGER PRIMARY KEY, albumId INTEGER, title TEXT, url TEXT, thumbnailUrl TEXT)',
        );
      },
      version: 1,
    );
  }


  Future<void> insertFakeModel(FakeModel model) async {
    final db = await database;
    await db.insert('fake_model', model.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<FakeModel>> getFakeModels() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('fake_model');
    return maps.map((map) => FakeModel.fromJson(map)).toList();
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
