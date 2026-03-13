import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Stories])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'loreforge_db',
      native: const DriftNativeOptions(
        databasePath: _databasePath,
      ),
    );
  }

  static Future<String> _databasePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/loreforge.db';
  }
}