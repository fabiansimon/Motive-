import 'package:flutter/material.dart';

Color green1 = const Color(0xFF1ECF34);
Color green2 = const Color(0xFF40E963);

Color red1 = const Color(0xFFFF0000);
Color red2 = const Color(0xFFA41616);

Color blue1 = const Color(0xFF0091FF);
Color blue2 = const Color(0xFF00C4FF);

// Color blue1 = Color(0xFFB620E0);
// Color blue2 = Color(0xFF8E13B0);

Color backgroundColor = const Color(0xFFF9FAFC);

LinearGradient blueGradient = LinearGradient(
  colors: [
    blue1,
    blue2,
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

LinearGradient redGradient = LinearGradient(
  colors: [
    red1,
    red2,
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

LinearGradient greenGradient = LinearGradient(
  colors: [
    green1,
    green2,
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
