import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController controllerEmail =
  TextEditingController(text: "test@gmail.com");
  TextEditingController controllerPassword =
  TextEditingController(text: "test123");

  TextStyle style = TextStyle(fontFamily: 'Nunito Sans', fontSize: 17.0);

  bool _isHidePassword = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String prefUid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danial Travel"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: 200.0,
                    width: 200.0,
                    child: Image.asset('assets/image/logodaniatravel.jpeg')),
                SizedBox(height: 50.0),
                TextFormField(
                    controller: controllerEmail,
                    obscureText: false,
                    style: style,
                    decoration: InputDecoration(
                      labelText: 'Email',
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
                SizedBox(height: 25.0),
                TextFormField(
                    controller: controllerPassword,
                    obscureText: _isHidePassword,
                    autofocus: false,
                    decoration: InputDecoration(
                        labelText: 'Password',
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
                SizedBox(height: 20.0),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('/Register');
                    },
                    child: Text("Belum punya akun? Register")),
                SizedBox(height: 25.0),
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        showLoaderDialog(context);
                        _signInWithEmailAndPassword();
                      }
                    },
                    textColor: Color(0xffFFFFFF),
                    color: Colors.green,
                    padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
                    child: Text("Login"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    super.dispose();
  }

  void _signInWithEmailAndPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      UserCredential userCredential = ((await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: controllerEmail.text, password: controllerPassword.text)));
      print(userCredential.user);
      if (userCredential.user != null) {
        prefs.setString('uid', userCredential.user.uid);
        prefs.setString('email', userCredential.user.email);
        prefs.setString('login', 'login');
        prefUid = userCredential.user.uid;
        _getUser();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        Toast.show("No user found for that email.", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        Toast.show("Wrong password provided for that user.", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isHidePassword = !_isHidePassword;
    });
  }

  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FirebaseFirestore.instance
        .collection('Users')
        .doc(prefUid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.data()['role'] == 'user') {
          Navigator.pop(context);
          Navigator.of(context).pushNamed("/Home");
          Toast.show("Login Success.", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          prefs.setString('role', 'user');
          prefs.setString('login', 'login');
        } else {
          Navigator.pop(context);
          Navigator.of(context).pushNamed("/AdminHome");
          Toast.show("Login Admin Success.", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          prefs.setString('role', 'admin');
          prefs.setString('login', 'login');
        }
      } else {
        print('Document does not exist on the database');
        Navigator.pop(context);
      }
    });
  }

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text("Loading..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }
}
