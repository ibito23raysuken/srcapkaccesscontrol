import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:srccontrolaccess/widget/vueliste.dart';
import '../model/etudiant.dart';
import '../model/request.dart';

class List_etudiants extends StatefulWidget {
  const List_etudiants({super.key});
  @override
  State<List_etudiants> createState() => _List_etudiantsState();
}

//-------------------------------------------------------------------------------//
class _List_etudiantsState extends State<List_etudiants> {
  List<Etudiant> recup = [];
  @override
  void initState() {
    super.initState();
    recuperer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: vueliste(recup)
        );
  }
  //-----------------------------------------------------------------------//

  Future<void> recuperer() async {
    List<Etudiant> listeetudiant = await fetchEtudiant(http.Client());
    setState(() {
      for (Etudiant etudiant in listeetudiant) {
        recup.add(etudiant);
      }
    });
  }

}





