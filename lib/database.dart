import 'package:moor/moor.dart';

import 'package:moor_ffi/moor_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
//import 'package:moor/moor.dart';
import 'dart:io';

part 'database.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file);
  });
}

class Recitations extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text()();

  TextColumn get date => text()();
}

@UseMoor(tables: [Recitations])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  Future<List<Recitation>> get allRecitations => select(recitations).get();
  Future<List<Recitation>> get recentRecitations => (select(recitations)..orderBy([(t) => OrderingTerm(expression: t.id,mode: OrderingMode.desc)])..limit(10)).get();
  Future<int> addRecitation(RecitationsCompanion entry) => into(recitations).insert(entry);
}
