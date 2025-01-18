import '/imports.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DbService extends GetxService {
  late Database database;
  final _logger = Logger();

  Future<DbService> init() async {
    _logger.i('init()');

    var appDocumentsDir = await getApplicationCacheDirectory();
    var dbPath = p.join(appDocumentsDir.path, 'databases/data.db');

    _logger.i('init() => openDatabase $dbPath');

    if (GetPlatform.isDesktop) {
      sqfliteFfiInit();
      var databaseFactory = databaseFactoryFfi;
      database = await databaseFactory.openDatabase(dbPath);
    } else {
      database = await openDatabase(dbPath);
    }

    _logger.i('init() => prepare');
    var sql = await rootBundle.loadString('assets/sqlite/data.sql');
    if (sql.isEmpty == false) await database.execute(sql);

    _logger.i('init() => successful');
    return this;
  }

  @override
  void onClose() async {
    super.onClose();
    _logger.i('onClose()');
    await database.close();
    _logger.i('onClose() => successful');
  }
}
