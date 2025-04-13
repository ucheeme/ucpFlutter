import 'dart:async';
import 'dart:convert';

import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ucp/utils/designUtils/reusableWidgets.dart';
import 'package:ucp/view/bottomSheet/makeSavingsDraggableBottomSheet.dart';

import '../colorrs.dart';

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

String dateTimeFormatterMDY(String time,{String format = 'MMM d, y'}){
  DateTime dateTime = DateTime.parse(time);
  // Define the format: 'd MMM, y • hh:mm a'
  String formattedDate = DateFormat(format).
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

String getInitials(String sentence) {
  // Split the sentence into words
  List<String> words = sentence.split(' ');

  // Extract the first letter of each word, convert to uppercase, and join
  String initials = words
      .where((word) => word.isNotEmpty) // Ensure no empty strings are processed
      .map((word) => word[0].toUpperCase())
      .join('');

  return initials;
}

Future<DateTime?> selectDate(TextEditingController controller, {
  String labelText = "", context
}) async {
  DateTime? response = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100)
  );
 return response;
}
bool compareJsonStructure(dynamic json1, dynamic json2) {
  try {
    // Ensure both inputs are maps
    final Map<String, dynamic> map1 = json1 is String ? json.decode(json1) : json1;
    final Map<String, dynamic> map2 = json2 is String ? json.decode(json2) : json2;

    return _compareKeys(map1, map2);
  } catch (e) {
    print("Error comparing JSON structures: $e");
    return false;
  }
}

bool _compareKeys(Map<String, dynamic> map1, Map<String, dynamic> map2) {
  if (map1.keys.length != map2.keys.length) return false;
  for (var key in map1.keys) {
    if (!map2.containsKey(key)) return false;
    if (map1[key] is Map && map2[key] is Map) {
      if (!_compareKeys(map1[key], map2[key])) return false;
    }
  }
  return true;
}

showSlidingModalLogOut(BuildContext context,) async {
 bool response =await showDialog(
    context: context,
    // Makes the background transparent
    builder: (BuildContext context) {
      return LogOutScreen();
    },
  );
 return response;
}
//1 cash 2 cheque 3 member bank account

String getSuffix(int value) {
  // Get the last digit of the value
  int lastDigit = value % 10;

  // Check if the value is a special case (11, 12, 13)
  if (value % 100 >= 11 && value % 100 <= 13) {
    return 'th';
  }

  // Determine the suffix based on the last digit
  switch (lastDigit) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}

String convertDate(String inputDate) {
  try {
    // Parse the input date string
    DateTime parsedDate = DateFormat("MM/dd/yyyy HH:mm:ss").parse(inputDate);

    // Format the date to the desired format
    String formattedDate = DateFormat("MMM. dd, yyyy").format(parsedDate);

    return formattedDate;
  } catch (e) {
    // Handle errors gracefully
    return DateTime.now().format("F d, Y");
  }
}

Uint8List convertBase64Image(String base64String) {
  Uint8List imageBytes = base64Decode(base64String);
  return imageBytes;
}

String getOrdinalSuffix(int day) {
  if (day >= 11 && day <= 13) return "th";
  switch (day % 10) {
    case 1: return "st";
    case 2: return "nd";
    case 3: return "rd";
    default: return "th";
  }
}

/// Formats a [date] as "Fri. 22nd, 2025"
String dateFormat(DateTime date) {
  final String dayOfWeek = DateFormat("MMM").format(date); // e.g., "Fri"
  final int day = date.day;
  final String suffix = getOrdinalSuffix(day);
  final int year = date.year;
  return "$dayOfWeek. ${day}${suffix}, $year";
}