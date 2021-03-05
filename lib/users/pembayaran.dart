import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PembayaranPage extends StatefulWidget {
  @override
  _PembayaranPageState createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {

  String prefUid;
  // CollectionReference tagihan;
  // CollectionReference riwayat;
  @override
  void initState() {
    super.initState();
    _getIud();

    // tagihan = FirebaseFirestore.instance.collection('TagihanPem');
    // riwayat = FirebaseFirestore.instance.collection('RiwayatPem');
  }

  Stream<QuerySnapshot> provideActivityStreamTagihan() async* {
    yield* FirebaseFirestore.instance
        .collection("TagihanPem")
        .doc(prefUid)
        .collection('tagihan')
        .snapshots();
  }

  Stream<QuerySnapshot> provideActivityStreamRiwayat() async* {
    yield* FirebaseFirestore.instance
        .collection("RiwayatPem")
        .doc(prefUid)
        .collection('riwayat')
        .snapshots();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: provideActivityStreamTagihan(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshotTagihan) {
          if (snapshotTagihan.hasError) {
            return Text('Something went wrong');
          }
          if (snapshotTagihan.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
            final dataTagihan = snapshotTagihan.data.docs;

            return StreamBuilder<QuerySnapshot>(
                stream: provideActivityStreamRiwayat(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshotRiwayat) {
                  if (snapshotRiwayat.hasError) {
                    return Text('Something went wrong');
                  }
                  if (snapshotRiwayat.connectionState == ConnectionState.waiting) {
                    return Scaffold(
                      appBar: AppBar(
                        backgroundColor: Colors.green,
                      ),
                      body: Center(
                        child: Text("Loading..."),
                      ),
                    );
                  }
                  final dataRiwayat = snapshotRiwayat.data.docs;

                  return Scaffold(
                    appBar: AppBar(
                      title: Text('Pembayaran'),
                      backgroundColor: Colors.green,
                    ),
                    body: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tagihan Pembayaran',
                              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10.0),
                            Container(
                                child: ListView.builder(
                                  shrinkWrap: true, // Use  children total size
                                  itemBuilder: (context, index) {
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                          side:
                                          BorderSide(width: 2.5, color: Colors.black)),
                                      child: Column(children: <Widget>[
                                        ListTile(
                                          title: Text(dataTagihan[index]['nama_paket']),
                                          subtitle: Text(
                                              'Kekurangan : ${dataTagihan[index]['kekurangan']}'),
                                        )
                                      ]),
                                    );
                                  },
                                  itemCount: dataTagihan.length,
                                )
                            ),
                            Text(
                              "Riwayat Pembayaran",
                              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10.0),
                            Container(
                              child: ListView.builder(
                                shrinkWrap: true, // Use  children total size
                                itemBuilder: (context, index) {
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                        side:
                                        BorderSide(width: 2.5, color: Colors.black)),
                                    child: Column(children: <Widget>[
                                      ListTile(
                                        title: Text('Tanggal Pembayaran : ${dataRiwayat[index]['tanggal_pembayaran']}'),
                                        subtitle: Text(
                                            'Membayar : ${dataRiwayat[index]['membayar']}'),
                                      )
                                    ]),
                                  );
                                },
                                itemCount: dataRiwayat.length,

                              ),
                            )],
                        ),
                      ),
                    ),
                  );
                });

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green,
            ),
            body: Center(
              child: Text("Loading..."),
            ),
          );
        }
        );
  }


  _getIud() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefUid = prefs.getString('uid');
  }
}
