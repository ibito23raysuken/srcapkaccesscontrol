import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  RxBool isLoggedIn = false.obs;
  Map<String, dynamic> apiData = {};
  static const String isLoggedInKey = 'isLoggedIn';
  static const String apiDataKey = 'apiData';

  Future<void> login(String nom, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.43.220:8000/api/enseignant/login'),
        body: {
          'nom': nom,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData);
        isLoggedIn.value = true;
        apiData = responseData['data'];
        await saveAuthData();

      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String errorMessage = responseData['message'];
        print('Erreur de connexion: $errorMessage');
        isLoggedIn.value = false;
      }
    } catch (error) {
      // Gérez les erreurs d'exception ici
      print('Erreur lors de la connexion: $error');
      isLoggedIn.value = false;
    }
  }

  Future<void> logout() async {
    // Effacez les informations d'authentification dans SharedPreferences
    await clearAuthData();
    isLoggedIn.value = false;
  }

  // Fonction pour stocker les informations d'authentification dans SharedPreferences
  Future<void> saveAuthData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(isLoggedInKey, true);
    prefs.setString(apiDataKey, json.encode(apiData));
  }

  // Fonction pour récupérer les informations d'authentification depuis SharedPreferences
  Future<void> getAuthData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLoggedIn.value = prefs.getBool(isLoggedInKey) ?? false;
    String apiDataString = prefs.getString(apiDataKey) ?? '[]';
    apiData = json.decode(apiDataString);
  }

  // Fonction pour effacer les informations d'authentification dans SharedPreferences
  Future<void> clearAuthData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(isLoggedInKey);
    prefs.remove(apiDataKey);
  }
}
