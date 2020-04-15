import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/models/todo.dart';

class DbHelper {
  static final DbHelper _dbHelper = DbHelper._internal();

  String tableTodo = 'Todo';
  String columnId = 'id';
  String columnTitle = 'title';
  String columnDescription = 'description';
  String columnDate = 'date';
  String columnPriority = 'priority';

  DbHelper._internal();

  factory DbHelper() {
    return _dbHelper;
  }

  static Database _db;

  Future<Database> get db async {
    if(_db == null) {
      _db = await initDb();
    }

    return _db;
  }

  Future<Database> initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "todos.db";
    var dbTodos = await openDatabase(path, version: 1, onCreate: _createDb);

    return dbTodos;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
      "CREATE TABLE $tableTodo($columnId INTEGER PRIMARY KEY, " +
        "$columnTitle TEXT, $columnDescription TEXT, $columnDate TEXT, " +
        "$columnPriority INTEGER)"
    );
  }

  Future<int> insertTodo(Todo todo) async {
    Database db = await this.db;
    var result = await db.insert(tableTodo, todo.toMap());

    return result;
  }

  Future<List> getTodos() async {
    Database db = await this.db;
    var result = await db.rawQuery("SELECT * FROM $tableTodo order by $columnPriority ASC");

    return result;
  }

  Future<int> getCount() async {
    Database db = await this.db;
    var result = Sqflite.firstIntValue(
      await db.rawQuery("select count (*) from $tableTodo")
    );

    return result;
  }

  Future<int> updateTodo(Todo todo) async {
    Database db = await this.db;
    var result = await db.update(tableTodo, todo.toMap(),
      where: "$columnId = ?", whereArgs: [todo.id]);

    return result;
  }

  Future<int> deleteTodo(int id) async {
    Database db = await this.db;
    var result = await db.rawDelete("DELETE FROM $tableTodo WHERE $columnId = $id");

    return result;
  }
  
}
