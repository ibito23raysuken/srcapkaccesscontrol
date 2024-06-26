import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:srccontrolaccess/widget/presence.dart';
import '../model/color_controller.dart';
import 'List_etudiants.dart';
import 'home_page.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final ColorsController colorscontroller = Get.put(ColorsController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorscontroller.colorSelected,
        title: Text(widget.title,style: new TextStyle(color: Colors.white)),
        actions: <Widget>[
          IconButton(onPressed: ()=>{colorscontroller.changeColor(colorscontroller.colorbool),setState(() {
            colorscontroller.colorbool;
          })}, icon: Icon(colorscontroller.colorbool?Icons.sunny:Icons.nightlight_round,color: Colors.white,))
        ],
      ),
      body: <Widget>[
        homepage(),
        Presence(title: "Control Access System"),
        List_etudiants(),
      ][_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: colorscontroller.colorSelected,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle,color: Colors.white),
            label: 'Profil',

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list,color: Colors.white),
            label: 'Faire la presence',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school,color: Colors.white),
            label: 'Liste etudiant',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
  //index bar
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Presence',
      style: optionStyle,
    ),
    Text(
      'Index 2: Liste',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}