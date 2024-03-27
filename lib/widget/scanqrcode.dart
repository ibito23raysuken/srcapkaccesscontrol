import 'dart:async';
import 'dart:developer';

import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:srccontrolaccess/widget/presence.dart';
import 'package:vibration/vibration.dart';
import '../model/databaseClient.dart';
import '../model/etudiant.dart';
import '../model/request.dart';
import 'widgetother/custom_text.dart';

class Scanqrcode extends StatefulWidget {
  const Scanqrcode({super.key, required this.title});

  final String title;

  @override
  State<Scanqrcode> createState() => _ScanqrcodeState();
}

//-------------------------------------------------------------------------------//
class _ScanqrcodeState extends State<Scanqrcode> {
  List<Etudiant> recup = [];
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (io.Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }
  @override
  void initState(){
    super.initState();
    recuperer();
  }

  @override
  Widget build(BuildContext context) {
    if(result != null){
      print('test vibration');
      setState(() {
        Vibration.vibrate(duration: 1000);
      });

    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title,style: new TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                      Text('Data: ${result!.code}',style: TextStyle(height: 1, fontSize: 30))
                  else
                    const Text('Scan du code',style: TextStyle(height: 1, fontSize: 30)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton.icon(
                            icon: FutureBuilder(
                              future: controller?.getFlashStatus(),
                              builder: (context, snapshot) {
                                if(snapshot!.data==true){
                                  return new Icon(Icons.flash_on,color: Colors.white);
                                }
                                else{
                                  return new Icon(Icons.flash_off,color:  Colors.white);
                                }}),
                            style: ElevatedButton.styleFrom(
                                fixedSize: Size(MediaQuery.of(context).size.width*0.8,50),
                                backgroundColor: Colors.deepPurple,
                                shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20))
                            ),
                            onPressed: () async {
                              await controller?.toggleFlash();
                              setState(() {});
                            },
                            label: FutureBuilder(
                              future: controller?.getFlashStatus(),
                              builder: (context, snapshot) {
                                return new CustomText('Flash',factor: 1.5);
                              },
                            )),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(MediaQuery.of(context).size.width*0.8,50),
                              backgroundColor: Colors.deepPurple,
                              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20))
                          ),
                          onPressed: verification,
                          child: new CustomText('Verifier',factor: 1.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

//-----------------------------------------------------------------------//

  Future<void> recuperer() async {
    List<Etudiant> listeetudiant = await fetchEtudiant(http.Client());
    setState(() {
      for (Etudiant etudiant in listeetudiant) {
        recup.add(etudiant);
      }
    });
  }
  Future<Null> Showdialogue(BuildContext context) async{
    await showDialog(
        builder: (BuildContext buildContext){
          return new AlertDialog(
            title: new Text("Veuillez rescanner le QR code"),
            actions: <Widget>[
              new TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                    controller!.resumeCamera();
                  },
                  child: new Text("OK",style: new TextStyle(color: Colors.blue)))
            ],
          );
        }, context: context
    );
  }
//--------------------verification---------------------------------------------------//
  verification() {
    recup.forEach((element) {
      print(element);
      print(result?.code);
      if(element.ref_qrcode==result?.code){
        databaseClient().ajoutItem(element);
        Navigator.pop(context,true);
      }
    });
    if(result?.code==null){
      Showdialogue(context);
    }
  }
//--------------------fin---------------------------------------------------//
}