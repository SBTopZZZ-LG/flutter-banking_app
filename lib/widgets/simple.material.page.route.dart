import 'package:flutter/material.dart';

class SimpleMaterialPageRoute extends MaterialPageRoute {
  SimpleMaterialPageRoute({required WidgetBuilder builder}) : super(builder: builder);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 600);
}