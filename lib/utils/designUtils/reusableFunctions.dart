import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

String formatWithCommas(String text) {
  if (text.isEmpty) return text;

  // Remove existing commas and non-digit characters
  // text = text.replaceAll(',', '');
  // text = text.replaceAll( RegExp(r'^\d{1,3}(,\d{3})*(\.\d{1,2})?$'), '');

  // Add commas in thousands place
  final formatter = NumberFormat('#,###,###,###');
  double value = double.parse(text);
  return formatter.format(value);
}

String dateTimeFormatter(String time){
  DateTime dateTime = DateTime.parse(time);
  // Define the format: 'd MMM, y • hh:mm a'
  String formattedDate = DateFormat('d MMM, y     •    hh:mm a').
  format(dateTime.toLocal());
  return formattedDate;
}
class ThousandSeparatorFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // If the new value is empty, return it directly
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all non-digit characters
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Format the digits using the NumberFormat
    final formatter = NumberFormat('#,###');
    String formattedText = formatter.format(int.parse(newText));

    // Calculate the new cursor position
    int newCursorOffset = formattedText.length -
        (oldValue.text.replaceAll(RegExp(r'[^0-9]'), '').length -
            oldValue.selection.baseOffset);

    // Ensure the cursor position is valid
    newCursorOffset = newCursorOffset.clamp(0, formattedText.length);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: newCursorOffset),
    );
  }
}
