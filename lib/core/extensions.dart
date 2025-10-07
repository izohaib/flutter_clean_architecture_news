import 'package:flutter/material.dart';

extension ThemeColors on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
}
