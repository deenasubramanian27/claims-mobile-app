import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'BottomNavBar.dart';
import 'CustomException.dart';

class HomePage extends StatefulWidget {
  @override
  HomePaging createState() => HomePaging();
}

class HomePaging extends State<HomePage> {
  Map<String, dynamic> map = new Map();
  String claimValue, imgValue;
  var viewVisible = false;
  String vehcileNo = "";
  String key = "";
  double estimation1 = 0.0;
  bool claimNotify = false;
  String imageUrl = "";
  int storageSize = 0;
  // ignore: non_constant_identifier_names
  String StatusMsg = '';
  String imagePath = "";
  File _image = new File('');
  double mino, moderate, severe, res;
  var rest;
  final picker = ImagePicker();

  Future<String> getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        imagePath = pickedFile.path;
        print(imagePath);
        var img = pickedFile.path;
        _image = File(imagePath);
        showAlertDialog(context);

        var data = callService(img);
        data.then((value) => handle(value));

        // data.then((value) => {
        //       mino = damage.fromJson(jsonDecode(value)).estimate.d01Minor,
        //       moderate =
        //           damage.fromJson(jsonDecode(value)).estimate.d02Moderate,
        //       severe = damage.fromJson(jsonDecode(value)).estimate.d03Severe,
        //       print("result"),
        //       res=max(e1.d01Minor, e1.d02Moderate),
        //     }
        //     );

      } else {
        print('No image selected.');
      }
    });

    return imagePath;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepOrange,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 400,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(.0),
                decoration: BoxDecoration(
                    color: Colors.white70,
                    border: Border.all(width: 3.0, color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    image: DecorationImage(
                        alignment: Alignment.center,
                        image: FileImage(_image),
                        fit: BoxFit.cover)),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(5),
                    color: Colors.black.withOpacity(0.3),
                    height: 80,
                    width: MediaQuery.of(context).size.width,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: new Text(
                        "Damaged Vechile",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ),
              ),
              ButtonBar(
                  children: [
                    Container(
                        width: 200,
                        height: 45,
                        child: TextField(
                          onChanged: (value) => vehcileNo = value,
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2.0),
                            ),
                            border: OutlineInputBorder(),
                            helperStyle: TextStyle(color: Colors.white),
                            labelText: 'Enter Vechile Number',
                            hintText: 'TN01-5555',
                            hintStyle: TextStyle(color: Colors.white),
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          autofocus: false,
                        )),
                    // ignore: deprecated_member_use
                    RaisedButton(
                      onPressed: () async {
                        await getImage();
                      },
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Upload File',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.orange,
                              ),
                            ),
                            Icon(
                              Icons.arrow_upward,
                              color: Colors.orange,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                  alignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min),
              // SizedBox(
              //   width: 400.0,
              //   child: TextLiquidFill(
              //     text: map.values.toString(),
              //     waveColor: Colors.white,
              //     boxBackgroundColor: Colors.deepOrange,
              //     textStyle: TextStyle(
              //       fontSize: 30.0,
              //       fontWeight: FontWeight.bold,
              //     ),
              //     boxHeight: 170.0,
              //   ),
              // ),
              Visibility(
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: viewVisible,
                  child: ButtonBar(
                      children: [
                        Container(
                          width: 420,
                          padding: EdgeInsets.all(4),
                          margin: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              new BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Table(
                              columnWidths: {
                                0: FlexColumnWidth(3),
                                1: FlexColumnWidth(4),
                              },
                              border: TableBorder.symmetric(
                                inside: BorderSide(width: 0.5),
                              ),
                              children: [
                                TableRow(children: [
                                  Container(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "Policy Holder Name",
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "${map["Name"]}",
                                      style: TextStyle(fontSize: 15.0),
                                    ),
                                  ),
                                ]),
                                TableRow(children: [
                                  Container(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "Age",
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "${map["Age"]}",
                                      style: TextStyle(fontSize: 15.0),
                                    ),
                                  ),
                                ]),
                                TableRow(children: [
                                  Container(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "Email",
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "${map["Email"]}",
                                      style: TextStyle(fontSize: 15.0),
                                    ),
                                  ),
                                ]),
                                TableRow(children: [
                                  Container(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "Phone",
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "${map["phone"]}",
                                      style: TextStyle(fontSize: 15.0),
                                    ),
                                  ),
                                ]),
                                TableRow(children: [
                                  Container(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "Policy Number",
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "${map["policyNumber"]}",
                                      style: TextStyle(fontSize: 15.0),
                                    ),
                                  ),
                                ]),
                                TableRow(children: [
                                  Container(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "Vechile Model",
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "${map["vechileModel"]}",
                                      style: TextStyle(fontSize: 15.0),
                                    ),
                                  ),
                                ]),
                                TableRow(children: [
                                  Container(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "Damage",
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "$StatusMsg",
                                      style: TextStyle(fontSize: 15.0),
                                    ),
                                  ),
                                ]),
                                TableRow(children: [
                                  Container(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "Sum Assured",
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "${map["sumAssured"]}",
                                      style: TextStyle(fontSize: 15.0),
                                    ),
                                  ),
                                ]),
                                TableRow(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        "Estimated Amount",
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        "${this.estimation1.toString()}",
                                        style: TextStyle(fontSize: 15.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // child: Text(
                          //     "Hello! I am in the container widget decoration box!!",
                          //     style: TextStyle(fontSize: 30)),
                          // child: Column(

                          //   children: [
                          //     Text("Policy Holder Name - ${map["Name"]}",
                          //         style: TextStyle(
                          //             fontSize: 20,
                          //             fontWeight: FontWeight.bold)),
                          //     Text("Age - ${map["Age"]}",
                          //         style: TextStyle(
                          //             fontSize: 20,
                          //             fontWeight: FontWeight.bold)),
                          //     Text("Email - ${map["Email"]}",
                          //         style: TextStyle(
                          //             fontSize: 20,
                          //             fontWeight: FontWeight.bold)),
                          //     Text("Phone - ${map["phone"]}",
                          //         style: TextStyle(
                          //             fontSize: 20,
                          //             fontWeight: FontWeight.bold)),
                          //     Text("Policy Number - ${map["policyNumber"]}",
                          //         style: TextStyle(
                          //             fontSize: 20,
                          //             fontWeight: FontWeight.bold)),
                          //     Text("Vechile Model - ${map["vechileModel"]}",
                          //         style: TextStyle(
                          //             fontSize: 20,
                          //             fontWeight: FontWeight.bold)),
                          //     Text("Damage - $StatusMsg",
                          //         style: TextStyle(
                          //             fontSize: 20,
                          //             fontWeight: FontWeight.bold)),
                          //     Text("Sum Assured - ${map["sumAssured"]}",
                          //         style: TextStyle(
                          //             fontSize: 20,
                          //             fontWeight: FontWeight.bold)),
                          //     Text(
                          //         "Estimated Amount - ${this.estimation1.toString()}",
                          //         style: TextStyle(
                          //             fontSize: 20,
                          //             fontWeight: FontWeight.bold)),
                          //   ],
                          // ),
                        ),
                        // ignore: deprecated_member_use
                        Container(
                          margin: const EdgeInsets.all(8.0),
                          width: 230,

                          // ignore: deprecated_member_use
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            onPressed: () async {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => SubmitClaim(_image)),
                              // );
                              await uploadFile();
                              await createRecord();
                              if (claimNotify) {
                                // ignore: deprecated_member_use
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      "$claimValue submitted successfully"),
                                  backgroundColor: Colors.orange,
                                ));
                              }
                              await Future.delayed(Duration(seconds: 3));
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BottomNavBar()),
                                  (Route<dynamic> route) => false);
                            },
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    'Click here to submit',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                      alignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min)),
            ],
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 5), child: Text("Estimating")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  handle(String value) async {
    rest = value;
    var da = jsonDecode(value)['estimate'];
    Map<String, dynamic> map = new Map.from(da);
    double d1 = map['02-moderate'];
    double d2 = map['03-severe'];
    double d3 = map['01-minor'];
    List l1 = [d1, d2, d3];
    l1.sort();
    MapEntry entry = map.entries
        .firstWhere((element) => element.value == l1.last, orElse: () => null);

    if (entry != null) {
      print('key = ${entry.key}');
      print('value = ${entry.value}');
      key = entry.key;
    }

    Map<String, dynamic> result = await getData(vehcileNo);
    double estimation = await calculateEstimation(
        result["vechileModel"].toString(), result["sumAssured"], key);
    print("daaaaaaaaaaattttttttttttttaaaaaaaaaa");
    print(estimation);

    if (key == '02-moderate')
      StatusMsg = "Damage is Moderate.";
    else if (key == '03-severe')
      StatusMsg = "Damage is Severe. ";
    else
      StatusMsg = "Damage is Minor.";

    setState(() {
      StatusMsg = StatusMsg;
      print("estimation1 $estimation1");
      estimation1 = estimation;
      print("estimation1 $estimation1");
      viewVisible = true;
    });
    //print(l1);

    // List<dynamic> data = map["02-moderate"];
    // print(data);
    // {"estimate":{"02-moderate":0.3000364,"03-severe":0.003810584,"01-minor":0.69615304}}

    print("over");
    Navigator.of(context, rootNavigator: true).pop('dialog');
  }

  Future<String> callService(pickedFile) async {
    print("picked file path" + (pickedFile));
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ddc4386a-a61d-4358-9549-96f73f22ca2c'
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://a.azure-eu-west.platform.peltarion.com/deployment/f8fe8b2a-3cd8-4ef1-96a9-f67c0733c4e2/forward'));

    request.files.add(await http.MultipartFile.fromPath('data', pickedFile));
    request.headers.addAll(headers);
    print(request);
    http.StreamedResponse response = await request.send();
    print(response.statusCode);
    // if (response.statusCode == 200) {
    // } else {
    //   print("out------------");
    //   print(response.reasonPhrase);
    //   return response.reasonPhrase;
    // }

    switch (response.statusCode) {
      case 200:
        print("in----------------");
        return response.stream.bytesToString();
      //print(response.stream.bytesToString().toString());
      case 400:
        hadleException(response.reasonPhrase.toString());
        throw BadRequestException(response.reasonPhrase.toString());
      case 401:
      case 403:
        hadleException(response.reasonPhrase.toString());
        throw UnauthorisedException(response.reasonPhrase.toString());
      case 500:
        hadleException(response.reasonPhrase.toString());
        throw InternalServerException(response.reasonPhrase.toString());
      default:
        hadleException(response.reasonPhrase.toString());
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getData(String vechile) async {
    await Firebase.initializeApp();
    await FirebaseFirestore.instance
        .collection('policy')
        .doc(vechile)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
        map.addAll(documentSnapshot.data());
        print(map.values);
      } else {
        print('Document does not exist on the database');
        map.addAll(documentSnapshot.data());
      }
    });
    return map;
  }

  Future<double> calculateEstimation(result, result2, result3) async {
    double resultData;
    if (result == "Maruthi") {
      if (result3 == '02-moderate')
        resultData = (40 * result2) / 100;
      else if (result3 == '03-severe')
        resultData = (100 * result2) / 100;
      else
        resultData = (10 * result2) / 100;
    } else if (result == "Audi") {
      if (result3 == '02-moderate')
        resultData = (70 * result2) / 100;
      else if (result3 == '03-severe')
        resultData = (100 * result2) / 100;
      else
        resultData = (30 * result2) / 100;
    }
    print("result data $resultData");
    return resultData;
  }

  Future<void> createRecord() async {
    QuerySnapshot qSnap =
        await FirebaseFirestore.instance.collection('claims').get();
    int documents = qSnap.docs.length;
    documents = documents + 1;
    claimValue = "CLAIM" + documents.toString();

    print("calim count $claimValue");
    await FirebaseFirestore.instance.collection("claims").doc(claimValue).set({
      'PolicyHolderName': map["Name"],
      'Age': map["Age"],
      'Email': map["Email"],
      'phone': map["phone"],
      'policyNumber': map["policyNumber"],
      'vechileModel': map["vechileModel"],
      'statusMsg': StatusMsg,
      'sumAssured': map["sumAssured"],
      'estimation': estimation1.toString(),
      'damagedCarImage': imageUrl,
    });
    setState(() {
      claimNotify = true;
    });
  }

  void hadleException(String string) {
    Navigator.of(context, rootNavigator: true).pop('dialog');
    // ignore: deprecated_member_use
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("$string"),
      backgroundColor: Colors.orange,
    ));
  }

  Future uploadFile() async {
    final _firebaseStorage = FirebaseStorage.instance;
    // PickedFile image;
    //String imageUrl;

    if (_image != null) {
      //Upload to Firebase
      final storageRef = FirebaseStorage.instance.ref().child('images');
      await storageRef.listAll().then((value) => {
            storageSize = value.items.length,
          });
      storageSize = storageSize + 1;
      imgValue = "IMG" + storageSize.toString();

      var snapshot = await _firebaseStorage
          .ref()
          .child('images/$imgValue')
          .putFile(_image)
          .whenComplete(() => print("upload done"));
      var downloadUrl = await snapshot.ref.getDownloadURL();
      print("Dowload url $downloadUrl");
      setState(() {
        imageUrl = downloadUrl;
      });
    } else {
      print('No Image Path Received');
    }
  }
}
//   FirebaseFirestore.instance
//       .collection('policy')
//       .doc(vechile)
//       .snapshots()
//       .listen((event) {
//     setState(() {
//       map = event.get("sumAssured");
//       print(map);
//       StatusMsg = map.toString();
//     });
//   });
// }
