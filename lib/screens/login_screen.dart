import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/color_controller.dart';
import '../model/matiere_controller.dart';
import '../utilities/constants.dart';
import '../model/auth_controller.dart';
import '../widget/widgetpopup/showDialogConnexion.dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController authController = Get.find();
  final Matierecontroller matiereController = Get.put(Matierecontroller());
  final ColorsController colorscontroller = Get.put(ColorsController());
  TextEditingController nomController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Widget _buildEmailTF() {
    matiereController.changematiere("");
    print(matiereController.matiereSelected);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Nom Enseignant',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: nomController,
            keyboardType: TextInputType.name,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.account_circle,
                color: Colors.white,
              ),
              hintText: 'Entrer votre nom',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: colorscontroller.colorbool? kBoxDecorationStyle : kBoxDecorationStyle1,
          height: 60.0,
          child: TextField(
            controller: passwordController,
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed:isLoading ? null : () async {
          setState(() {
            isLoading = true;
          });
          try {
            await authController.login(nomController.text, passwordController.text);
            if(!await authController.login(nomController.text, passwordController.text)){
              ShowDialogConnexion.Show(context);
            }
          } catch (error) {
            print(error);
          } finally {
            setState(() {
              isLoading = false;
            });
          }
        },
        child:isLoading ?
        Container(
          color: Colors.transparent,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ) :
        Text(
          'LOGIN',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorscontroller.colorSelected,
        actions: <Widget>[
          IconButton(onPressed: ()=>{colorscontroller.changeColor(colorscontroller.colorbool),setState(() {
            colorscontroller.colorbool;
          })}, icon: Icon(colorscontroller.colorbool?Icons.sunny:Icons.nightlight_round,color: Colors.white,))
        ],
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: !colorscontroller.colorbool?[
                      Color(0xFF673AB7),
                      Color(0xFF7E57C2),
                      Color(0xFF9575CD),
                      Color(0xFFB39DDB),
                    ]:[
                      colorscontroller.colorSelected,
                      colorscontroller.colorSelected,
                      colorscontroller.colorSelected,
                      colorscontroller.colorSelected,
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      _buildEmailTF(),
                      SizedBox(
                        height: 30.0,
                      ),
                      _buildPasswordTF(),
                      _buildLoginBtn(),

                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
