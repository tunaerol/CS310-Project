import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  late final StreamSubscription<User?> _authSub;

  AuthProvider() {
    _user = _auth.currentUser;
    _authSub = _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;
  bool get isLoggedIn => _user != null;

  @override
  void dispose() {
    _authSub.cancel();
    super.dispose();
  }
}