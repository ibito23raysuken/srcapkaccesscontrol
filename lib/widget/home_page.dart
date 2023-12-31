import 'package:flutter/material.dart';

class homepage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _homepage();
  }
}

class _homepage extends State<homepage> {
  var theme1 = Colors.white;
  var theme2 = Color(0xff2E324F);
  var white = Colors.white;
  var black = Colors.black;
  bool switchColor = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: theme1,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _profilePic(),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
              child: Text("Nom de L'enseignant",
                  style: TextStyle(
                      color: black,
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
              child: Text(
                "Matiere enseigner",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40.0, 8.0, 40.0, 0.0),
              child: Divider(
                color: Color(0xff78909c),
                height: 50.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _profilePic() => Container(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(50.0, 30.0, 50.0, 15.0),
      child: Stack(
        alignment: const Alignment(0.9, 0.9),
        children: <Widget>[
          CircleAvatar(
            backgroundImage: AssetImage("image_assets/image1.jpeg"),
            radius: 50.0,
          ),
          Container(
            height: 30.0,
            width: 30.0,
            child: Image.asset("image_assets/verified.png"),
            alignment: Alignment.bottomRight,
          ),
        ],
      ),
    ),
  );
}