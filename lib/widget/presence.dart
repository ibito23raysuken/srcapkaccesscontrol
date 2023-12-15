
import 'package:flutter/material.dart';
import 'package:srccontrolaccess/widget/scanqrcode.dart';

import '../model/databaseClient.dart';
import '../model/etudiant.dart';
import '../model/request.dart';
import 'listevide.dart';


class Presence extends StatefulWidget {
  const Presence({super.key, required this.title});

  final String title;
  @override
  State<Presence> createState() => _Presence();
}

//-------------------------------------------------------------------------------//
class _Presence extends State<Presence> {
  List<Etudiant> recupelevepresent = [];
  late int index;
  void initState(){
    super.initState();
    recuperer();
  }

  Future<void>  recuperer() async {
    List<Etudiant> listeetudiant = await databaseClient().allItem();
    for (Etudiant etudiant in listeetudiant) {
      recupelevepresent.add(etudiant);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Liste des étudiants présents ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RobotoMono',
                  fontSize: 20,
                ),
              ),
              Flexible(
                  child: (recupelevepresent == null||recupelevepresent?.length==0)
                      ?new DonnesVide()
                      :new ListView.builder(
                      itemCount: recupelevepresent.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: UniqueKey(),
                          background:  Container(
                            color: Colors.red,
                            child: Align(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: Icon(Icons.delete),
                              ),
                              alignment: Alignment.centerRight,
                            ),
                          ),
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.startToEnd) {
                              return false;
                            } else {
                              bool delete = true;
                              final snackbarController = ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: Duration(seconds: 1),
                                  content: Text('Deleted ${recupelevepresent[index].nom}'),
                                  action: SnackBarAction(label: 'Undo', onPressed: () => delete = false),
                                ),
                              );
                              await snackbarController.closed;
                                databaseClient().delete(recupelevepresent[index].id, 'presence').then((int){
                                  print("L int recuperer et le : $int");
                                });
                              setState(() {
                                recupelevepresent = [];
                                recuperer();
                              });

                              return delete;
                            }
                          },
                          onDismissed: (direction) async {
                          },
                          child: Card( //                           <-- Card widget
                              child: ListTile(
                                leading: Icon(Icons.account_circle,size: 50),
                                title: Text(recupelevepresent[index].nom),
                                subtitle: Text(recupelevepresent[index].ref_qrcode),
                        )),
                        );
                      })
              ),
            ])
    ),
    floatingActionButton: Container(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 75,
              height: 75,
              child: FittedBox(
                child: FloatingActionButton(
                  backgroundColor: Colors.deepPurple,
                  shape: new CircleBorder(),
                  heroTag: "btn1",
                  onPressed: post_presence,
                  child: Icon(Icons.save,color: Colors.white),
                ),
              ),
            ),const Padding(
              padding: EdgeInsets.all(8.0),
            ),
            SizedBox(
              width: 75,
              height: 75,
              child: FittedBox(
                child: FloatingActionButton(
                  backgroundColor: Colors.deepPurple,
                  heroTag: "btn2",
                  shape: new CircleBorder(),
                  onPressed: vers_scanarcode,
                  child: Icon(Icons.add,color: Colors.white),
                ),
              ),
            ),
          ],
        ),

      ),);
  }
  void post_presence(){
    print(recupelevepresent);
    if(recupelevepresent==Null){
      print("vide");
    }
    else{
      postEtudiant(recupelevepresent);
    }
  }
  //les differente fonction
  void vers_scanarcode(){
    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
      return new Scanqrcode(title: 'Control Access System');
    }));
  }
}
