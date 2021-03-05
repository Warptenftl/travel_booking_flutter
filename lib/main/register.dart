import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController controllerNama = TextEditingController();
  TextEditingController controllerAlamat = TextEditingController();
  TextEditingController controllerTanggalLahir = TextEditingController();
  TextEditingController controllerNoHp = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  DateTime _selectedDate;
  String _dropDownValue;

  TextStyle style = TextStyle(fontFamily: 'Nunito Sans', fontSize: 17.0);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isHidePassword = true;

  String prefUid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
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
                        validator: (value) => value.isEmpty
                            ? 'Tanggal Lahir cannot be empty'
                            : null,
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
                SizedBox(height: 10.0),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Email"),
                      TextFormField(
                          controller: controllerEmail,
                          obscureText: false,
                          style: style,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                          ),
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "Please enter some text";
                            }
                            return null;
                          }),
                    ],
                  ),
                ),
                SizedBox(height: 25.0),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Password"),
                      TextFormField(
                          controller: controllerPassword,
                          obscureText: _isHidePassword,
                          autofocus: false,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0)),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  _togglePasswordVisibility();
                                },
                                child: Icon(
                                    _isHidePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: _isHidePassword
                                        ? Colors.grey
                                        : Color(0xFF10586E)),
                              ),
                              isDense: true),
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "Please enter some text";
                            }
                            return null;
                          }),
                    ],
                  ),
                ),
                SizedBox(height: 30.0),
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    onPressed: () {
                      final FormState form = _formKey.currentState;
                      if (form.validate()) {
                        showLoaderDialog(context);
                        _signInWithEmailAndPassword();
                      } else {
                        Toast.show("Form is invalid", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      }
                    },
                    child: Text(
                      "Simpan",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.green,
                    padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
                  ),
                ),
                SizedBox(height: 30.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signInWithEmailAndPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      UserCredential userCredential = ((await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: controllerEmail.text, password: controllerPassword.text)));
      print(userCredential.user);
      if (userCredential.user != null) {
        prefs.setString('uid', userCredential.user.uid);
        prefs.setString('email', userCredential.user.email);
        prefUid = userCredential.user.uid;

        Toast.show("register success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        updateUserData();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        Toast.show("No user found for that email.", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.pop(context);
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        Toast.show("Wrong password provided for that user.", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.pop(context);
      }
    }
  }

  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  Future<void> updateUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return users
        .doc(prefUid)
        .set({
          'nama': controllerNama.text.toString(),
          'email': controllerEmail.text.toString(),
          'alamat': controllerAlamat.text.toString(),
          'tanggal_lahir': controllerTanggalLahir.text.toString(),
          'no_hp': controllerNoHp.text.toString(),
          'jenis_kelamin': _dropDownValue,
          'foto_akte_atau_buku_nikah': '',
          'foto_kk': '',
          'foto_ktp': '',
          'role': 'user',
        })
        .then((value) => {
              prefs.setString('login', 'login'),
              prefs.setString('role', 'user'),
              Navigator.pop(context),
              Navigator.of(context).pushNamed("/Home"),
            })
        .catchError((error) => {
      Navigator.pop(context),
      print("Failed to add user: $error")});
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

  void _togglePasswordVisibility() {
    setState(() {
      _isHidePassword = !_isHidePassword;
    });
  }

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    controllerNama.dispose();
    controllerAlamat.dispose();
    controllerTanggalLahir.dispose();
    controllerNoHp.dispose();
    super.dispose();
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
