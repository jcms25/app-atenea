import 'package:flutter/material.dart';

void showSnackBarForApp(String message,BuildContext context){
  final snackBar = SnackBar(
    content: Text(message),
    action: SnackBarAction(
      label: 'Undo',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
    margin: const EdgeInsets.all(10),
    behavior: SnackBarBehavior.fixed,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);

}