library sql_helper;

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Database _database;

  String _dbName = 'demo_flutter.db';
  int _dbVersion = 1;
  String _pathDb;

  DatabaseHelper(this._database, this._dbName, this._dbVersion);

  Future init() async {
    var databasesPath = await getDatabasesPath();
    _pathDb = join(databasesPath, _dbName);
    debugPrint("Database $_dbName has been initializated");
  }

  Future createTables(List<String> tables) async {
    /// Open DB and create Tables
    _database = await openDatabase(_pathDb, version: _dbVersion,
        onCreate: (Database db, int version) async {
      tables.forEach((query) async => await db.execute(query));
    });
  }

  Future<int> insertRecord(String table, Map values) async {
    debugPrint("Insert record : $table with values: $values");
    int id = await this._database.insert(table, values);
    debugPrint("record inserted with id $id");
    return id;
  }

  Future<List<Map>> getData(String table,
      {List<String> columns,
      String where,
      List<dynamic> args,
      String groupBy,
      String orderBy,
      int limit,
      int offset}) async {
    return await this._database.query(table,
        columns: columns,
        where: where,
        whereArgs: args,
        groupBy: groupBy,
        orderBy: orderBy,
        limit: limit,
        offset: offset);
  }

  Future<int> deleteRecord(
      {@required String table,
      @required List<String> whereColumns,
      @required List<dynamic> valuesCondition}) async {
    String where = '';
    whereColumns.forEach((column) => where += " $column=? and");
    where.substring(0, where.length - 3);

    return await this
        ._database
        .delete(table, where: where, whereArgs: valuesCondition);
  }

  Future<int> updateRecord(
      {@required String table,
      @required List<String> whereColumns,
      @required List<dynamic> valuesCondition,
      @required Map updateData}) async {
    String where = '';
    whereColumns.forEach((column) => where += " $column=? and");
    where.substring(0, where.length - 3);

    return await this
        ._database
        .update(table, updateData, where: where, whereArgs: valuesCondition);
  }

  Future deleteDataBase() async {
    if (_pathDb == null)
      return debugPrint("Database $_dbName has not been initializated");

    await deleteDatabase(_pathDb);
  }

  Future closeConnection() async => this._database.close();
}
