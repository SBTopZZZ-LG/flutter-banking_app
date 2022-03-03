import 'package:flutter/material.dart';

abstract class DatabaseModel {
  final int id;

  DatabaseModel({required this.id});

  Future<void> save();
  Future<void> refresh();

  void saveAndRefresh() async {
    await save();
    await refresh();
  }

  Map<String, dynamic> toJson();
}

abstract class DatabaseModelList extends ChangeNotifier {}