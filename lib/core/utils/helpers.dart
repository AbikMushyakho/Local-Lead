import 'package:flutter/material.dart';

class Responsive {
  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;

  // Percentage of screen width
  static double wp(BuildContext context, double percent) =>
      MediaQuery.of(context).size.width * percent / 100;

  // Percentage of screen height
  static double hp(BuildContext context, double percent) =>
      MediaQuery.of(context).size.height * percent / 100;

  // Scaled font size
  static double sp(BuildContext context, double size) =>
      MediaQuery.of(context).size.width * size / 375;

  // Device type checks
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600;
}