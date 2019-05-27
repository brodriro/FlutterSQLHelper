import 'package:flutter/foundation.dart';
import 'package:sql_helper/sql_helper.dart';

void main() {
  List<String> tables = new List();
  tables.add(UserEntity.createTable());

  DatabaseHelper databaseHelper =
      SqlHelperBuilder(dbName: "test.db", dbVersion: 1).build();

  /// Init Database
  databaseHelper.init(tables).then((result) async {
    print("Database Initializated");

    UserEntity userEntity = new UserEntity();
    userEntity.firstName = "Brian";
    userEntity.lastName = "Dev";
    userEntity.email = "bdev@example.com";
    userEntity.token = "eap1359h21h4pac";

    ///Insert record
    int idRecord = await databaseHelper.insertRecord(
        UserEntity.tableName, userEntity.toMap());

    /// Get Records
    List<Map> records = await databaseHelper.getRecords(UserEntity.tableName);
    debugPrint("Results : $records");

    /// Update Records
    userEntity.firstName = "Steve";

    await databaseHelper.updateRecord(
        table: UserEntity.tableName,
        whereColumns: [UserEntity.columnId],
        valuesCondition: [idRecord],
        updateData: userEntity.toMap());

    /// Get Records updated
    List<Map> records2 = await databaseHelper.getRecords(UserEntity.tableName);
    debugPrint("Results : $records2");

    /// Delete Records
    await databaseHelper.deleteRecord(
        table: UserEntity.tableName,
        whereColumns: [UserEntity.columnId],
        valuesCondition: [idRecord]);

    /// Get Records updated
    List<Map> emptyRecords =
        await databaseHelper.getRecords(UserEntity.tableName);
    debugPrint("Results : $emptyRecords");
  }, onError: (e) {
    print("DatabaseError: $e");
  });
}

/// Model
class UserEntity {
  int id;
  String username;
  String email;
  String firstName;
  String lastName;
  String token;

  static final String tableName = "User";
  static final String columnId = "id"; //INTEGER PRIMARY KEY
  static final String columnUsername = "username"; //TEXT
  static final String columnEmail = "email"; //TEXT
  static final String columnFirstName = "firstName"; //TEXT
  static final String columnLastName = "lastname"; // TEXT
  static final String columnToken = "token";

  static String createTable() {
    return '''CREATE TABLE $tableName (
      $columnId INTEGER PRIMARY KEY autoincrement,
      $columnUsername TEXT,
      $columnEmail TEXT,
      $columnFirstName TEXT,
      $columnLastName TEXT,
      $columnToken TEXT
      )''';
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnUsername: username,
      columnEmail: email,
      columnFirstName: firstName,
      columnLastName: lastName,
      columnToken: token
    };
    if (id != null) map[columnId] = id;
    return map;
  }

  UserEntity();

  UserEntity.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    username = map[columnUsername];
    email = map[columnEmail];
    firstName = map[columnFirstName];
    lastName = map[columnLastName];
    token = map[columnToken];
  }
}
