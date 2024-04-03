import 'package:flutter/material.dart';

class ColorManager {
  static Color primary = HexColor.fromHex("#00304f");
  static Color darkGrey = HexColor.fromHex("#525252");
  static Color grey = HexColor.fromHex("#737477");
  static Color lightGrey = HexColor.fromHex("#9E9E9E");
  static Color primaryOpacity70 = HexColor.fromHex("#B39E9E9E");

  //new colors
  static Color darkPrimary = HexColor.fromHex("#d17d11");
  static Color grey1 = HexColor.fromHex("#707070");
  static Color grey2 = HexColor.fromHex("#797979");
  static Color white = HexColor.fromHex("#FFFFFF");
  static Color error = HexColor.fromHex("#e61f34"); //red color
  static Color redWhite = HexColor.fromHex("#FFF3F3F4");
  static Color brownWhite = HexColor.fromHex("#F6F6F6");
  static Color green = HexColor.fromHex("#FF00C897");
  static Color darkGreen = HexColor.fromHex("#09B44D");
  static Color lightGreen = HexColor.fromHex("#D0F1DD");
  static Color shiningGreen = HexColor.fromHex("#7AF176");
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = "FF$hexColorString"; //8 char with opacity 100%
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}
