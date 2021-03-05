import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class InputPembayaran extends StatefulWidget {
  final String user_id;

  const InputPembayaran({Key key, @required this.user_id}) : super(key: key);

  @override
  _InputPembayaranState createState() => _InputPembayaranState();
}

class _InputPembayaranState extends State<InputPembayaran> {
  TextEditingController controllerMembayar = TextEditingController();
  TextEditingController controllerTanggal = TextEditingController();

  TextStyle style = TextStyle(fontFamily: 'Nunito Sans', fontSize: 17.0);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Pembayaran'),
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
                TextFormField(
                    controller: controllerMembayar,
                    obscureText: false,
                    style: style,
                    decoration: InputDecoration(
                      labelText: 'Membayar',
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
                  focusNode: AlwaysDisabledFocusNode(),
                  controller: controllerTanggal,
                  obscureText: false,
                  style: style,
                  decoration: InputDecoration(
                    labelText: 'Tanggal',
                    contentPadding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                  ),
                  onTap: () {
                    _selectDate(context);
                  },
                  validator: (value) =>
                      value.isEmpty ? 'Tanggal cannot be empty' : null,
                ),
                SizedBox(height: 25.0),
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        addPembayaran();
                      }
                    },
                    textColor: Color(0xffFFFFFF),
                    color: Colors.green,
                    padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
                    child: Text("Tambahkan"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  CollectionReference pemb =
      FirebaseFirestore.instance.collection('RiwayatPem');

  Future<void> addPembayaran() async {
    return pemb
        .doc(widget.user_id)
        .collection('riwayat')
        .add({
          'membayar': controllerMembayar.text.toString(),
          'tanggal_pembayaran': controllerTanggal.text.toString(),
        })
        .then((value) => {
              Navigator.pop(context),
              Toast.show("add Success.", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM),
            })
        .catchError((error) => {print("Failed to add : $error")});
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
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
