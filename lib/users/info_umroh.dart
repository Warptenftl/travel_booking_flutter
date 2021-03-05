import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InfoUmrohPage extends StatefulWidget {
  @override
  _InfoUmrohPageState createState() => _InfoUmrohPageState();
}

class _InfoUmrohPageState extends State<InfoUmrohPage> {
  String prefUid;

  @override
  void initState() {
    super.initState();
    _getIud();
  }

  Stream<QuerySnapshot> provideActivityStream() async* {
    yield* FirebaseFirestore.instance
        .collection("InfoUmroh")
        .doc(prefUid)
        .collection('info')
        .snapshots();
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
          final dataInfo = snapshot.data.docs;

          return Scaffold(
              appBar: AppBar(
                title: Text("Info Umroh"),
                backgroundColor: Colors.green,
              ),
              body: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          height: 200.0,
                          width: 200.0,
                          child:
                              Image.asset('assets/image/logodaniatravel.jpeg')),
                      Container(
                        padding: EdgeInsets.all(20.0),
                        width: double.infinity,
                        child: Text(
                          'Paket yang di pilih',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        color: Colors.green,
                      ),
                      SizedBox(height: 5.0),
                      Container(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index){
                            return Card(
                              child: Container(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.airplanemode_active),
                                        Text(dataInfo[index]['nama_paket']),
                                      ],
                                    ),
                                    SizedBox(height: 5.0),
                                    Row(
                                      children: [
                                        Icon(Icons.date_range),
                                        Text(dataInfo[index]['tanggal']),
                                      ],
                                    ),
                                    SizedBox(height: 5.0),
                                    Text(dataInfo[index]['price']),
                                    SizedBox(height: 5.0),
                                    Text('Info : ${dataInfo[index]['info']}')
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: dataInfo.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ));
        });
  }

  _getIud() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefUid = prefs.getString('uid');
  }
}
