import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabase {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String dbPath = await getDatabasesPath();
    String pathName = join(dbPath, 'byahe.db');

    return await openDatabase(
      pathName,
      version: 7,
      onCreate: (db, version) async {
        await _createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 7) {
          await db.execute('DROP TABLE IF EXISTS active_fare');
          await db.execute(
            'CREATE TABLE active_fare(email TEXT PRIMARY KEY, fare REAL)',
          );
        }
      },
    );
  }

  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users(
        id TEXT PRIMARY KEY,
        email TEXT UNIQUE,
        password TEXT,
        role TEXT,
        is_verified INTEGER DEFAULT 0,
        is_synced INTEGER DEFAULT 0
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS active_fare(
        email TEXT PRIMARY KEY,
        fare REAL
      )
    ''');
  }

  Future<void> saveActiveFare(String email, double fare) async {
    final db = await database;
    await db.insert('active_fare', {
      'email': email,
      'fare': fare,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<double?> getActiveFare(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'active_fare',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isNotEmpty) {
      return maps.first['fare'] as double;
    }
    return null;
  }

  Future<void> clearActiveFare(String email) async {
    final db = await database;
    await db.delete('active_fare', where: 'email = ?', whereArgs: [email]);
  }
}
