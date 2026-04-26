// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_session_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetGameSessionModelCollection on Isar {
  IsarCollection<GameSessionModel> get gameSessionModels => this.collection();
}

const GameSessionModelSchema = CollectionSchema(
  name: r'GameSessionModel',
  id: -6004531957099909852,
  properties: {
    r'completedAt': PropertySchema(
      id: 0,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'correctCount': PropertySchema(
      id: 1,
      name: r'correctCount',
      type: IsarType.long,
    ),
    r'deckId': PropertySchema(id: 2, name: r'deckId', type: IsarType.long),
    r'deckName': PropertySchema(
      id: 3,
      name: r'deckName',
      type: IsarType.string,
    ),
    r'gameType': PropertySchema(
      id: 4,
      name: r'gameType',
      type: IsarType.string,
    ),
    r'score': PropertySchema(id: 5, name: r'score', type: IsarType.long),
    r'startedAt': PropertySchema(
      id: 6,
      name: r'startedAt',
      type: IsarType.dateTime,
    ),
    r'status': PropertySchema(id: 7, name: r'status', type: IsarType.string),
    r'totalCards': PropertySchema(
      id: 8,
      name: r'totalCards',
      type: IsarType.long,
    ),
  },

  estimateSize: _gameSessionModelEstimateSize,
  serialize: _gameSessionModelSerialize,
  deserialize: _gameSessionModelDeserialize,
  deserializeProp: _gameSessionModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _gameSessionModelGetId,
  getLinks: _gameSessionModelGetLinks,
  attach: _gameSessionModelAttach,
  version: '3.3.2',
);

int _gameSessionModelEstimateSize(
  GameSessionModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.deckName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.gameType.length * 3;
  bytesCount += 3 + object.status.length * 3;
  return bytesCount;
}

void _gameSessionModelSerialize(
  GameSessionModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.completedAt);
  writer.writeLong(offsets[1], object.correctCount);
  writer.writeLong(offsets[2], object.deckId);
  writer.writeString(offsets[3], object.deckName);
  writer.writeString(offsets[4], object.gameType);
  writer.writeLong(offsets[5], object.score);
  writer.writeDateTime(offsets[6], object.startedAt);
  writer.writeString(offsets[7], object.status);
  writer.writeLong(offsets[8], object.totalCards);
}

GameSessionModel _gameSessionModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = GameSessionModel();
  object.completedAt = reader.readDateTimeOrNull(offsets[0]);
  object.correctCount = reader.readLong(offsets[1]);
  object.deckId = reader.readLongOrNull(offsets[2]);
  object.deckName = reader.readStringOrNull(offsets[3]);
  object.gameType = reader.readString(offsets[4]);
  object.id = id;
  object.score = reader.readLong(offsets[5]);
  object.startedAt = reader.readDateTime(offsets[6]);
  object.status = reader.readString(offsets[7]);
  object.totalCards = reader.readLong(offsets[8]);
  return object;
}

P _gameSessionModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _gameSessionModelGetId(GameSessionModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _gameSessionModelGetLinks(GameSessionModel object) {
  return [];
}

void _gameSessionModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  GameSessionModel object,
) {
  object.id = id;
}

extension GameSessionModelQueryWhereSort
    on QueryBuilder<GameSessionModel, GameSessionModel, QWhere> {
  QueryBuilder<GameSessionModel, GameSessionModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension GameSessionModelQueryWhere
    on QueryBuilder<GameSessionModel, GameSessionModel, QWhereClause> {
  QueryBuilder<GameSessionModel, GameSessionModel, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterWhereClause>
  idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension GameSessionModelQueryFilter
    on QueryBuilder<GameSessionModel, GameSessionModel, QFilterCondition> {
  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  completedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'completedAt'),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  completedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'completedAt'),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  completedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'completedAt', value: value),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  completedAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'completedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  completedAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'completedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  completedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'completedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  correctCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'correctCount', value: value),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  correctCountGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'correctCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  correctCountLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'correctCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  correctCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'correctCount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  deckIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'deckId'),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  deckIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'deckId'),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  deckIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'deckId', value: value),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  deckIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'deckId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  deckIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'deckId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  deckIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'deckId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  deckNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'deckName'),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  deckNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'deckName'),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  deckNameEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'deckName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  deckNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'deckName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  deckNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'deckName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  deckNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'deckName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  deckNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'deckName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  deckNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'deckName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  deckNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'deckName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  deckNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'deckName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  deckNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'deckName', value: ''),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  deckNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'deckName', value: ''),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  gameTypeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'gameType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  gameTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'gameType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  gameTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'gameType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  gameTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'gameType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  gameTypeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'gameType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  gameTypeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'gameType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  gameTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'gameType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  gameTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'gameType',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  gameTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'gameType', value: ''),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  gameTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'gameType', value: ''),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  scoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'score', value: value),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  scoreGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'score',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  scoreLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'score',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  scoreBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'score',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  startedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'startedAt', value: value),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  startedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'startedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  startedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'startedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  startedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'startedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  statusEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  statusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  statusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  statusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'status',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  statusStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  statusEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'status',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  totalCardsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'totalCards', value: value),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  totalCardsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'totalCards',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  totalCardsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'totalCards',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterFilterCondition>
  totalCardsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'totalCards',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension GameSessionModelQueryObject
    on QueryBuilder<GameSessionModel, GameSessionModel, QFilterCondition> {}

