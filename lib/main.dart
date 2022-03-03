import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import './pages/home.page.dart';
import './models/user.dart';
import './models/transfer.dart';
import './utils/sqlite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Db.init();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(
        users: Users(initialValue: (await User.getAll())!),
        transfers: Transfers(initialValue: (await Transfer.getAll())!),
      ),
      theme: ThemeData(
        primaryColorLight: Colors.white,
        primaryColorDark: Colors.black,
        fontFamily: GoogleFonts.raleway().fontFamily,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      darkTheme: ThemeData(
        primaryColorLight: Colors.black87,
        primaryColorDark: Colors.white,
        fontFamily: GoogleFonts.raleway().fontFamily,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      themeMode: ThemeMode.system,
    ),
  );
}
