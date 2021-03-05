import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  String prefUid;

  bool visible = false;
  @override
  Widget build(BuildContext context) {
    _getIud();
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(bottom: 100.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 30.0, top: 50.0),
                child: Container(
                  height: 200.0,
                  width: 200.0,
                  child: Image.asset('assets/image/logodaniatravel.jpeg'),
                ),

              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/PaketUmroh");
                    },
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      margin: EdgeInsets.only(
                          left: 40.0, right: 40.0, bottom: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.airplanemode_active, size: 80.0, color: Colors.white),
                          Text("Paket Umroh")
                        ],
                      ),
                    ),
                  ),


                  GestureDetector(
                    onTap: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.clear();
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/Login', (route) => false);                    },
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      margin: EdgeInsets.only(
                          left: 40.0, right: 40.0, bottom: 5.0),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.highlight_off, size: 80.0, color: Colors.white),
                          Text("Log Out")
                        ],
                      ),
                    ),
                  ),

                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/ListEditPaket");
                    },
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      margin: EdgeInsets.only(
                          left: 40.0, right: 40.0, top: 5.0, bottom: 5.0),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.info, size: 80.0, color: Colors.white),
                          Text("Edit Paket")
                        ],
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      // Navigator.pushNamed(context, "/Pesan");
                      openBrowserTab();
                    },
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      margin: EdgeInsets.only(
                          left: 40.0, right: 40.0, top: 5.0, bottom: 5.0),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.chat, size: 80.0, color: Colors.white),
                          Text("Pesan")
                        ],
                      ),
                    ),
                  ),

                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/AdminPembayaran");
                    },
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      margin: EdgeInsets.only(
                          left: 40.0, right: 40.0, top: 5.0, bottom: 5.0),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.credit_card, size: 80.0, color: Colors.white),
                          Text("Pembayaran")
                        ],
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/DataJamaah");
                    },
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      margin: EdgeInsets.only(
                          left: 40.0, right: 40.0, top: 5.0, bottom: 5.0),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.assignment, size: 80.0, color: Colors.white),
                          Text("Data Jamaah")
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getIud() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefUid = prefs.getString('uid');

    if(prefUid != null){
      visible = true;
    }else{
      visible = false;
    }
  }

  openBrowserTab() async {
    await FlutterWebBrowser.openWebPage(
        url: "https://wa.me/6282325865550/", androidToolbarColor: Colors.green);
  }

}
