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

String dateTimeFormatterMDY(String time){
  DateTime dateTime = DateTime.parse(time);
  // Define the format: 'd MMM, y • hh:mm a'
  String formattedDate = DateFormat('MMM d, y').
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
String capitalizeEachWord(String input) {
  // Split the string into words
  List<String> words = input.split(' ');

  // Map each word to capitalize the first letter
  List<String> capitalizedWords = words.map((word) {
    if (word.isNotEmpty) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }
    return word; // Return empty word unchanged
  }).toList();

  // Join the words back into a single string
  return capitalizedWords.join(' ');
}

String formatFirstTitle(String input) {
  if (input.isEmpty) return input; // Handle empty string

  List<String> words = input.split(' '); // Split the string into words

  // Capitalize the first word and lowercase the others
  for (int i = 0; i < words.length; i++) {
    if (words[i].isNotEmpty) {
      words[i] = (i == 0)
          ? words[i][0].toUpperCase() + words[i].substring(1).toLowerCase() // First word
          : words[i].toLowerCase(); // Subsequent words in lowercase
    }
  }

  return words.join(' '); // Join the words back into a single string
}

double getHeight(int value){
  switch(value){
    case 0:
      return 0.2;
    case 1:
      return 0.2;
    case 2:
      return 0.2;
    case 3:
      return 0.4;
    case 4:
      return 0.5;
    case 5:
      return 0.6;
    case 6:
      return 0.7;
    case 7:
      return 0.5;
    case 8:
      return 0.5;
    case 9:
      return 0.5;
    default:
      return 0.5;
  }
}