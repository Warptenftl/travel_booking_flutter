import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminPembayaran extends StatefulWidget {
  @override
  _AdminPembayaranState createState() => _AdminPembayaranState();
}


class _AdminPembayaranState extends State<AdminPembayaran> {
  String name = "";

  Stream<QuerySnapshot> provideActivityStream() async* {
    // yield* FirebaseFirestore.instance
    //     .collection("Pembayaran")
    //     .snapshots();
    yield* (name != "" && name != null)
        ? FirebaseFirestore.instance
        .collection('Pembayaran')
        .where("nama", isGreaterThanOrEqualTo: name)
        .snapshots()
        : FirebaseFirestore.instance
        .collection("Pembayaran")
        .snapshots();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Pembayaran"),
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                  child: Card(
                    child: TextField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search), hintText: 'Search Name...'),
                      onChanged: (val) {
                        setState(() {
                          name = val;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                StreamBuilder<QuerySnapshot>(
                    stream:provideActivityStream(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading");
                      }
                      final data = snapshot.data.docs;
                      return Container(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: (){
                                Navigator.pushNamed(context, '/InputPembayaran',
                                    arguments: data[index]['id_user'])
                                    .then((value) => {print(value)});
                              },
                              child: Container(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 2.5, color: Colors.black)),
                                  child: Container(
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text('Nama : ${data[index].data()['nama']}'),
                                          Text('Alamat : ${data[index].data()['alamat']}'),
                                          Text('Paket : ${data[index].data()['paket']}')
                                        ]),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),
              ],
            ),
          ),
        ));
  }

}
