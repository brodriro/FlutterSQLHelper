class SQLEntity {
  /// Creating map for the database
  ///  Example:
  ///    Map<String, dynamic> map = {
  ///    columnUsername: username,
  ///    columnEmail: email,
  ///    };
  ///   if (id != null) map[columnId] = id;
  ///  Important: If the [ID] is null then a new object is created.
  Map<String, dynamic> toMap() {
    return null;
  }

  /// Generate string for new Table
  static _TableBuilder generateTable(String tableName) {
    return new _TableBuilder(tableName);
  }
}

///[_TableBuilder]  build new Table
class _TableBuilder {
  String _tableQuery;
  String _tableName;

  ///Init table string
  _TableBuilder(this._tableName) {
    _tableQuery = '';
  }

  ///New field with type TEXT
  _TableBuilder text(String name) {
    _tableQuery += "$name TEXT, ";
    return this;
  }

  ///New field with type INTEGER, optional params : PRIMARY KEY or AUTOINCREMENT
  _TableBuilder integer(String name, {bool primaryKey, bool autoincrement}) {
    if (primaryKey == null) primaryKey = false;
    if (autoincrement == null) autoincrement = false;

    _tableQuery +=
        "$name INTEGER ${(primaryKey) ? 'PRIMARY KEY' : ''} ${(autoincrement) ? 'autoincrement' : ''}, ";
    return this;
  }

  ///New field with type REAL
  _TableBuilder real(String name) {
    _tableQuery += "$name REAL, ";
    return this;
  }

  ///New field with type BLOB (Support Unit8List - List<int>)
  _TableBuilder blob(String name) {
    _tableQuery += "$name BLOB, ";
    return this;
  }

  ///[build] Generate string for create new Table
  String build() {
    if (_tableQuery != null && _tableQuery.trim().isNotEmpty) {
      _tableQuery = _tableQuery.substring(0, _tableQuery.length - 1);
    }
    return '''CREATE TABLE $_tableName ($_tableQuery)''';
  }
}
