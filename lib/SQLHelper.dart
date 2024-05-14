import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTable(sql.Database db) async {
  await db.execute("DROP TABLE IF EXISTS subjectsTable");

  await db.execute("""
CREATE TABLE subjectsTable(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT,
  note TEXT,
  date TEXT,
  startTime TEXT,
  endTime TEXT,
  colorCode TEXT,
  complete INTEGER
)
""");
}

 static Future<sql.Database> db() async {
  return sql.openDatabase(
    'subjectsDB.db',
    version: 2, // Increment the version number
    onCreate: (sql.Database database, int version) async {
      await createTable(database);
    },
    onUpgrade: (sql.Database database, int oldVersion, int newVersion) async {
      if (oldVersion < newVersion) {
        // Perform migration from oldVersion to newVersion
        await database.execute('ALTER TABLE subjectsTable ADD COLUMN complete INTEGER');
      }
    },
  );
}


  static Future<int> insertSubject({
    required String name,
    required String note,
    required String date,
    required String startTime,
    required String endTime,
    required String colorCode,
    required int complete,
  }) async {
    final db = await SQLHelper.db();
    final Map<String, dynamic> row = {
      'name': name,
      'note': note,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'colorCode': colorCode,
      'complete':complete
    };

    final id = await db.insert(
      "subjectsTable",
      row,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    return id;
  }

  static Future<int> insertSubjects(List<Map<String, dynamic>> subjects) async {
    final db = await SQLHelper.db();
    subjects.forEach((element) {
      db.insert(
        "subjectsTable",
        element,
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
    });
    return subjects.length;
  }

  static Future<List<Map<String, dynamic>>> getSubjects() async {
    final db = await SQLHelper.db();
    List<Map<String, dynamic>> rows =
        await db.query("subjectsTable", orderBy: "id");

    return rows;
  }

  static Future<void> deleteSubject(int id) async {
    final db = await SQLHelper.db();
    await db.delete('subjectsTable', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> updateSubject({
    required int id,
    required String name,
    required String note,
    required String date,
    required String startTime,
    required String endTime,
    required String colorCode,
    required int complete,
  }) async {
    final db = await SQLHelper.db();
    final Map<String, dynamic> updatedRow = {
      'name': name,
      'note': note,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'colorCode': colorCode,
      'complete':complete
    };

    await db.update(
      'subjectsTable',
      updatedRow,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
