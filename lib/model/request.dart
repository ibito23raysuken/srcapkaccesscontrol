import 'dart:convert';
import 'package:http/http.dart' as http;
import 'etudiant.dart';

List<Etudiant> parseEtudiant(String responseBody) {
  final parsed = (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();
  return parsed.map<Etudiant>((json) => Etudiant.fromJson(json)).toList();
}
Future<List<Etudiant>> fetchEtudiant(http.Client client) async {
  final url = 'http://192.168.43.220:8000/api/etudiantliste';
  final response = await client.get(Uri.parse(url));
  String responseapi = response.body.toString().replaceAll("\n", "");
  return parseEtudiant(responseapi);
}

Future<bool> postEtudiant(List<Etudiant> etudiants) async {
  final url = Uri.parse('http://192.168.43.220:8000/api/postetudiant');
  String jsonData = jsonEncode(etudiants);
  print(jsonData);
  try {
    final response = await http.post(
      url,
      body: jsonData,
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
