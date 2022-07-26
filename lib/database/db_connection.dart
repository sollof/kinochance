import 'package:spin_rex/database/constants.dart';
import 'package:mongo_dart/mongo_dart.dart';

class DBConnection {
  late Db _db;

  static final DBConnection _instance = DBConnection._internal();

  DBConnection._internal();

  static getInstance() {
    return _instance;
  }

  static _getConnectionString() {
    return "mongodb://$mongoHost:$mongoPort/$mongoDBName";
  }

  closeConnection() {
    _db.close();
  }

  Future<Db> getConnection() async {
    if (_db == null) {
      _db = await Db.create(_getConnectionString());
      await _db.open();
    }
    return _db;
  }
}
