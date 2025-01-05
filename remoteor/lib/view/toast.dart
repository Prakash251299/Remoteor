import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white, // Text color
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.blueAccent, // Background color
      behavior: SnackBarBehavior.floating, // Floating Snackbar
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      margin: const EdgeInsets.all(16), // Adds margin
      duration: const Duration(seconds: 2), // Auto-dismiss after 2 seconds
      action: SnackBarAction(
        label: 'UNDO',
        textColor: Colors.yellowAccent,
        onPressed: () {
          // Handle undo action
          print("Undo clicked");
        },
      ),
    ),
  );
}
