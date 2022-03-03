import 'package:sqflite/sqflite.dart';

import '../configs/users.dart';

class Db {
  // ignore: prefer_typing_uninitialized_variables
  static Database? _db;
  static Database? get get => _db;

  static Future<void> init() async => _db = await openDatabase(
        'default.db',
        version: 1,
        onCreate: (db, version) async {
          // Creates 'users' table
          await db.execute(
            "CREATE TABLE users (id INT unsigned NOT NULL, name VARCHAR(100) NOT NULL, email VARCHAR(100) NOT NULL, balance INT unsigned NOT NULL, phone VARCHAR(50) NOT NULL, occupation VARCHAR(100) NOT NULL, PRIMARY KEY (id));",
          );

          // Pushes initial data to the database
          for (final user in users) {
            await db.insert("users", user.toJson());
          }

          // Creates 'transfers' table
          await db.execute(
            "CREATE TABLE transfers (id INT unsigned NOT NULL, 'from' INT unsigned NOT NULL, 'to' INT unsigned NOT NULL, amount INT unsigned NOT NULL, datetime BIGINT NOT NULL, PRIMARY KEY (id));",
          );
        },
      );
}
