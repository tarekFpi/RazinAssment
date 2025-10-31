import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  // Get database instance
  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  // Initialize DB
  static Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasks.db');

    return await openDatabase(
      path,
      version: 2, // increment version if table changes
      onCreate: (db, version) async {
        // Create table
        await db.execute('''
          CREATE TABLE tasks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            description TEXT,
            startDate TEXT,
            endDate TEXT,
            status TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Migration for future upgrades
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE tasks ADD COLUMN status TEXT');
        }
      },
    );
  }

  // Insert a task
  static Future<int> insertTask(Map<String, dynamic> task) async {
    final db = await database;
    return await db.insert('tasks', task);
  }

  // Get all tasks
  static Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await database;
    return await db.query('tasks');
  }

  // Update a task
  static Future<int> updateTask(int id, Map<String, dynamic> task) async {
    final db = await database;
    return await db.update(
      'tasks',
      task,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete a task
  static Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}
