import 'package:flutter/material.dart';

class DateTimeHelper {
  static Future<DateTime?> pickDateTime(BuildContext context) async {
    // Step 1: Show date picker
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return null;

    // Step 2: Show time picker
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return null;

    // Step 3: Combine date and time
    return DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
  }
}
