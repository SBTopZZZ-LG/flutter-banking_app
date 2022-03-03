import 'package:flutter/material.dart';

final colours = [
  {
    "colour": Colors.red.shade400,
    "textColour": Colors.white,
  },
  {
    "colour": Colors.red.shade900,
    "textColour": Colors.white,
  },
  {
    "colour": Colors.black38,
    "textColour": Colors.white,
  },
  {
    "colour": Colors.green.shade800,
    "textColour": Colors.white,
  },
  {
    "colour": Colors.yellow.shade700,
    "textColour": Colors.black,
  },
  {
    "colour": Colors.blue.shade400,
    "textColour": Colors.white,
  },
  {
    "colour": Colors.blue.shade800,
    "textColour": Colors.white,
  },
  {
    "colour": Colors.purple,
    "textColour": Colors.white,
  },
  {
    "colour": Colors.purple.shade300,
    "textColour": Colors.white,
  },
  {
    "colour": Colors.pink.shade800,
    "textColour": Colors.white,
  },
  {
    "colour": Colors.brown,
    "textColour": Colors.white,
  },
  {
    "colour": Colors.grey.shade600,
    "textColour": Colors.white,
  },
  {
    "colour": Colors.cyan.shade800,
    "textColour": Colors.white,
  },
  {
    "colour": Colors.orange.shade700,
    "textColour": Colors.white,
  },
];

Color lighten(Color color, {double factor = 0.2}) => Color.fromARGB(
      color.alpha + ((255 - color.alpha) * factor).toInt(),
      color.red + ((255 - color.red) * factor).toInt(),
      color.green + ((255 - color.green) * factor).toInt(),
      color.blue + ((255 - color.blue) * factor).toInt(),
    );

Color darken(Color color, {double factor = 0.2}) => Color.fromARGB(
      (color.alpha * (1 - factor)).toInt(),
      (color.red * (1 - factor)).toInt(),
      (color.green * (1 - factor)).toInt(),
      (color.blue * (1 - factor)).toInt(),
    );
