import 'package:flutter/material.dart';

class ErrorDialogue extends StatelessWidget {
  final String errorTitle;
  final String errorMessage;

  const ErrorDialogue(
      {super.key, required this.errorMessage, required this.errorTitle});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 10,
      title: Text(errorTitle),
      content: Text(errorMessage),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black87),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "OK",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        )
      ],
    );
  }
}
