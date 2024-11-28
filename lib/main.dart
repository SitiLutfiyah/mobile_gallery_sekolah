import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'welcome.dart';

void main() {
  initializeDateFormatting('id_ID').then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMKN 4 BOGOR',
      theme: ThemeData(
        primaryColor: Color(0xFF1A237E),
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Poppins',
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF1A237E),
          elevation: 4,
        ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 4,
        ),
      ),
      home: WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}