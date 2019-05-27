# SQLHelper

Based on [SqfLite](https://pub.dev/packages/sqflite)

## Usage
 ```dart
    List<String> tables = new List();
    tables.add("CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)");

    DatabaseHelper databaseHelper =
            SqlHelperBuilder(dbName: "test.db", dbVersion: 1).build();

    await databaseHelper.init(tables);


    /// See more in example. 
 ```

