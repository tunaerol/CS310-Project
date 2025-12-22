import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
// Screens
import 'screens/auth/opening_page.dart';
import 'screens/auth/login_page.dart';
import 'screens/auth/sign_up_page.dart';
import 'screens/building_selection.dart';
import 'screens/building_collection_page.dart';
import 'screens/profile_page.dart';
import 'screens/to_do_page.dart';
import 'screens/construction_progress.dart';
// Services
import 'services/todotask_provider.dart';
import 'services/building_progress_provider.dart';
import 'services/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ToDoTaskProvider()),
        ChangeNotifierProvider(create: (_) => BuildingProgressProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.montserratTextTheme(
            Theme.of(context).textTheme,
          ),
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color(0xFFF5F6FA),
        ),
        home: const AuthWrapper(),
        routes: {
          '/opening_page': (context) => const FirstOpening(),
          '/login_page': (context) => const LoginPage(),
          '/sign_up_page': (context) => const SignUpPage(),
          '/home_page': (context) => const BuildingSelectionScreen(),
          '/building_page': (context) => const BuildingCollectionPage(),
          '/profile_page': (context) => const ProfilePage(),
          '/to_do_page': (context) => const toDoPage(),
          '/construction_page': (context) => const ConstructionProgressScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (auth.user == null && !auth.isLoggedIn) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (auth.isLoggedIn) {
      return const BuildingSelectionScreen();
    } else {
      return const FirstOpening();
    }
  }
}