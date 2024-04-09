import 'package:flutter/material.dart';

class showDialogueEtudiant {
  static void Show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Erreur de Scanne"),
          content: Text("L'élève n'est pas connu pour ce cours."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}