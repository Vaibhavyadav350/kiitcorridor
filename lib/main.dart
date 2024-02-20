import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiitcorridor/screens/main_screen.dart';
import 'package:provider/provider.dart';

import 'color.dart';
import 'controllers/MenuAppController.dart';
import 'firebase_options.dart';

void main() async {
    print("Waitibg for WFB");
  WidgetsFlutterBinding.ensureInitialized();

  try {
    print("Waitibg for FB");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on PlatformException {
    print(
        "WARNING: Firebase not connected. If you are testing, ignore this message.");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Admin Panel',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MenuAppController(),
          ),
        ],
        child: const MainScreen(),
      ),
    );
  }
}
