import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class PaketUmroh extends StatefulWidget {
  @override
  _PaketUmrohState createState() => _PaketUmrohState();
}

class _PaketUmrohState extends State<PaketUmroh> {
  // final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String role;

  Stream<QuerySnapshot> provideActivityStream() async* {
    yield* FirebaseFirestore.instance.collection("paketUmroh").snapshots();
  }

  @override
  void initState() {
    super.initState();

    _getRole();
  }

  @override
  Widget build(BuildContext context) {
    // CollectionReference paketUmroh =
    //     FirebaseFirestore.instance.collection('paketUmroh');

    return StreamBuilder<QuerySnapshot>(
        stream: provideActivityStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          final data = snapshot.data.docs;

          if (role == 'admin') {
            return Scaffold(
              appBar: AppBar(
                title: Text("Paket Umroh"),
                backgroundColor: Colors.green,
                actions: [
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Navigator.pushNamed(context, '/AddPaket');
                    },
                  )
                ],
              ),
              body: ListView.builder(
                itemBuilder: (context, index) {
                  return Container(
                    child: GestureDetector(
                      onTap: () {
                        // Navigator.pushNamed(context, '/EditPaket',
                        //     arguments: data[index].id)
                        //     .then((value) => {print(value)});
                      },
                      child: Card(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SizedBox(
                                width: double.infinity,
                                child: Container(
                                    height: 200.0,
                                    child: Image.network(data[index]["image"])),
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 10.0,
                                        top: 10.0,
                                        bottom: 10.0,
                                        right: 20.0),
                                    width: 200.0,
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data[index]['paket_name'],
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(data[index]['paket_price'],
                                            style: TextStyle(fontSize: 18.0))
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showAlertDialog(context, data[index].id);
                                    },
                                    child: Container(
                                        padding: EdgeInsets.only(left: 90.0),
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                          size: 40.0,
                                        )),
                                  )
                                ],
                              ),
                            ]),
                      ),
                    ),
                  );
                },
                itemCount: data.length,
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text("Paket Umroh"),
                backgroundColor: Colors.green,
              ),
              body: ListView.builder(
                itemBuilder: (context, index) {
                  return Container(
                    child: GestureDetector(
                      onTap: () async {
                        SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                        preferences.setString(
                            'paket', data[index]['paket_name']);
                        preferences.setString(
                            'price', data[index]['paket_price']);
                        preferences.setString('date', data[index]['date']);
                        preferences.setString(
                            'information', data[index]['information']);
                        Navigator.pushNamed(context, '/DataDiriPaket',
                            arguments: data[index].id)
                            .then((value) => {print(value)});
                      },
                      child: Card(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SizedBox(
                                width: double.infinity,
                                child: Container(
                                    height: 200.0,
                                    child: Image.network(data[index]["image"])),
                              ),
                              ListTile(
                                title: Text(data[index]['paket_name']),
                                subtitle: Text(data[index]['paket_price']),
                              ),
                            ]),
                      ),
                    ),
                  );
                },
                itemCount: data.length,
              ),
            );
          }
        });
  }

  showAlertDialog(BuildContext context, String id) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Kembali"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Hapus"),
      onPressed: () {
        showLoaderDialog(context);
        deletePaket(id);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Hapus Paket"),
      content: Text("Apakah ingin menghapus paket ini?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  CollectionReference paket = FirebaseFirestore.instance.collection(
      'paketUmroh');

  Future<void> deletePaket(String id) {
    return paket
        .doc(id)
        .delete()
        .then((value) => {
    Navigator.pop(context)
    })
        .catchError((error) =>
    {
      Navigator.pop(context),
      print("Failed to delete user: $error")
    });
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
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

  _getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    role = prefs.getString('role');
  }
}
