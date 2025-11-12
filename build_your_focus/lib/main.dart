import 'package:build_your_focus/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'entrance/opening_page.dart';
import 'entrance/login_page.dart';
import 'entrance/sign_up_page.dart';

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
      initialRoute: '/opening_page',
      routes: {
        '/opening_page' :(context) => const FirstOpening(),
        '/login_page' : (context) => const LoginPage(),
        '/sign_up_page' : (context) => const SignUpPage(),
        '/home_page' : (context) => const HomePage(),
      },
    );
  }
}
