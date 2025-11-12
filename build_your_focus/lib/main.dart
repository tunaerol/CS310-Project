import 'package:flutter/material.dart';
import 'Entrance/opening_page.dart';

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
      initialRoute: '/first_opening',
      routes: {
        '/first_opening' :(context) => const FirstOpening(),
      },
    );
  }
}
