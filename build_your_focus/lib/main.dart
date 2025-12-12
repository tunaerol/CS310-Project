import 'package:build_your_focus/screens/building_selection.dart';
import 'package:build_your_focus/screens/construction_progress.dart';
import 'package:build_your_focus/screens/to_do_page.dart';
import 'package:flutter/material.dart';
import 'entrance/opening_page.dart';
import 'entrance/login_page.dart';
import 'entrance/sign_up_page.dart';
import 'package:build_your_focus/screens/building_collection_page.dart';
import 'package:build_your_focus/screens/profile_page.dart';
import 'package:google_fonts/google_fonts.dart';


void main(){
  runApp(const FocusApp());
}

class FocusApp extends StatefulWidget {
  const FocusApp({super.key});

  @override
  State<FocusApp> createState() => _FocusAppState();
}

class _FocusAppState extends State<FocusApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
      ),
      initialRoute: '/opening_page',
      routes: {
        '/opening_page' :(context) => const FirstOpening(),
        '/login_page' : (context) => const LoginPage(),
        '/sign_up_page' : (context) => const SignUpPage(),
        '/home_page' : (context) => const BuildingSelectionScreen(),
        '/building_page': (context) => const BuildingCollectionPage(),
        '/profile_page': (context) => const ProfilePage(),
        '/to_do_page': (context) => const toDoPage(),
        '/construction_page': (context) => const ConstructionProgressScreen(),
      },
    );
  }
}
