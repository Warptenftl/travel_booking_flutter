import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TentangPage extends StatefulWidget {
  @override
  _TentangPageState createState() => _TentangPageState();
}

class _TentangPageState extends State<TentangPage> {

  CollectionReference syaratUmroh = FirebaseFirestore.instance.collection(
      'tentang');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: syaratUmroh.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          return Scaffold(
              appBar: AppBar(
                title: Text("Tentang Dania"),
                backgroundColor: Colors.green,
              ),
              body: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(20.0),
                  child: new Column(
                      children: snapshot.data.docs.map((DocumentSnapshot document) {
                        return Container(
                          child: Column(
                            children: [
                              Image.asset('assets/image/logodaniatravel.jpeg'),
                              Container(
                                margin: EdgeInsets.only(top: 10.0),
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
