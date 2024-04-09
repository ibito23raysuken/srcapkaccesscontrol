import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ColorsController extends GetxController {
  Color _colorSelected=Colors.deepPurple;
  bool _Colorbool=false;
  Color get colorSelected => _colorSelected;
  bool get colorbool => _Colorbool;
  void changeColor(bool theme) {
    _Colorbool=!_Colorbool;
    if(_Colorbool){
      _colorSelected = Colors.black87;
    }else{
      _colorSelected = Colors.deepPurple;
    }
    update();
  }
}