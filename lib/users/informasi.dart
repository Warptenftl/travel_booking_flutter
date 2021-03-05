import 'package:flutter/material.dart';

class InformasiPage extends StatefulWidget {
  @override
  _InformasiPageState createState() => _InformasiPageState();
}

class _InformasiPageState extends State<InformasiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
      ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            child: Column(
            children: [
              Container(
                  width: 200.0,
                  height: 200.0,
                  child: Image.asset('assets/image/logodaniatravel.jpeg')),
                GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/InfoUmroh");
                },
                child: Container(
                  width: 100.0,
                  height: 100.0,
                  margin: EdgeInsets.only(left: 40.0, right: 40.0, top: 30.0, bottom: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.airplanemode_active, size: 80.0, color: Colors.white),
                      Text("Info Umroh")
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/DataDiri");
                },
                child: Container(
                  width: 100.0,
                  height: 100.0,
                  margin: EdgeInsets.only(left: 40.0, right: 40.0, bottom: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.assignment, size: 80.0, color: Colors.white),
                      Text("Data Diri")
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/Pembayaran");
                },
                child: Container(
                  width: 100.0,
                  height: 100.0,
                  margin: EdgeInsets.only(left: 40.0, right: 40.0, bottom: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.payment, size: 80.0, color: Colors.white),
                      Text("Pembayaran")
                    ],
                  ),
                ),
              ),
            ]),
    ),
        ));
  }
}
