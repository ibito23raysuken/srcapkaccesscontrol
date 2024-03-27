import 'package:flutter/material.dart';
import 'package:srccontrolaccess/widget/scanqrcode.dart';
import 'package:get/get.dart';
import 'package:srccontrolaccess/widget/widgetpopup/showDialogsend.dart';
import 'widgetpopup/PresentationPopup.dart';
import '../model/databaseClient.dart';
import '../model/etudiant.dart';
import '../model/matiere_controller.dart';
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
  bool isExpanded = false;
  final Matierecontroller matiereController = Get.put(Matierecontroller());
  List<Etudiant> recupelevepresent = [];
  late int index;

  void initState() {
    print(matiereController.matiereSelected);
    super.initState();
    recuperer();
  }

  Future<void> recuperer() async {
    List<Etudiant> listeetudiant = await databaseClient().allItem();
    setState(() {
      recupelevepresent = listeetudiant;
    });
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
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontFamily: 'RobotoMono',
              fontSize: 20,
            ),
          ),Text(
              matiereController.matiereSelected=="" || matiereController.matiereSelected=="Liste des matieres" ?"Aucune matière sélectionnée.":'Matiere ${matiereController.matiereSelected}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono',
            fontSize: 20,
          ),
        ),Flexible(
          child: (recupelevepresent == null || recupelevepresent?.length == 0)
              ? new DonnesVide()
              : new ListView.builder(
              itemCount: recupelevepresent.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(
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
                      final snackbarController =
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text(
                              'Deleted ${recupelevepresent[index].nom}'),
                          action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () => delete = false),
                        ),
                      );
                      await snackbarController.closed;
                      databaseClient()
                          .delete(
                          recupelevepresent[index].id, 'presence')
                          .then((int) {
                        print("L int recuperer et le : $int");
                      });
                      setState(() {
                        recupelevepresent = [];
                        recuperer();
                      });

                      return delete;
                    }
                  },
                  onDismissed: (direction) async {},
                  child: Card(
                      child: ListTile(
                        leading: Icon(Icons.account_circle, size: 50),
                        title: Text(recupelevepresent[index].nom),
                        subtitle:
                        Text(recupelevepresent[index].ref_qrcode),
                      )),
                );
              }),
        )
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Visibility(
            visible: isExpanded,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: FittedBox(
                      child: FloatingActionButton(
                        backgroundColor: Colors.deepPurple,
                        heroTag: "btn3",
                        shape: new CircleBorder(),
                        onPressed: (){
                          effacer();
                          setState(() {
                            recupelevepresent = [];
                            recuperer();
                          });
                        },
                        child: Icon(Icons.clear_all, color: Colors.white),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(7.0),
                  ),
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: FittedBox(
                      child: FloatingActionButton(
                        backgroundColor: Colors.deepPurple,
                        shape: new CircleBorder(),
                        heroTag: "btn1",
                        onPressed: post_presence,
                        child: Icon(Icons.save, color: Colors.white),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(7.0),
                  ),
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: FittedBox(
                      child: FloatingActionButton(
                        backgroundColor: Colors.deepPurple,
                        heroTag: "btn2",
                        shape: new CircleBorder(),
                        onPressed: vers_scanarcode,
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(7.0),
          ),
          FloatingActionButton(
            backgroundColor: !isExpanded ? Colors.deepPurple:Colors.red,
            shape: isExpanded ? new CircleBorder() :RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            onPressed: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: !isExpanded?Icon(Icons.menu, color: Colors.white):Icon(Icons.clear, color: Colors.white),
          ),
        ],
      )
    );
  }

  Future<void> post_presence() async {
    print(recupelevepresent.length);
    if (recupelevepresent.length == 0) {
      ShowDialogSend.Show(context);
    } else {
      if (await postEtudiant(recupelevepresent,matiereController.matiereSelected)) {
        PresentationPopup.show(context);
      }
    }
  }

  Future<void> effacer() async {
    if (recupelevepresent.isNotEmpty) {
      setState(() {
        databaseClient()
            .deleteallitem('presence')
            .then((int) {
          recupelevepresent.clear();
        });
      });
    }
  }

  void vers_scanarcode() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return Scanqrcode(title: 'Control Access System');
    })).then((value) {
      recuperer();
    });
  }
}
