import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


import '../model/color_controller.dart';
import '../model/etudiant.dart';
import 'widgetother/custom_text.dart';

class vueliste extends StatefulWidget{

  late List<Etudiant> etudiant;
   vueliste(List<Etudiant> etudiant){
    this.etudiant=etudiant;
  }
  @override
  __vuelisteState createState() =>new __vuelisteState();
}
class __vuelisteState extends State<vueliste>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final ColorsController colorscontroller = Get.put(ColorsController());
    final taille=MediaQuery.of(context).size.width/2.5;
    return new ListView.builder(
        itemCount: widget.etudiant.length,
        padding: const EdgeInsets.all(8),
        itemBuilder: (context,i){
          return new Container(
            child: new InkWell(
              onTap: ()=>{
                print("ici")
              },
              child: new Card(
                elevation: 10.0,
                color: colorscontroller.colorSelected,
                child: new Column(
                  children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(10),
                        height:50,
                        child:new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new CustomText(widget.etudiant[i].nom,factor: 1.5,color: Colors.white,),
                            new Container(
                                width: taille,
                                child: new CustomText(widget.etudiant[i].ref_qrcode,factor: 1.5,color: Colors.white,)
                            ),
                          ],
                        ),
                      )
                  ],
                ),
              ),
            )
          );
        }
    );
  }

}