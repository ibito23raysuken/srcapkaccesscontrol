import 'package:flutter/material.dart';


import '../model/etudiant.dart';
import 'custom_text.dart';

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
    final taille=MediaQuery.of(context).size.width/2.5;
    return new ListView.builder(
        itemCount: widget.etudiant.length,
        itemBuilder: (context,i){
          return new Container(
            child: new InkWell(
              onTap: ()=>{
                print("ici")
              },
              child: new Card(
                elevation: 10.0,
                child: new Column(
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new CustomText(widget.etudiant[i].nom,factor: 1.5),
                        new Container(
                          width: taille,
                          child: new CustomText(widget.etudiant[i].ref_qrcode,factor: 1.5)
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          );
        }
    );
  }

}