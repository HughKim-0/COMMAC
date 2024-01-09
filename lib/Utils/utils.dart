import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickImage(source: source);

  if (_file != null) {
    return await _file.readAsBytes();
  }
  print("No image selected");
}

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

String stringToTimeAMPM(String time) {
  final parts = time.split(':');
  final hour = int.parse(parts[0]);
  final minute = parts[1];

  final suffix = hour >= 12 ? 'PM' : 'AM';
  final hour12 = hour % 12 == 0 ? 12 : hour % 12;

  return '$hour12:$minute $suffix';
}

String datetimeToString(dateTime) {
  return DateFormat('yyyy-MM-dd hh:mm a').format(dateTime);
}
