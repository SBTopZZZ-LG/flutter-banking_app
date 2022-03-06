import 'package:flutter/material.dart';

abstract class DatabaseModel extends ChangeNotifier {
  final int id;

  DatabaseModel({required this.id});

  Future<void> save();
  Future<void> refresh();

  Future<void> saveAndRefresh() async {
    await save();
    await refresh();
    notifyListeners();
  }

  Map<String, dynamic> toJson();
}

abstract class DatabaseModelList extends ChangeNotifier {}
