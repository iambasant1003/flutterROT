import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PanInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text.toUpperCase();
    final buffer = StringBuffer();
    int selectionIndex = newValue.selection.end;

    for (int i = 0; i < newText.length && i < 10; i++) {
      final char = newText[i];

      if (i < 5) {
        // Must be A-Z
        if (!_isLetter(char)) continue;
      } else if (i < 9) {
        // Must be 0-9
        if (!_isDigit(char)) continue;
      } else if (i == 9) {
        // Must be A-Z
        if (!_isLetter(char)) continue;
      }

      buffer.write(char);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(
        offset: buffer.length.clamp(0, selectionIndex),
      ),
    );
  }

  bool _isLetter(String char) {
    return RegExp(r'^[A-Z]$').hasMatch(char);
  }

  bool _isDigit(String char) {
    return RegExp(r'^\d$').hasMatch(char);
  }
}
