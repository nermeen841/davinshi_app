import 'package:flutter/material.dart';

class SmallWidget {
  static InputBorder form() {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: (Colors.white), width: 1),
      borderRadius: BorderRadius.circular(60),
    );
  }
}
