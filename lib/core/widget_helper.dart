import 'package:flutter/material.dart';

abstract class WidgetHelper {
  WidgetHelper._();
  static Widget buildCircle(double radius, String? text) {
    return CircleAvatar(
      radius: radius,

      backgroundColor: Colors.white,
      child: text != null
          ? Text(
              text,
              style: TextStyle(
                color: const Color(0xFF0A3D62),
                fontSize: radius / 2,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
    );
  }
}
