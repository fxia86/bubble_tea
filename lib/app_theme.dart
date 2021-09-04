// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemeData {
  static const _lightFillColor = Colors.black;
  static const _darkFillColor = Colors.white;

  static final Color _lightFocusColor = Colors.black.withOpacity(0.12);
  static final Color _darkFocusColor = Colors.white.withOpacity(0.12);

  static ThemeData lightThemeData =
      themeData(lightColorScheme, _lightFocusColor);
  static ThemeData darkThemeData = themeData(darkColorScheme, _darkFocusColor);

  static ThemeData themeData(ColorScheme colorScheme, Color focusColor) {
    return ThemeData().copyWith(
      colorScheme: colorScheme,
      primaryColor: const Color(0xFF2196F3),
      accentColor: const Color(0xFFE3F2FD),
      scaffoldBackgroundColor: const Color(0xFFF4F9FC),
      backgroundColor: const Color(0xFFF4F9FC),
      dividerColor: const Color(0xFFE5E5E5),
      textTheme: appTextTheme,
      iconTheme: IconThemeData(size: 24 * textScale),
      appBarTheme: AppBarTheme().copyWith(
        backgroundColor: Colors.white,
        elevation: 2,
        iconTheme: IconThemeData(color: const Color(0xFFB4B4B4)),
      ),
      dataTableTheme: DataTableThemeData(
        headingRowColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered))
            return const Color(0xFFE3F2FD);
          return const Color(0xFFE3F2FD);
        }),
        headingTextStyle:
            appTextTheme.bodyText1?.copyWith(color: const Color(0xFF2196F3)),
        dataRowColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) return Colors.white;
          return Colors.white; // Use the default value.
        }),
        dataTextStyle: appTextTheme.bodyText1,
        dataRowHeight: 80,
        dividerThickness: 0,
      ),
    );
  }

  static const ColorScheme lightColorScheme = ColorScheme(
    primary: Color(0xFF2196F3),
    primaryVariant: Color(0xFF29B6F6),
    secondary: Color(0xFFFF5128),
    secondaryVariant: Color(0xFFFF5128),
    background: Color(0xFFF4F9FC),
    surface: Color(0xFFFAFBFB),
    onBackground: Colors.white,
    error: _lightFillColor,
    onError: _lightFillColor,
    onPrimary: _lightFillColor,
    onSecondary: Color(0xFF322942),
    onSurface: Color(0xFF241E30),
    brightness: Brightness.light,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    primary: Color(0xFFFF8383),
    primaryVariant: Color(0xFF1CDEC9),
    secondary: Color(0xFF4D1F7C),
    secondaryVariant: Color(0xFF451B6F),
    background: Color(0xFF241E30),
    surface: Color(0xFF1F1929),
    onBackground: Color(0x0DFFFFFF), // White with 0.05 opacity
    error: _darkFillColor,
    onError: _darkFillColor,
    onPrimary: _darkFillColor,
    onSecondary: _darkFillColor,
    onSurface: _darkFillColor,
    brightness: Brightness.dark,
  );

  static const _regular = FontWeight.w400;
  static const _medium = FontWeight.w500;
  static const _semiBold = FontWeight.w600;
  static const _bold = FontWeight.w700;

  static final TextTheme _textTheme = TextTheme(
    headline4: GoogleFonts.montserrat(fontWeight: _bold, fontSize: 20.0),
    caption: GoogleFonts.oswald(fontWeight: _semiBold, fontSize: 16.0),
    headline5: GoogleFonts.oswald(fontWeight: _medium, fontSize: 16.0),
    subtitle1: GoogleFonts.montserrat(fontWeight: _medium, fontSize: 16.0),
    overline: GoogleFonts.montserrat(fontWeight: _medium, fontSize: 12.0),
    bodyText1: GoogleFonts.montserrat(fontWeight: _regular, fontSize: 14.0),
    subtitle2: GoogleFonts.montserrat(fontWeight: _medium, fontSize: 14.0),
    bodyText2: GoogleFonts.montserrat(fontWeight: _regular, fontSize: 16.0),
    headline6: GoogleFonts.montserrat(fontWeight: _bold, fontSize: 16.0),
    button: GoogleFonts.montserrat(fontWeight: _semiBold, fontSize: 14.0),
  );

/*
default
headline1    96.0  light   -1.5
headline2    60.0  light   -0.5
headline3    48.0  regular  0.0
headline4    34.0  regular  0.25
headline5    24.0  regular  0.0
headline6    20.0  medium   0.15
subtitle1    16.0  regular  0.15
subtitle2    14.0  medium   0.1
body1        16.0  regular  0.5   (bodyText1)
body2        14.0  regular  0.25  (bodyText2)
button       14.0  medium   1.25
caption      12.0  regular  0.4
overline     10.0  regular  1.5
 */

/*
design
title: bold/regular 28 0
tab: medium/regular 24 0
bodytext: regular 20 0.15
caption: 16 0.15
 */

  static final TextTheme appTextTheme = TextTheme()
      .copyWith(
        headline3: //price
            TextStyle(fontSize: 28, fontWeight: _regular, letterSpacing: 0),
        headline5: //title/tab/button
            TextStyle(fontSize: 24, fontWeight: _regular, letterSpacing: 0),
        bodyText1: //bodytext
            TextStyle(fontSize: 20, fontWeight: _regular, letterSpacing: 0.15),
        subtitle1: //tips
            TextStyle(fontSize: 16, fontWeight: _regular, letterSpacing: 0.15),
      )
      .apply(bodyColor: Colors.black87, displayColor: Colors.black87);

  static double textScale = _getTextScaleFactor();

  static double _getTextScaleFactor() {
    return Get.width / 1440;
  }
}
