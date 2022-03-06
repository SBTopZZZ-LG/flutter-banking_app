import 'package:flutter/material.dart';

import './database.model.dart';
import './user.dart';
import '../utils/sqlite.dart';

class Transfer extends DatabaseModel {
  static int safeId = 0;
  int from;
  int to;
  int amount;
  int datetime;

  Transfer({
    required int id,
    required this.from,
    required this.to,
    required this.amount,
    required this.datetime,
  }) : super(id: id);

  @override
  Future<void> refresh() async {
    Map<String, dynamic> map =
        (await Db.get!.query("transfers", where: "id = $id"))[0];
    from = map["from"];
    to = map["to"];
    amount = map["amount"];
    datetime = map["datetime"];
  }

  @override
  Future<void> save() async {
    if ((await Db.get!.query("transfers", where: "id = $id")).isEmpty) {
      await Db.get!.insert("transfers", toJson());
    } else {
      await Db.get!.update("transfers", toJson(), where: "id = $id");
    }
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        "id": id,
        "from": from,
        "to": to,
        "amount": amount,
        "datetime": datetime,
      };
  static Transfer fromJson(Map<String, dynamic> map) => Transfer(
        id: map["id"],
        from: map["from"],
        to: map["to"],
        amount: map["amount"],
        datetime: map["datetime"],
      );

  static Future<Transfer?> get(int id) async {
    List<Map<String, dynamic>> query =
        await Db.get!.query("transfers", where: "id = $id");

    if (query.isEmpty) return null;

    return Transfer.fromJson(query.first);
  }

  static Future<List<Transfer>?> getAll(
      {String orderBy = "datetime DESC"}) async {
    final data = (await Db.get!.query("transfers", orderBy: orderBy))
        .map((transferJson) => Transfer.fromJson(transferJson))
        .toList();
    safeId = data.length + 1;

    return data;
  }
}

class Transfers extends DatabaseModelList {
  late List<Transfer> _transfers;
  List<Transfer> get get => _transfers;

  Transfers({List<Transfer>? initialValue}) {
    _transfers = initialValue ?? [];
  }
}
