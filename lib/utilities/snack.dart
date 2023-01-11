import 'package:flutter/material.dart';

snackBarShow(context, title) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.cyan,
      content: Text(
        title,
        style: TextStyle(
          color: Colors.white,
        ),
      )));
}
