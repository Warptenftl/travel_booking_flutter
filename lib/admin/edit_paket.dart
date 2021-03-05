import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ListEditPaket extends StatefulWidget {
  @override
  _ListEditPaketState createState() => _ListEditPaketState();
}

class _ListEditPaketState extends State<ListEditPaket> {
  Stream<QuerySnapshot> provideActivityStream() async* {
    yield* FirebaseFirestore.instance.collection("paketUmroh").snapshots();
  }


  @override
  Widget build(BuildContext context) {
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

          return Scaffold(
            appBar: AppBar(
              title: Text("Paket Umroh"),
              backgroundColor: Colors.green,
            ),
            body: ListView.builder(
              itemBuilder: (context, index) {
                return Container(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/EditPaket',
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
        });
  }
}

class AdminEditPaket extends StatefulWidget {
  final String data;

  const AdminEditPaket({Key key, @required this.data}) : super(key: key);

  @override
  _AdminEditPaketState createState() => _AdminEditPaketState();
}

class _AdminEditPaketState extends State<AdminEditPaket> {
  CollectionReference addpaket =
      FirebaseFirestore.instance.collection('paketUmroh');

  TextEditingController controllerNama = TextEditingController();
  TextEditingController controllerPaketPrice = TextEditingController();
  TextEditingController controllerTanggal = TextEditingController();
  TextEditingController controllerInformasiPaket = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextStyle style = TextStyle(fontFamily: 'Nunito Sans', fontSize: 17.0);

  DateTime _selectedDate;
  String donwloadUrl;

  String uploadFoto = "Upload foto";
  File _image;

  String nama_paket;
  String harga;
  String tanggal;
  String informasi;

  @override
  void initState() {
    _getPaketDetail();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Paket'),
          backgroundColor: Colors.green,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.all(20.0),
                child: Column(children: [
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Nama Paket"),
                        TextFormField(
                          controller: controllerNama,
                          obscureText: false,
                          style: style,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                          ),
                          validator: (value) => value.isEmpty
                              ? 'Nama Paket cannot be empty'
                              : null,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Harga Paket"),
                        TextFormField(
                          controller: controllerPaketPrice,
                          obscureText: false,
                          style: style,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                          ),
                          validator: (value) => value.isEmpty
                              ? 'Harga Paket cannot be empty'
                              : null,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Tanggal"),
                        TextFormField(
                          focusNode: AlwaysDisabledFocusNode(),
                          controller: controllerTanggal,
                          obscureText: false,
                          style: style,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                          ),
                          onTap: () {
                            _selectDate(context);
                          },
                          validator: (value) =>
                              value.isEmpty ? 'Tanggal cannot be empty' : null,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Informasi paket"),
                        TextFormField(
                          controller: controllerInformasiPaket,
                          obscureText: false,
                          style: style,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                          ),
                          validator: (value) => value.isEmpty
                              ? 'Informasi Paket cannot be empty'
                              : null,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  RaisedButton(
                    child: Text(
                      uploadFoto,
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.green,
                    onPressed: () {
                      _showPicker(context);
                    },
                  ),
                  RaisedButton(
                    padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
                    child: Text(
                      "Kirim",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.green,
                    onPressed: () async {
                      if (donwloadUrl != null) {
                        showLoaderDialog(context);
                        addpaket
                            .doc(widget.data)
                            .update({
                              'date': controllerTanggal.text.toString(),
                              'image': donwloadUrl,
                              'paket_name': controllerNama,
                              'paket_price': controllerPaketPrice,
                              'information': controllerInformasiPaket
                            })
                            .then((value) => {
                                  Navigator.pop(context),
                                  Toast.show("add Success.", context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.BOTTOM)
                                })
                            .catchError(
                                (error) => print("Failed to add user: $error"));
                      } else {
                        Navigator.pop(context);
                        Toast.show("Form is invalid", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      }
                    },
                  )
                ])),
          ),
        ));
  }



  _getPaketDetail() async {
    return FirebaseFirestore.instance
        .collection('paketUmroh')
        .doc(widget.data)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        nama_paket = documentSnapshot.data()['paket_name'];
        harga = documentSnapshot.data()['paket_price'];
        tanggal = documentSnapshot.data()['date'];
        informasi = documentSnapshot.data()['information'];

        setState(() {
          controllerNama.text = nama_paket;
          controllerPaketPrice.text = harga;
          controllerTanggal.text = tanggal;
          controllerInformasiPaket.text = informasi;
        });
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  @override
  void dispose() {
    controllerNama.dispose();
    controllerPaketPrice.dispose();
    controllerTanggal.dispose();
    controllerInformasiPaket.dispose();
    super.dispose();
  }
  _selectDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2040),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.green[100],
                onPrimary: Colors.white,
                surface: Colors.green[900],
                onSurface: Colors.green[200],
              ),
              dialogBackgroundColor: Colors.green[600],
            ),
            child: child,
          );
        });

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      controllerTanggal
        ..text = DateFormat.yMMMd().format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: controllerTanggal.text.length,
            affinity: TextAffinity.upstream));
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _image = image;
      uploadFile(_image.path);
      uploadFoto = "Upload Success";
      showLoaderDialog(context);
    });
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = image;
      uploadFile(_image.path);
      uploadFoto = "Upload Success";
      showLoaderDialog(context);
    });
  }

  Future<void> uploadFile(String filePath) async {
    File file = File(filePath);

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('uploads/${_image.path.split('/').last}')
          .putFile(file);
      donwloadUrl = await firebase_storage.FirebaseStorage.instance
          .ref('uploads/${_image.path.split('/').last}')
          .getDownloadURL();
      Navigator.pop(context);
    } on firebase_storage.FirebaseException {
      // e.g, e.code == 'canceled'
      uploadFoto = "Upload Failed";
    }
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
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
