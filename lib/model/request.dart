import 'dart:convert';
import 'package:http/http.dart' as http;
import 'etudiant.dart';

  // A function that converts a response body into a List<Photo>.
  List<Etudiant> parseEtudiant(String responseBody) {
    final parsed = (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();
    return parsed.map<Etudiant>((json) => Etudiant.fromJson(json)).toList();
  }

  Future<List<Etudiant>> fetchEtudiant(http.Client client) async {
    final url='http://192.168.152.251:8000/api/etudiant';
    final response = await client.get(Uri.parse(url));
    // Use the compute function to run parsePhotos in a separate isolate.
    String responseapi = response.body.toString().replaceAll("\n","");
    print(responseapi);
    return parseEtudiant(responseapi);
  }
  //*******************************----------------------------------/*
Future<void> postEtudiant(List<Etudiant> etudiand) async {
  final url = Uri.parse('http://192.168.152.251:8000/api/etudiant');
  // The data you want to send
  String jsonTags = jsonEncode(etudiand);
  final data = jsonTags;
  try {
    final response = await http.post(
      url,
      body: data,
    );
    if (response.statusCode == 200) {
      print('Data posted successfully');
      print(response.body);
    } else {
      print('Failed to post data: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
