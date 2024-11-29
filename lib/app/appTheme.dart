import 'package:flutter/material.dart';

class ThemeColor {
  final Color lightModeColor;
  final Color darkModeColor;

  const ThemeColor({
    required this.lightModeColor,
    required this.darkModeColor,
  });

  /// Returns the appropriate color based on the current theme
  Color resolve(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkModeColor
        : lightModeColor;
  }
}
