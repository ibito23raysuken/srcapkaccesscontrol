import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../model/auth_controller.dart';
import '../model/color_controller.dart';
import '../model/matiere_controller.dart';
class homepage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _homepage();
  }
}

class _homepage extends State<homepage> {
  final AuthController authController = Get.find();
  final Matierecontroller matiereController = Get.put(Matierecontroller());
  final ColorsController colorscontroller = Get.put(ColorsController());

  var theme1 = Colors.white;
  var theme2 = Color(0xff2E324F);
  //var white = Colors.white;
  var black = Colors.black;
  bool switchColor = false;
  late String dropdownvalue="Liste des matieres";
  List<String> listecours = [];
  @override
  Widget build(BuildContext context) {
    authController.getAuthData();
    recuperer(authController.apiData['matiere']);
    return Scaffold(
      backgroundColor: theme1,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
          Container(
          height: 100,
          width: double.infinity,
          child:WaveWidget(
                config: CustomConfig(
                  colors: [
                    colorscontroller.colorSelected,
                    theme1,
                  ],
                  durations: [3200, 3200],
                  heightPercentages: [0.5, 0.1],
                ),
                backgroundColor: colorscontroller.colorSelected,
                size: Size(double.infinity, double.infinity),
                waveAmplitude: 5,
              )),
            Padding(
              padding: EdgeInsets.only(top: 70),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            width:400,
                            child:Padding(
                              padding: const EdgeInsets.fromLTRB(0, 35, 0, 0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                color: colorscontroller.colorSelected,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(8.0, 75, 8.0, 4.0),
                                      child: Text(
                                        authController.apiData['nom'],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 26.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
                                      child: Text(
                                        authController.apiData['prenom'],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 26.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ),
                            ),
                          Container(
                            width: double.infinity,
                            child: _profilePic(),
                            alignment: Alignment.topCenter,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 8.0),
              child: Text(
                "Matiere enseigner",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            DropdownButton(
              value: matiereController.matiereSelected=="" ?dropdownvalue :matiereController.matiereSelected,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: listecours.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownvalue=newValue!;
                  matiereController.changematiere(newValue);
                  listecours.clear();
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40.0, 8.0, 40.0, 0.0),
              child: Divider(
                color: colorscontroller.colorSelected,
                height: 50.0,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorscontroller.colorSelected,
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
              ),
              onPressed: () async {
                setState(() {
                  matiereController.changematiere("");
                });
                await authController.logout();
              },
              child:Wrap(
                children: <Widget>[
                  Icon(
                    Icons.logout,
                    color: Colors.white,
                  ), SizedBox(
                    width:10,
                  ),
                  Text('Se déconnecter',
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.5,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                    ),),
                ]
            ),
            ),
          ],
        ),
      ),
    );
  }

  Container _profilePic() => Container(
    child:  Stack(
        alignment: const Alignment(0.9, 0.9),
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 55.0,
              ),
              CircleAvatar(
                backgroundImage: AssetImage("image_assets/image1.jpeg"),
                radius: 50.0,
              ),
            ],
          ),
          Container(
            height: 30.0,
            width: 30.0,
            child: Image.asset("image_assets/verified.png"),
            alignment: Alignment.bottomCenter,
          )
        ],
      ),
  );

  Future<void> recuperer(matieres) async {
    print(matieres.length);
    listecours.clear();
    listecours.add("Liste des matieres");
      for (var value in matieres) {
        print("*** ${value["nomcours"]}");
        listecours.add(value["cours"]["nomcours"]);
    }

  }
}