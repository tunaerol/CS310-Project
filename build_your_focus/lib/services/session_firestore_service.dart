import 'package:cloud_firestore/cloud_firestore.dart';

class SessionFirestoreService {
  final FirebaseFirestore _db;

  SessionFirestoreService({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  Future<void> addSession({
    required String createdBy,
    required String buildingName,
    required int durationMinutes,
  }) async {
    await _db.collection('sessions').add({
      'createdBy': createdBy,
      'createdAt': FieldValue.serverTimestamp(),
      'buildingName': buildingName,
      'duration': durationMinutes,
    });
  }
}