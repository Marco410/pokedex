import 'package:flutter/material.dart';
import 'package:sizer_pro/sizer.dart';

class ColorStyle {
  static const primaryColor = Color(0xFFDC082E);
  static const hintDarkColor = Color(0xFF8F9098);
  static const hintColor = Color(0xFFC5C6CC);
  static const hintLightColor = Color(0xFFEFEFEF);
}

class TxtStyle {
  static final headerStyle = TextStyle(
      fontFamily: "Poppins",
      fontSize: 10.f,
      fontWeight: FontWeight.w800,
      color: Colors.white,
      letterSpacing: 1.5);

  static final labelText = TextStyle(
      fontFamily: "Poppins",
      fontSize: 7.f,
      color: Colors.black87,
      fontWeight: FontWeight.bold);

  static final labelNormalText = TextStyle(
      fontFamily: "Poppins",
      fontSize: 7.f,
      color: Colors.black87,
      fontWeight: FontWeight.normal);

  static final hintText = TextStyle(
      fontFamily: "Poppins",
      fontSize: 5.f,
      color: Colors.grey,
      fontWeight: FontWeight.w400);
}

class ShadowStyle {
  static final boxShadow = [
    BoxShadow(
      color: Color(0x26AAA9A9),
      blurRadius: 8,
      offset: Offset(0, 6),
      spreadRadius: -5,
    )
  ];

  static List<BoxShadow> containerShadow = [
    BoxShadow(
        color: Colors.black.withAlpha(50),
        blurRadius: 14,
        spreadRadius: -5,
        offset: const Offset(0, 0))
  ];
}
