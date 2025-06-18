import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

enum ToastType { success, error, info }

class ToastHelper {
  static void showToast({
    required String message,
    ToastType type = ToastType.info,
  }) {
    final color = {
      ToastType.success: Colors.green,
      ToastType.error: Colors.red,
      ToastType.info: Colors.blueGrey,
    }[type]!;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Fluttertoast.showToast(
        msg: message,
        backgroundColor: color,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    });
  }
}
