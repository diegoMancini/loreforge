// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $StoriesTable extends Stories with TableInfo<$StoriesTable, Story> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _genreMeta = const VerificationMeta('genre');
  @override
  late final GeneratedColumn<String> genre = GeneratedColumn<String>(
      'genre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
      'mode', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scenesMeta = const VerificationMeta('scenes');
  @override
  late final GeneratedColumn<String> scenes = GeneratedColumn<String>(
      'scenes', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _choicesMeta =
      const VerificationMeta('choices');
  @override
  late final GeneratedColumn<String> choices = GeneratedColumn<String>(
      'choices', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _worldStateMeta =
      const VerificationMeta('worldState');
  @override
  late final GeneratedColumn<String> worldState = GeneratedColumn<String>(
      'world_state', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _twistStateMeta =
      const VerificationMeta('twistState');
  @override
  late final GeneratedColumn<String> twistState = GeneratedColumn<String>(
      'twist_state', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _rpgStateMeta =
      const VerificationMeta('rpgState');
  @override
  late final GeneratedColumn<String> rpgState = GeneratedColumn<String>(
      'rpg_state', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        genre,
        mode,
        scenes,
        choices,
        worldState,
        twistState,
        rpgState,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stories';
  @override
  VerificationContext validateIntegrity(Insertable<Story> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('genre')) {
      context.handle(
          _genreMeta, genre.isAcceptableOrUnknown(data['genre']!, _genreMeta));
    } else if (isInserting) {
      context.missing(_genreMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
          _modeMeta, mode.isAcceptableOrUnknown(data['mode']!, _modeMeta));
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('scenes')) {
      context.handle(_scenesMeta,
          scenes.isAcceptableOrUnknown(data['scenes']!, _scenesMeta));
    } else if (isInserting) {
      context.missing(_scenesMeta);
    }
    if (data.containsKey('choices')) {
      context.handle(_choicesMeta,
          choices.isAcceptableOrUnknown(data['choices']!, _choicesMeta));
    } else if (isInserting) {
      context.missing(_choicesMeta);
    }
    if (data.containsKey('world_state')) {
      context.handle(
          _worldStateMeta,
          worldState.isAcceptableOrUnknown(
              data['world_state']!, _worldStateMeta));
    } else if (isInserting) {
      context.missing(_worldStateMeta);
    }
    if (data.containsKey('twist_state')) {
      context.handle(
          _twistStateMeta,
          twistState.isAcceptableOrUnknown(
              data['twist_state']!, _twistStateMeta));
    } else if (isInserting) {
      context.missing(_twistStateMeta);
    }
    if (data.containsKey('rpg_state')) {
      context.handle(_rpgStateMeta,
          rpgState.isAcceptableOrUnknown(data['rpg_state']!, _rpgStateMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Story map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Story(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      genre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}genre'])!,
      mode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mode'])!,
      scenes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}scenes'])!,
      choices: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}choices'])!,
      worldState: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}world_state'])!,
      twistState: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}twist_state'])!,
      rpgState: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rpg_state']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $StoriesTable createAlias(String alias) {
    return $StoriesTable(attachedDatabase, alias);
  }
}

class Story extends DataClass implements Insertable<Story> {
  final int id;
  final String genre;
  final String mode;
  final String scenes;
  final String choices;
  final String worldState;
  final String twistState;
  final String? rpgState;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Story(
      {required this.id,
      required this.genre,
      required this.mode,
      required this.scenes,
      required this.choices,
      required this.worldState,
      required this.twistState,
      this.rpgState,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['genre'] = Variable<String>(genre);
    map['mode'] = Variable<String>(mode);
    map['scenes'] = Variable<String>(scenes);
    map['choices'] = Variable<String>(choices);
    map['world_state'] = Variable<String>(worldState);
    map['twist_state'] = Variable<String>(twistState);
    if (!nullToAbsent || rpgState != null) {
      map['rpg_state'] = Variable<String>(rpgState);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  StoriesCompanion toCompanion(bool nullToAbsent) {
    return StoriesCompanion(
      id: Value(id),
      genre: Value(genre),
      mode: Value(mode),
      scenes: Value(scenes),
      choices: Value(choices),
      worldState: Value(worldState),
      twistState: Value(twistState),
      rpgState: rpgState == null && nullToAbsent
          ? const Value.absent()
          : Value(rpgState),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Story.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Story(
      id: serializer.fromJson<int>(json['id']),
      genre: serializer.fromJson<String>(json['genre']),
      mode: serializer.fromJson<String>(json['mode']),
      scenes: serializer.fromJson<String>(json['scenes']),
      choices: serializer.fromJson<String>(json['choices']),
      worldState: serializer.fromJson<String>(json['worldState']),
      twistState: serializer.fromJson<String>(json['twistState']),
      rpgState: serializer.fromJson<String?>(json['rpgState']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'genre': serializer.toJson<String>(genre),
      'mode': serializer.toJson<String>(mode),
      'scenes': serializer.toJson<String>(scenes),
      'choices': serializer.toJson<String>(choices),
      'worldState': serializer.toJson<String>(worldState),
      'twistState': serializer.toJson<String>(twistState),
      'rpgState': serializer.toJson<String?>(rpgState),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Story copyWith(
          {int? id,
          String? genre,
          String? mode,
          String? scenes,
          String? choices,
          String? worldState,
          String? twistState,
          Value<String?> rpgState = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Story(
        id: id ?? this.id,
        genre: genre ?? this.genre,
        mode: mode ?? this.mode,
        scenes: scenes ?? this.scenes,
        choices: choices ?? this.choices,
        worldState: worldState ?? this.worldState,
        twistState: twistState ?? this.twistState,
        rpgState: rpgState.present ? rpgState.value : this.rpgState,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Story copyWithCompanion(StoriesCompanion data) {
    return Story(
      id: data.id.present ? data.id.value : this.id,
      genre: data.genre.present ? data.genre.value : this.genre,
      mode: data.mode.present ? data.mode.value : this.mode,
      scenes: data.scenes.present ? data.scenes.value : this.scenes,
      choices: data.choices.present ? data.choices.value : this.choices,
      worldState:
          data.worldState.present ? data.worldState.value : this.worldState,
      twistState:
          data.twistState.present ? data.twistState.value : this.twistState,
      rpgState: data.rpgState.present ? data.rpgState.value : this.rpgState,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Story(')
          ..write('id: $id, ')
          ..write('genre: $genre, ')
          ..write('mode: $mode, ')
          ..write('scenes: $scenes, ')
          ..write('choices: $choices, ')
          ..write('worldState: $worldState, ')
          ..write('twistState: $twistState, ')
          ..write('rpgState: $rpgState, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, genre, mode, scenes, choices, worldState,
      twistState, rpgState, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Story &&
          other.id == this.id &&
          other.genre == this.genre &&
          other.mode == this.mode &&
          other.scenes == this.scenes &&
          other.choices == this.choices &&
          other.worldState == this.worldState &&
          other.twistState == this.twistState &&
          other.rpgState == this.rpgState &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class StoriesCompanion extends UpdateCompanion<Story> {
  final Value<int> id;
  final Value<String> genre;
  final Value<String> mode;
  final Value<String> scenes;
  final Value<String> choices;
  final Value<String> worldState;
  final Value<String> twistState;
  final Value<String?> rpgState;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const StoriesCompanion({
    this.id = const Value.absent(),
    this.genre = const Value.absent(),
    this.mode = const Value.absent(),
    this.scenes = const Value.absent(),
    this.choices = const Value.absent(),
    this.worldState = const Value.absent(),
    this.twistState = const Value.absent(),
    this.rpgState = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  StoriesCompanion.insert({
    this.id = const Value.absent(),
    required String genre,
    required String mode,
    required String scenes,
    required String choices,
    required String worldState,
    required String twistState,
    this.rpgState = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : genre = Value(genre),
        mode = Value(mode),
        scenes = Value(scenes),
        choices = Value(choices),
        worldState = Value(worldState),
        twistState = Value(twistState);
  static Insertable<Story> custom({
    Expression<int>? id,
    Expression<String>? genre,
    Expression<String>? mode,
    Expression<String>? scenes,
    Expression<String>? choices,
    Expression<String>? worldState,
    Expression<String>? twistState,
    Expression<String>? rpgState,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (genre != null) 'genre': genre,
      if (mode != null) 'mode': mode,
      if (scenes != null) 'scenes': scenes,
      if (choices != null) 'choices': choices,
      if (worldState != null) 'world_state': worldState,
      if (twistState != null) 'twist_state': twistState,
      if (rpgState != null) 'rpg_state': rpgState,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  StoriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? genre,
      Value<String>? mode,
      Value<String>? scenes,
      Value<String>? choices,
      Value<String>? worldState,
      Value<String>? twistState,
      Value<String?>? rpgState,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return StoriesCompanion(
      id: id ?? this.id,
      genre: genre ?? this.genre,
      mode: mode ?? this.mode,
      scenes: scenes ?? this.scenes,
      choices: choices ?? this.choices,
      worldState: worldState ?? this.worldState,
      twistState: twistState ?? this.twistState,
      rpgState: rpgState ?? this.rpgState,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (genre.present) {
      map['genre'] = Variable<String>(genre.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (scenes.present) {
      map['scenes'] = Variable<String>(scenes.value);
    }
    if (choices.present) {
      map['choices'] = Variable<String>(choices.value);
    }
    if (worldState.present) {
      map['world_state'] = Variable<String>(worldState.value);
    }
    if (twistState.present) {
      map['twist_state'] = Variable<String>(twistState.value);
    }
    if (rpgState.present) {
      map['rpg_state'] = Variable<String>(rpgState.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoriesCompanion(')
          ..write('id: $id, ')
          ..write('genre: $genre, ')
          ..write('mode: $mode, ')
          ..write('scenes: $scenes, ')
          ..write('choices: $choices, ')
          ..write('worldState: $worldState, ')
          ..write('twistState: $twistState, ')
          ..write('rpgState: $rpgState, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $StoriesTable stories = $StoriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [stories];
}

typedef $$StoriesTableCreateCompanionBuilder = StoriesCompanion Function({
  Value<int> id,
  required String genre,
  required String mode,
  required String scenes,
  required String choices,
  required String worldState,
  required String twistState,
  Value<String?> rpgState,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$StoriesTableUpdateCompanionBuilder = StoriesCompanion Function({
  Value<int> id,
  Value<String> genre,
  Value<String> mode,
  Value<String> scenes,
  Value<String> choices,
  Value<String> worldState,
  Value<String> twistState,
  Value<String?> rpgState,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$StoriesTableFilterComposer
    extends Composer<_$AppDatabase, $StoriesTable> {
  $$StoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get genre => $composableBuilder(
      column: $table.genre, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mode => $composableBuilder(
      column: $table.mode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scenes => $composableBuilder(
      column: $table.scenes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get choices => $composableBuilder(
      column: $table.choices, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get worldState => $composableBuilder(
      column: $table.worldState, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get twistState => $composableBuilder(
      column: $table.twistState, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rpgState => $composableBuilder(
      column: $table.rpgState, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$StoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $StoriesTable> {
  $$StoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get genre => $composableBuilder(
      column: $table.genre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mode => $composableBuilder(
      column: $table.mode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scenes => $composableBuilder(
      column: $table.scenes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get choices => $composableBuilder(
      column: $table.choices, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get worldState => $composableBuilder(
      column: $table.worldState, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get twistState => $composableBuilder(
      column: $table.twistState, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rpgState => $composableBuilder(
      column: $table.rpgState, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$StoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoriesTable> {
  $$StoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get genre =>
      $composableBuilder(column: $table.genre, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<String> get scenes =>
      $composableBuilder(column: $table.scenes, builder: (column) => column);

  GeneratedColumn<String> get choices =>
      $composableBuilder(column: $table.choices, builder: (column) => column);

  GeneratedColumn<String> get worldState => $composableBuilder(
      column: $table.worldState, builder: (column) => column);

  GeneratedColumn<String> get twistState => $composableBuilder(
      column: $table.twistState, builder: (column) => column);

  GeneratedColumn<String> get rpgState =>
      $composableBuilder(column: $table.rpgState, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$StoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StoriesTable,
    Story,
    $$StoriesTableFilterComposer,
    $$StoriesTableOrderingComposer,
    $$StoriesTableAnnotationComposer,
    $$StoriesTableCreateCompanionBuilder,
    $$StoriesTableUpdateCompanionBuilder,
    (Story, BaseReferences<_$AppDatabase, $StoriesTable, Story>),
    Story,
    PrefetchHooks Function()> {
  $$StoriesTableTableManager(_$AppDatabase db, $StoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> genre = const Value.absent(),
            Value<String> mode = const Value.absent(),
            Value<String> scenes = const Value.absent(),
            Value<String> choices = const Value.absent(),
            Value<String> worldState = const Value.absent(),
            Value<String> twistState = const Value.absent(),
            Value<String?> rpgState = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              StoriesCompanion(
            id: id,
            genre: genre,
            mode: mode,
            scenes: scenes,
            choices: choices,
            worldState: worldState,
            twistState: twistState,
            rpgState: rpgState,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String genre,
            required String mode,
            required String scenes,
            required String choices,
            required String worldState,
            required String twistState,
            Value<String?> rpgState = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              StoriesCompanion.insert(
            id: id,
            genre: genre,
            mode: mode,
            scenes: scenes,
            choices: choices,
            worldState: worldState,
            twistState: twistState,
            rpgState: rpgState,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$StoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StoriesTable,
    Story,
    $$StoriesTableFilterComposer,
    $$StoriesTableOrderingComposer,
    $$StoriesTableAnnotationComposer,
    $$StoriesTableCreateCompanionBuilder,
    $$StoriesTableUpdateCompanionBuilder,
    (Story, BaseReferences<_$AppDatabase, $StoriesTable, Story>),
    Story,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$StoriesTableTableManager get stories =>
      $$StoriesTableTableManager(_db, _db.stories);
}
