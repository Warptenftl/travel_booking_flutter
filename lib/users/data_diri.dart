import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:toast/toast.dart';


class DataDiriPage extends StatefulWidget {

  @override
  _DataDiriPageState createState() => _DataDiriPageState();
}

class _DataDiriPageState extends State<DataDiriPage> {
  TextEditingController controllerNama = TextEditingController();
  TextEditingController controllerAlamat = TextEditingController();
  TextEditingController controllerTanggalLahir = TextEditingController();
  TextEditingController controllerNoHp = TextEditingController();

  DateTime _selectedDate;
  String _dropDownValue;

  String prefUid;
  String prefEmail;
  String downloadURLKtp;
  String downloadURLKK;
  String downloadURLAkte;
  String ktpSuccess = 'import foto ktp';
  String kkSuccess = 'import foto kk';
  String akteSucess = 'import foto Akte/buku nikah';

  List<File> _images = [];
  File _image;
  File _imageKK;
  File _imageAkte;

  TextStyle style = TextStyle(fontFamily: 'Nunito Sans', fontSize: 17.0);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _getIud();
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Diri"),
        backgroundColor: Colors.green,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Nama"),
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
                        validator: (value) =>
                        value.isEmpty ? 'Nama cannot be empty' : null,
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
                      Text("Alamat"),
                      TextFormField(
                        controller: controllerAlamat,
                        obscureText: false,
                        style: style,
                        decoration: InputDecoration(
                          contentPadding:
                          EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                        ),
                        validator: (value) =>
                        value.isEmpty ? 'Alamat cannot be empty' : null,
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
                      Text("Tanggal Lahir"),
                      TextFormField(
                        focusNode: AlwaysDisabledFocusNode(),
                        controller: controllerTanggalLahir,
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
                        value.isEmpty ? 'Tanggal Lahir cannot be empty' : null,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                  padding: EdgeInsets.only(
                      top: 1.0, bottom: 1.0, left: 10.0, right: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButton(
                        hint: _dropDownValue == null
                            ? Text('Jenis Kelamin')
                            : Text(
                          _dropDownValue,
                          style: TextStyle(color: Colors.black),
                        ),
                        isExpanded: true,
                        iconSize: 30.0,
                        style: TextStyle(color: Colors.black),
                        items: ['Laki - Laki', 'Perempuan'].map(
                              (val) {
                            return DropdownMenuItem<String>(
                              value: val,
                              child: Text(val),
                            );
                          },
                        ).toList(),
                        onChanged: (val) {
                          setState(
                                () {
                              _dropDownValue = val;
                            },
                          );
                        },
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
                      Text("No Hp"),
                      TextFormField(
                        controller: controllerNoHp,
                        obscureText: false,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        // Only numbers can be entered
                        style: style,
                        decoration: InputDecoration(
                          contentPadding:
                          EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                        ),
                        validator: (value) =>
                        value.isEmpty ? 'No Hp cannot be empty' : null,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    _showPicker(context, "1");
                  },
                  child: Container(
                    child: Text(ktpSuccess),
                  ),
                ),
                SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    _showPickerKK(context, "2");
                  },
                  child: Container(
                    child: Text(kkSuccess),
                  ),
                ),
                SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    _showPickerAkte(context, "3");
                  },
                  child: Container(
                    child: Text(akteSucess),
                  ),
                ),
                SizedBox(height: 30.0),
                RaisedButton(
                  onPressed: () {
                    final FormState form = _formKey.currentState;
                    if (form.validate()) {
                      if (prefUid != null) {
                        updateUserData();
                      } else {
                        Toast.show("Silahkan login dahulu", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      }
                    } else {
                      Toast.show("Form is invalid", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    }
                  },
                  child: Text("Simpan", style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.green,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPickerKK(context, String kk) {
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
                        _imgFromGallery(kk);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera(kk);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  void _showPickerAkte(context, String akte) {
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
                        _imgFromGallery(akte);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera(akte);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  void _showPicker(context, String ktp) {
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
                        _imgFromGallery(ktp);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera(ktp);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  _imgFromCamera(String no) async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );
    setState(() {
      if (no == "1") {
        _image = image;
        ktpSuccess = 'upload ktp success';
        uploadFile(_image.path);
        showLoaderDialog(context);
      } else if (no == "2") {
        _imageKK = image;
        kkSuccess = 'upload kk success';
        uploadFileKK(_imageKK.path);
        showLoaderDialog(context);
      } else if (no == "3") {
        _imageAkte = image;
        akteSucess = 'upload akte/buku nikah success';
        uploadFileAkte(_imageAkte.path);
        showLoaderDialog(context);
      }
    });
  }

  _imgFromGallery(String no) async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      if (no == "1") {
        _image = image;
        ktpSuccess = 'upload ktp success';
        uploadFile(_image.path);
        showLoaderDialog(context);
      } else if (no == "2") {
        _imageKK = image;
        kkSuccess = 'upload kk success';
        uploadFileKK(_imageKK.path);
        showLoaderDialog(context);
      } else if (no == "3") {
        _imageAkte = image;
        akteSucess = 'upload akte/buku nikah success';
        uploadFileAkte(_imageAkte.path);
        showLoaderDialog(context);
      }
    });
  }

  Future<void> uploadFile(String filePath) async {
    File file = File(filePath);
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('uploads/${_image.path
          .split('/')
          .last}')
          .putFile(file);
      downloadURLKtp = await firebase_storage.FirebaseStorage.instance
          .ref('uploads/${_image.path
          .split('/')
          .last}')
          .getDownloadURL();
      Navigator.pop(context);
    } on firebase_storage.FirebaseException {
      // e.g, e.code == 'canceled'
    }
  }

  Future<void> uploadFileKK(String filePath) async {
    File file = File(filePath);

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('uploads/${_imageKK.path
          .split('/')
          .last}')
          .putFile(file);
      downloadURLKK = await firebase_storage.FirebaseStorage.instance
          .ref('uploads/${_imageKK.path
          .split('/')
          .last}')
          .getDownloadURL();
      Navigator.pop(context);
    } on firebase_storage.FirebaseException {
      // e.g, e.code == 'canceled'
    }
  }

  Future<void> uploadFileAkte(String filePath) async {
    File file = File(filePath);
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('uploads/${_imageAkte.path
          .split('/')
          .last}')
          .putFile(file);
      downloadURLAkte = await firebase_storage.FirebaseStorage.instance
          .ref('uploads/${_imageAkte.path
          .split('/')
          .last}')
          .getDownloadURL();
      Navigator.pop(context);
    } on firebase_storage.FirebaseException {
      // e.g, e.code == 'canceled'
    }
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
      controllerTanggalLahir
        ..text = DateFormat.yMMMd().format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: controllerTanggalLahir.text.length,
            affinity: TextAffinity.upstream));
    }
  }

  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  Future<void> updateUserData() {
    showLoaderDialog(context);
    // Call the user's CollectionReference to add a new user
    return users
        .doc(prefUid)
        .set({
      'nama': controllerNama.text.toString(),
      'email': prefEmail,
      'alamat': controllerAlamat.text.toString(), // Stokes and Sons
      'tanggal_lahir': controllerTanggalLahir.text.toString(),
      'no_hp': controllerNoHp.text.toString(),
      'jenis_kelamin': _dropDownValue,
      'foto_akte_atau_buku_nikah': downloadURLKtp,
      'foto_kk': downloadURLKK,
      'foto_ktp': downloadURLAkte,
    })
        .then((value) => {
    ktpSuccess = 'import foto ktp',
    kkSuccess = 'import foto kk',
    akteSucess = 'import foto Akte/buku nikah',

    Navigator.of(context).pushNamed("/Home"),
    Toast.show ("add data success", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM),
    Navigator.pop(context),


    }).catchError((error) => {
      Navigator.pop(context),
      print("Failed to add user: $error")});
  }

  _getIud() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefUid = prefs.getString('uid');
    prefEmail = prefs.getString('email');
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
