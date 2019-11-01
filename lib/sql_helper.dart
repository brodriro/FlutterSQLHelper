library sql_helper;

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
export 'SQLEntity.dart';


class DatabaseHelper {
  Database _database;

  String _dbName;
  int _dbVersion;
  String _pathDb;

  DatabaseHelper(this._database, this._dbName, this._dbVersion);

  ///Init database - Need a list of queries
  Future init(List<String> tables) async {
    var databasesPath = await getDatabasesPath();
    _pathDb = join(databasesPath, _dbName);
    debugPrint("Database $_dbName has been initializated");

    await createTables(tables);
  }

  /// get Database version
  int get dataBaseVersion => this._dbVersion;

  /// get Database name
  String get dataBaseName => this._dbName;

  /// get SQFLite
  Database get database => this._database;

  /// Create Tables - [tables] is a List of String with queries for create tables
  Future createTables(List<String> tables) async {
    /// Open DB and create Tables
    _database = await openDatabase(_pathDb, version: _dbVersion,
        onCreate: (Database db, int version) async {
      tables.forEach((query) async => await db.execute(query));
    });
  }

  /// Insert new Record - Required [table] (table name) and [values] (Values for new record)
  Future<int> insertRecord(String table, Map values) async {
    debugPrint("Insert record : $table with values: $values");
    int id = await this._database.insert(table, values);
    debugPrint("record inserted with id $id");
    return id;
  }

  /// Get records
  Future<List<Map>> getRecords(String table,
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

  /// Delete records
  Future<int> deleteRecord(
      {@required String table,
      List<String> whereColumns,
      List<dynamic> valuesCondition}) async {
    String where = '';
    whereColumns.forEach((column) => where += " $column=? and");
    where = where.substring(0, where.length - 3);

    debugPrint("Delete => $table -> where: $where  values:$valuesCondition");

    return await this
        ._database
        .delete(table, where: where, whereArgs: valuesCondition);
  }

  /// Update records
  Future<int> updateRecord(
      {@required String table,
      @required List<String> whereColumns,
      @required List<dynamic> valuesCondition,
      @required Map updateData}) async {
    String where = '';
    whereColumns.forEach((column) => where += " $column=? and");
    where = where.substring(0, where.length - 3);

    debugPrint(
        "Update => $table -> where :$where values:$valuesCondition Data:$updateData");

    return await this
        ._database
        .update(table, updateData, where: where, whereArgs: valuesCondition);
  }

  /// Custom query
  Future<List<Map<String, dynamic>>> rawQuery(String sql) {
    return this._database.rawQuery(sql);
  }

  /// Delete Database
  Future deleteDataBase() async {
    if (_pathDb == null)
      return debugPrint("Database $_dbName has not been initializated");

    await deleteDatabase(_pathDb);
  }

  /// Close Connection
  Future closeConnection() async => this._database.close();
}

class SqlHelperBuilder {
  String dbName;
  int dbVersion;
  Database _database;

  SqlHelperBuilder({this.dbName, this.dbVersion});

  DatabaseHelper build() {
    return new DatabaseHelper(_database, this.dbName, this.dbVersion);
  }
}
