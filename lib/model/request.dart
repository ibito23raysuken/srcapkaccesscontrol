import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:srccontrolaccess/model/matiere.dart';
import 'package:srccontrolaccess/model/url_controller.dart';
import 'etudiant.dart';

import '../model/auth_controller.dart';
import 'package:get/get.dart';

import 'matiere_controller.dart';

List<Etudiant> parseEtudiant(String responseBody) {
  final parsed = (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();
  return parsed.map<Etudiant>((json) => Etudiant.fromJson(json)).toList();
}

List<Matiere>? parseMatiere(List<dynamic> responseBody) {
  List<Matiere> matieres = [];
  for (var item in responseBody) {
    matieres.add(Matiere.fromJson(item));
  }
  return matieres;
}
Future<List<Etudiant>> fetchEtudiant(http.Client client) async {
  final Matierecontroller matiereController = Get.put(Matierecontroller());
  int id_parcoureselected=0;
  final AuthController authController = Get.find();
  List<Matiere>? matiereliste =parseMatiere(authController.apiData['matiere']);
  for (var item in matiereliste!) {
    print(item.nomcours);
    print(matiereController.matiereSelected);
    if(item.nomcours==matiereController.matiereSelected){
      id_parcoureselected=item.parcours_id;
      break;
    }
  }
  print(id_parcoureselected);
  final url = '${UrlController.baseurl}/${id_parcoureselected}/etudiantliste';
  final response = await client.get(Uri.parse(url));
  String responseapi = response.body.toString().replaceAll("\n", "");
  print(responseapi);
  return parseEtudiant(responseapi);
}

Future<bool> postEtudiant(List<Etudiant> etudiants,String matiere) async {
  print(matiere);
  final url = Uri.parse('${UrlController.baseurl}/postetudiant');
  Map<String, dynamic> jsonData = {
    'etudiants': etudiants,
    'matiere': matiere,
  };
  String jsonString = jsonEncode(jsonData);
  try {
    final response = await http.post(
      url,
      body: jsonString,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      print('Données postées avec succès');
      print(response.body);
      return true;
    } else {
      print('Échec de la publication des données: ${response.statusCode}');
    }
  } catch (e) {
    print('Erreur: $e');
  }
  return false;
}
