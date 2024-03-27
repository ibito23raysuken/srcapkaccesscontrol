import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:srccontrolaccess/model/url_controller.dart';

class AuthController extends GetxController {
  RxBool isLoggedIn = false.obs;
  Map<String, dynamic> apiData = {};
  static const String isLoggedInKey = 'isLoggedIn';
  static const String apiDataKey = 'apiData';

  Future<bool> login(String nom, String password) async {
    try {
      print('${UrlController.baseurl}/enseignant/login');
      final response = await http.post(
        Uri.parse('${UrlController.baseurl}/enseignant/login'),
        body: {
          'nom': nom,
          'password': password,
        },
      ).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        isLoggedIn.value = true;
        apiData = responseData['data'];
        await saveAuthData();
      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String errorMessage = responseData['message'];
        print('Erreur de connexion: $errorMessage');
        isLoggedIn.value = false;
        return false;
      }
    } catch (error) {
      print('Erreur lors de la connexion: $error');
      isLoggedIn.value = false;
      return false;
    }
    return true;
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
