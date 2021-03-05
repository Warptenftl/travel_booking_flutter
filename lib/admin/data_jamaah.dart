import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

class DataJamaah extends StatefulWidget {
  @override
  _DataJamaahState createState() => _DataJamaahState();
}

class _DataJamaahState extends State<DataJamaah> {
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
                      Navigator.pushNamed(context, '/DetailJamaah',
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

class DetailJamaah extends StatefulWidget {
  final String data;

  const DetailJamaah({Key key, @required this.data}) : super(key: key);

  @override
  _DetailJamaahState createState() => _DetailJamaahState();
}

class _DetailJamaahState extends State<DetailJamaah> {
  Stream<QuerySnapshot> provideActivityStream() async* {
    yield* FirebaseFirestore.instance
        .collection("DataJamaah")
        .doc(widget.data)
        .collection("data")
        .snapshots();
  }

  List<Map<String, dynamic>> listdata;

  Future<void> getP() async {
    var firestore = FirebaseFirestore.instance;
    var q = await firestore
        .collection('DataJamaah')
        .doc(widget.data)
        .collection('data')
        .get();
    List<Map<String, dynamic>> list = q.docs.map((DocumentSnapshot e) {
      return e.data();
    }).toList();

    listdata = list;
    print('ini data nya : $list');
    return q.docs;
  }

  final pdf = pw.Document();

  List<QueryDocumentSnapshot> dataList;

  _writeOnPdf() {
    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Header(level: 0, child: pw.Text("Data Jamaah")),
            pw.Container(
                child: pw.ListView.builder(
                    itemBuilder: (context, index) {
                      return pw.Container(
                        margin: pw.EdgeInsets.all(20.0),
                          child: pw.Column(
                              children: [
                            pw.Text("Nama : ${listdata[index]['nama']}"),
                            pw.Text("Alamat : ${listdata[index]['alamat']}"),
                            pw.Text("Paket : ${listdata[index]['nama_paket']}")
                          ]));
                    },
                    itemCount: dataList.length))
          ];
        }));
  }

  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String formatted = formatter.format(now);

  Future savePdf() async {
    Directory documentDirectory = await getExternalStorageDirectory();

    String documentPath = documentDirectory.path;

    File file = File("$documentPath/$formatted.pdf");

    file.writeAsBytesSync(await pdf.save());

    print(file);
  }

  void requestPersmission() async {
    await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  }


  @override
  void initState() {
    requestPersmission();
    getP();
    super.initState();
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
          dataList = snapshot.data.docs;

          final data = snapshot.data.docs;
          return Scaffold(
            appBar: AppBar(
              title: Text("Data Jamaah"),
              backgroundColor: Colors.green,
            ),
            body: ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(width: 2.5, color: Colors.black)),
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Nama : ${data[index].data()['nama']}"),
                          Text("Alamat : ${data[index].data()['alamat']}"),
                          Text("Paket : ${data[index].data()['nama_paket']}"),
                        ]),
                  ),
                );
              },
              itemCount: data.length,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                _writeOnPdf();
                await savePdf();

                Directory documentDirectory =
                    await getApplicationDocumentsDirectory();

                String documentPath = documentDirectory.path;

                String fullPath = "$documentPath/$formatted.pdf";

                Navigator.pushNamed(context, '/PDFPreview', arguments: fullPath)
                    .then((value) => {print(value)});
              },
              child: Icon(Icons.save),
            ),
          );
        });
  }
}
