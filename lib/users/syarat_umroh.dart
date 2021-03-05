import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SyaratUmrohPage extends StatefulWidget {
  @override
  _SyaratUmrohPageState createState() => _SyaratUmrohPageState();
}

class _SyaratUmrohPageState extends State<SyaratUmrohPage> {
  CollectionReference paketUmroh =
      FirebaseFirestore.instance.collection('syaratUmroh');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: paketUmroh.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          return Scaffold(
            appBar: AppBar(
              title: Text("Syarat Umroh"),
              backgroundColor: Colors.green,
            ),
            body: SingleChildScrollView(
              child: Container(
                child: new Column(
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    return Container(
                        child: Column(
                          children: [
                            Image.asset('assets/image/logodaniatravel.jpeg'),
                            Container(
                              margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                                child: Text(document.data()['description']))
                          ],
                        ),
                    );
                }).toList()
          ),
              ),
            )
          );
        });
  }
}
