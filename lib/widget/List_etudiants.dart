import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:srccontrolaccess/widget/vueliste.dart';
import '../model/etudiant.dart';
import '../model/request.dart';

class List_etudiants extends StatefulWidget {
  const List_etudiants({Key? key}) : super(key: key);

  @override
  State<List_etudiants> createState() => _List_etudiantsState();
}

class _List_etudiantsState extends State<List_etudiants> {
  List<Etudiant> recup = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    recuperer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading // Affichez un indicateur de chargement si nécessaire
          ? Center(child: CircularProgressIndicator())
          : vueliste(recup),
    );
  }

  Future<void> recuperer() async {
    try {
      List<Etudiant> listeetudiant = await fetchEtudiant(http.Client());
      if (mounted) {
        setState(() {
          recup.addAll(listeetudiant);
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Erreur lors de la récupération des données: $e');
    }
  }
}
