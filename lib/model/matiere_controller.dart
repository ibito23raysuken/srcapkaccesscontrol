import 'package:get/get.dart';

class Matierecontroller extends GetxController {
  String? _matiereselected;
  String get matiereSelected=>_matiereselected ??"";
  void changematiere(String matiere) {
    print("change couleur");
    _matiereselected=matiere;
    update();
  }
}