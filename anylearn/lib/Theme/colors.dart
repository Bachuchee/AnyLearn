import 'dart:ui';

import 'package:flutter/material.dart';

// primary theme

const primaryColor = Color(0xFFB4D7F9);
const secondaryColor = Color(0xFF304D85);
const primarySurface = Color(0xFFCDE5FF);
const secondarySurface = Color(0xFFD8E2FF);

// extra chip colors
const selectedColor = Color(0xFFB7EBAD);

const scheme = ColorScheme(
  brightness: Brightness.light,
  primary: secondaryColor,
  onPrimary: secondarySurface,
  secondary: primarySurface,
  onSecondary: primarySurface,
  error: Colors.red,
  onError: Colors.white,
  background: Colors.white,
  onBackground: secondaryColor,
  surface: Colors.white,
  onSurface: secondaryColor,
);
