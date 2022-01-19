import 'package:flutter/material.dart';

InputDecoration buildInputDecoration(String label) {
  return InputDecoration(
    labelStyle: const TextStyle(
      color: Color(0xFF69639F),
    ),
    label: Text(label),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: const BorderSide(
        width: 2.0,
        color: Color(0xFF69639F),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: const BorderSide(
        width: 2.0,
        color: Color(0xFF69639F),
      ),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: const BorderSide(
        width: 2.0,
        color: Color(0xFF69639F),
      ),
    ),
  );
}
