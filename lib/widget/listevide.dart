import 'package:flutter/material.dart';

class DonnesVide extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return new Center(
      child: new Text("Aucune élève n'est présente",
        textScaleFactor: 2.5,
        textAlign: TextAlign.center,
        style: new TextStyle(
            color: Colors.red,
            fontStyle: FontStyle.italic
        ),),
    );
  }
}