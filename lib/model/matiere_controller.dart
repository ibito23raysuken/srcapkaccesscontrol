import 'package:get/get.dart';

class Matierecontroller extends GetxController {
  String? _matiereselected;
  String get matiereSelected=>_matiereselected ??"";
  void changematiere(String matiere) {
    _matiereselected=matiere;
    update();
  }
}