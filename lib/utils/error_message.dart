import 'package:flutter/material.dart';

void errorPopUp(
    {required BuildContext context,
    required String message,
    SnackBarAction? action}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.grey,
    content: Text(
      message,
      style:
          Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black),
    ),
    action: action,
  ));
}
