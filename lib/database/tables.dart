import 'package:drift/drift.dart';

class Stories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get genre => text()();
  TextColumn get mode => text()();
  TextColumn get scenes => text()(); // JSON
  TextColumn get choices => text()(); // JSON
  TextColumn get worldState => text()(); // JSON
  TextColumn get twistState => text()(); // JSON
  TextColumn get rpgState => text().nullable()(); // JSON
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}