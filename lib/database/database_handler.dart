import 'package:sqflite/sqflite.dart';
import 'package:todo_sql/database/notes_model.dart';
import 'dart:async';
import 'package:path/path.dart';

class DatabaseHandler {
  static final DatabaseHandler _instance = DatabaseHandler.internal();
  factory DatabaseHandler() => _instance;

  static Database? _db;

  DatabaseHandler.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  initDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, "todo.db");

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute("CREATE TABLE Todo(id INTEGER PRIMARY KEY, todomessage TEXT)");
  }

  Future<int> insert(TodoModel todo) async {
    var dbUser = await db;
    var result = await dbUser.insert("Todo", todo.toMap());
    return result;
  }

  Future<List<TodoModel>> getTodoList() async {
    var dbUser = await db;
    final List<Map<String, Object?>> queryResult = await dbUser.query("Todo");
    return queryResult.map((e) => TodoModel.fromMap(e)).toList();
  }

  Future<int> delete(int id) async {
    var dbUser = await db;
    return await dbUser.delete("Todo", where: "id = ?", whereArgs: [id]);
  }

  Future<int> update(TodoModel todoModel) async {
    var dbUser = await db;
    return await dbUser.update("Todo", todoModel.toMap(), where: "id = ?", whereArgs: [todoModel.id]);
  }
}
