import 'dart:async';
import 'package:aqueduct/aqueduct.dart';

class Migration1 extends Migration {
  @override
  Future upgrade() async {
    database.createTable(SchemaTable("_Read", [
      SchemaColumn("id", ManagedPropertyType.bigInteger,
          isPrimaryKey: true,
          autoincrement: true,
          isIndexed: false,
          isNullable: false,
          isUnique: false),
      SchemaColumn("title", ManagedPropertyType.string,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: false,
          isNullable: false,
          isUnique: true),
      SchemaColumn("author", ManagedPropertyType.string,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: false,
          isNullable: false,
          isUnique: false),
      SchemaColumn("description", ManagedPropertyType.string,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: false,
          isNullable: false,
          isUnique: false),
      SchemaColumn("year", ManagedPropertyType.integer,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: false,
          isNullable: false,
          isUnique: false)
    ]));
  }

  @override
  Future downgrade() async {}

  @override
  Future seed() async {
    final List<Map> reads = [
      {
        "title": 'The dying Horse',
        "author": 'TAkenBenra',
        "description": 'The Mistry You Never Knew',
        "year": '2000'
      },
      {
        "title": 'Coming Home',
        "author": 'Benra',
        "description": 'TIts a new Home',
        "year": '2007'
      },
      {
        "title": 'Break Through',
        "author": 'KemBen',
        "description": 'Destroy your fears',
        "year": '2010'
      },
      {
        "title": 'Take a Break',
        "author": 'BeraTera',
        "description": 'It Healthy to have a break',
        "year": '2017'
      }
    ];
    for (final read in reads) {
      await database.store.execute(
          'INSERT INTO _Read(title, author,description, year) VALUES(@title,@author, @description, @year)',
          substitutionValues: {
            'title': read['title'],
            'author': read['author'],
            'description': read['description'],
            'year' : read ['year']
          });
    }
  }
}
