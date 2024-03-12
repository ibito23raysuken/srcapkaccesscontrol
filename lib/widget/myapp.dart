// main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/model/auth_controller.dart';
import '/screens/login_screen.dart';
import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Control Access System',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  final AuthController authController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return authController.isLoggedIn.value ? MyHomePage(title: "Control Access System") : LoginScreen();
    });
  }
}
