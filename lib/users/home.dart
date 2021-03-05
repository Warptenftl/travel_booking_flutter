import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String prefUid;
  bool visible = false;

  @override
  void initState() {
    _getIud();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () =>
          SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
      child: Scaffold(
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
                      onTap: (){
                        Navigator.pushNamed(context, "/PaketUmroh");

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
                            Icon(Icons.airplanemode_active, size: 80.0, color: Colors.white,),
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
                            context, '/Login', (route) => false);                      },
                      child: Container(
                        width: 100.0,
                        height: 100.0,
                        margin: EdgeInsets.only(left: 40.0, right: 40.0, bottom: 5.0),
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
                      onTap: (){
                        Navigator.pushNamed(context, "/Informasi");

                      },
                      child: Container(
                        width: 100.0,
                        height: 100.0,
                        margin: EdgeInsets.only(left: 40.0, right: 40.0, top :5.0,bottom: 5.0),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.info, size: 80.0, color: Colors.white),
                            Text("Informasi")
                          ],
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: (){
                        // Navigator.pushNamed(context, "/Pesan");
                       openBrowserTab();
                      },
                      child:  Container(
                        width: 100.0,
                        height: 100.0,
                        margin: EdgeInsets.only(left: 40.0, right: 40.0, top :5.0,bottom: 5.0),
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
                      onTap: (){
                        Navigator.pushNamed(context, "/Tentang");
                      },
                      child:  Container(
                        width: 100.0,
                        height: 100.0,
                        margin: EdgeInsets.only(left: 40.0, right: 40.0, top :5.0,bottom: 5.0),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.info_outline, size: 80.0, color: Colors.white),
                            Text("Tentang")
                          ],
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, "/SyaratUmroh");
                      },
                      child: Container(
                        width: 100.0,
                        height: 100.0,
                        margin: EdgeInsets.only(left: 40.0, right: 40.0, top :5.0,bottom: 5.0),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.assignment, size: 80.0, color: Colors.white),
                            Text("Syarat Umroh")
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
    await FlutterWebBrowser.openWebPage(url: "https://wa.me/62895410340277/", androidToolbarColor: Colors.green);
  }

}