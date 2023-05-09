import 'package:flutter/material.dart';

Widget loginButton({
  required VoidCallback onTap,
  required String assetImage,
  required Color backgroundColor,
  required double scale,
}) {
  return InkWell(
    onTap: onTap,
    child: CircleAvatar(
      backgroundColor: backgroundColor,
      radius: 35,
      child: Transform.scale(
        scale: scale,
        child: Image.asset(
          assetImage,
          fit: BoxFit.contain,
        ),
      ),
    ),
  );
}
