import 'package:flutter/material.dart';

import './database.model.dart';

import '../utils/sqlite.dart';

class User extends DatabaseModel with ChangeNotifier {
  String name;
  String email;
  int balance;
  String phone;
  String occupation;

  User({
    required int id,
    required this.name,
    required this.email,
    required this.balance,
    required this.phone,
    required this.occupation,
  }) : super(id: id);

  void copy(User another) {
    name = another.name;
    email = another.email;
    balance = another.balance;
    phone = another.phone;
    occupation = another.occupation;
  }

  String get getAvatar =>
      "${name.substring(0, 1).toUpperCase()}${name.split(" ").last.substring(0, 1).toUpperCase()}";

  @override
  Future<void> refresh() async {
    Map<String, dynamic> map =
        (await Db.get!.query("users", where: "id = $id"))[0];
    name = map["name"];
    email = map["email"];
    balance = map["balance"];
    phone = map["phone"];
    occupation = map["occupation"];
  }

  @override
  Future<void> save() async {
    if ((await Db.get!.query("users", where: "id = $id")).isEmpty) {
      await Db.get!.insert("users", toJson());
    } else {
      await Db.get!.update("users", toJson(), where: "id = $id");
    }
  }

  @override
  void saveAndRefresh() {
    super.saveAndRefresh();
    notifyListeners();
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        "id": id,
        "name": name,
        "email": email,
        "balance": balance,
        "phone": phone,
        "occupation": occupation,
      };
  static User fromJson(Map<String, dynamic> map) => User(
        id: map["id"],
        name: map["name"],
        email: map["email"],
        balance: map["balance"],
        phone: map["phone"],
        occupation: map["occupation"],
      );

  static Future<User?> get(int id) async {
    List<Map<String, dynamic>> query =
        await Db.get!.query("users", where: "id = $id");

    if (query.isEmpty) return null;

    return User.fromJson(query.first);
  }

  static Future<Map<int, User>?> getAll() async {
    List<Map<String, dynamic>> query =
        await Db.get!.query("users", orderBy: "id ASC");

    Map<int, User> mappedData = {};
    for (final userJson in query) {
      mappedData[userJson["id"]] = User.fromJson(userJson);
    }

    return mappedData;
  }
}

class Users extends DatabaseModelList {
  late Map<int, User> _users;
  Map<int, User> get get => _users;

  Users({Map<int, User>? initialValue}) {
    _users = initialValue ?? {};
  }
}