extension GameSessionModelQueryLinks
    on QueryBuilder<GameSessionModel, GameSessionModel, QFilterCondition> {}

extension GameSessionModelQuerySortBy
    on QueryBuilder<GameSessionModel, GameSessionModel, QSortBy> {
  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  sortByCorrectCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correctCount', Sort.asc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  sortByCorrectCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correctCount', Sort.desc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  sortByDeckId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deckId', Sort.asc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  sortByDeckIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deckId', Sort.desc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  sortByDeckName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deckName', Sort.asc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  sortByDeckNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deckName', Sort.desc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  sortByGameType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameType', Sort.asc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  sortByGameTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameType', Sort.desc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy> sortByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.asc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  sortByScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.desc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  sortByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.asc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  sortByStartedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.desc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  sortByTotalCards() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCards', Sort.asc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  sortByTotalCardsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCards', Sort.desc);
    });
  }
}

extension GameSessionModelQuerySortThenBy
    on QueryBuilder<GameSessionModel, GameSessionModel, QSortThenBy> {
  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  thenByCorrectCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correctCount', Sort.asc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  thenByCorrectCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correctCount', Sort.desc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  thenByDeckId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deckId', Sort.asc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  thenByDeckIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deckId', Sort.desc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  thenByDeckName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deckName', Sort.asc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  thenByDeckNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deckName', Sort.desc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  thenByGameType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameType', Sort.asc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  thenByGameTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameType', Sort.desc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy> thenByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.asc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  thenByScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.desc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  thenByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.asc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  thenByStartedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.desc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  thenByTotalCards() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCards', Sort.asc);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QAfterSortBy>
  thenByTotalCardsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCards', Sort.desc);
    });
  }
}

extension GameSessionModelQueryWhereDistinct
    on QueryBuilder<GameSessionModel, GameSessionModel, QDistinct> {
  QueryBuilder<GameSessionModel, GameSessionModel, QDistinct>
  distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QDistinct>
  distinctByCorrectCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'correctCount');
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QDistinct>
  distinctByDeckId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deckId');
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QDistinct>
  distinctByDeckName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deckName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QDistinct>
  distinctByGameType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gameType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QDistinct>
  distinctByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'score');
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QDistinct>
  distinctByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startedAt');
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QDistinct> distinctByStatus({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GameSessionModel, GameSessionModel, QDistinct>
  distinctByTotalCards() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalCards');
    });
  }
}

extension GameSessionModelQueryProperty
    on QueryBuilder<GameSessionModel, GameSessionModel, QQueryProperty> {
  QueryBuilder<GameSessionModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<GameSessionModel, DateTime?, QQueryOperations>
  completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<GameSessionModel, int, QQueryOperations> correctCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'correctCount');
    });
  }

  QueryBuilder<GameSessionModel, int?, QQueryOperations> deckIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deckId');
    });
  }

  QueryBuilder<GameSessionModel, String?, QQueryOperations> deckNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deckName');
    });
  }

  QueryBuilder<GameSessionModel, String, QQueryOperations> gameTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gameType');
    });
  }

  QueryBuilder<GameSessionModel, int, QQueryOperations> scoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'score');
    });
  }

  QueryBuilder<GameSessionModel, DateTime, QQueryOperations>
  startedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startedAt');
    });
  }

  QueryBuilder<GameSessionModel, String, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<GameSessionModel, int, QQueryOperations> totalCardsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalCards');
    });
  }
}
