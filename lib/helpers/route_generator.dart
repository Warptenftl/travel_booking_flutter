import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_booking_flutter/admin/add_paket.dart';
import 'package:travel_booking_flutter/admin/admin_home.dart';
import 'package:travel_booking_flutter/admin/admin_pembayaran.dart';
import 'package:travel_booking_flutter/admin/data_jamaah.dart';
import 'package:travel_booking_flutter/admin/edit_paket.dart';
import 'package:travel_booking_flutter/admin/input_pembayaran.dart';
import 'package:travel_booking_flutter/admin/pdfPreviewScreen.dart';
import 'package:travel_booking_flutter/all/paket_umroh.dart';
import 'package:travel_booking_flutter/main/login.dart';
import 'package:travel_booking_flutter/main/register.dart';
import 'package:travel_booking_flutter/users/data_diri.dart';
import 'package:travel_booking_flutter/users/data_diri_paket.dart';
import 'package:travel_booking_flutter/users/home.dart';
import 'package:travel_booking_flutter/users/info_umroh.dart';
import 'package:travel_booking_flutter/users/informasi.dart';
import 'package:travel_booking_flutter/users/pembayaran.dart';
import 'package:travel_booking_flutter/users/pesan.dart';
import 'package:travel_booking_flutter/users/syarat_umroh.dart';
import 'package:travel_booking_flutter/users/tentang.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/Home':
        return CupertinoPageRoute(builder: (_) => MyHomePage());
      case '/PaketUmroh':
        return CupertinoPageRoute(builder: (_) => PaketUmroh());
      case '/Login':
        return CupertinoPageRoute(builder: (_) => LoginPage());
      case '/Register':
        return CupertinoPageRoute(builder: (_) => RegisterPage());
      case '/Informasi':
        return CupertinoPageRoute(builder: (_) => InformasiPage());
      case '/Pesan':
        return CupertinoPageRoute(builder: (_) => PesanPage());
      case '/Tentang':
        return CupertinoPageRoute(builder: (_) => TentangPage());
      case '/SyaratUmroh':
        return CupertinoPageRoute(builder: (_) => SyaratUmrohPage());
      case '/DataDiri':
        return CupertinoPageRoute(builder: (_) => DataDiriPage());
      case '/DataDiriPaket':
        if (args != null) {
          return CupertinoPageRoute(
              builder: (_) => DataDiriPaket(
                    data: args,
                    paket: args,
                  ));
        }
        return CupertinoPageRoute(builder: (_) => DataDiriPaket());
      case '/Pembayaran':
        return CupertinoPageRoute(builder: (_) => PembayaranPage());
      case '/AdminHome':
        return CupertinoPageRoute(builder: (_) => AdminHomePage());
      case '/InfoUmroh':
        return CupertinoPageRoute(builder: (_) => InfoUmrohPage());
      case '/AddPaket':
        return CupertinoPageRoute(builder: (_) => AddPaketPage());
      case '/ListEditPaket':
        return CupertinoPageRoute(builder: (_) => ListEditPaket());
      case '/EditPaket':
        if (args != null) {
          return CupertinoPageRoute(
              builder: (_) => AdminEditPaket(
                    data: args,
                  ));
        }
        return _errorRoute();
      case '/AdminPembayaran':
        return CupertinoPageRoute(builder: (_) => AdminPembayaran());
      case '/InputPembayaran':
        if (args != null) {
          return CupertinoPageRoute(
              builder: (_) => InputPembayaran(
                user_id: args,
              ));
        }
        return _errorRoute();
      case '/DataJamaah':
        return CupertinoPageRoute(builder: (_) => DataJamaah());
      case '/DetailJamaah':
        if (args != null) {
          return CupertinoPageRoute(
              builder: (_) => DetailJamaah(
                    data: args,
                  ));
        }
        return _errorRoute();
      case '/PDFPreview':
        if (args != null) {
          return CupertinoPageRoute(
              builder: (_) => PdfPreviewScreen(
                path: args,
              ));
        }
        return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return CupertinoPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
