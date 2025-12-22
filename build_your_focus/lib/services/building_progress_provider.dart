import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/focus_session_model.dart';

class BuildingProgressProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<FocusSessionModel>> getWeeklySessions(String userId) {
    return _db
        .collection('sessions')
        .where('createdBy', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => FocusSessionModel.fromFirestore(doc))
        .toList());
  }
}