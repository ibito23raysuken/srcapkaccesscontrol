import 'package:flutter/material.dart';

class ShowDialogConnexion {
  static void Show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erreur de connexion'),
          content: Text('Impossible de se connecter au serveur. Vérifiez votre connexion internet et réessayez.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}