import 'package:flutter/material.dart';

void errorPopUp(
    {required BuildContext context,
    required String message,
    SnackBarAction? action}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style: Theme.of(context).textTheme.bodySmall,
    ),
    action: action,
  ));
}
