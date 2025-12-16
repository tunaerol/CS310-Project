import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/building_progress_doc.dart';
import '../building_model/building_model.dart';

class BuildingProgressFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> _col(String uid) {
    return _db.collection("users").doc(uid).collection("buildingProgress");
  }

  // READ (stream) -> satisfies real-time requirement
  Stream<Map<String, UserBuilding>> streamUserBuildings() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _col(user.uid).snapshots().map((snap) {
      final map = <String, UserBuilding>{};
      for (final doc in snap.docs) {
        final data = doc.data();
        final buildingId = (data["buildingId"] ?? doc.id) as String;
        map[buildingId] = UserBuilding(
          buildingId: buildingId,
          progressMinutes: (data["progressMinutes"] ?? 0) as int,
          isCompleted: (data["isCompleted"] ?? false) as bool,
          completedAt: null, // optional; keep null unless you store it
        );
      }
      return map;
    });
  }

  // CREATE/UPDATE (upsert)
  Future<void> upsertProgress({
    required String buildingId,
    required int progressMinutes,
    required bool isCompleted,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Not logged in.");

    final ref = _col(user.uid).doc(buildingId);
    final snap = await ref.get();

    if (!snap.exists) {
      final doc = BuildingProgressDoc(
        buildingId: buildingId,
        progressMinutes: progressMinutes,
        isCompleted: isCompleted,
        createdBy: user.uid,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
      );
      await ref.set(doc.toMap());
    } else {
      await ref.update({
        "progressMinutes": progressMinutes,
        "isCompleted": isCompleted,
        "updatedAt": Timestamp.now(),
      });
    }
  }

  // UPDATE helper (increment minutes and auto-check completion)
  Future<void> addMinutes({
    required String buildingId,
    required int minutesToAdd,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Not logged in.");

    final ref = _col(user.uid).doc(buildingId);

    await _db.runTransaction((tx) async {
      final snap = await tx.get(ref);

      int currentMinutes = 0;
      Timestamp? createdAt;
      String createdBy = user.uid;

      if (snap.exists) {
        final data = snap.data() as Map<String, dynamic>;
        currentMinutes = (data["progressMinutes"] ?? 0) as int;
        createdAt = data["createdAt"] as Timestamp?;
        createdBy = (data["createdBy"] ?? user.uid) as String;
      }

      final newMinutes = currentMinutes + minutesToAdd;

      final building = BuildingData.getBuildingById(buildingId);
      final completed = building != null && building.isComplete(newMinutes);

      if (!snap.exists) {
        final doc = BuildingProgressDoc(
          buildingId: buildingId,
          progressMinutes: newMinutes,
          isCompleted: completed,
          createdBy: createdBy,
          createdAt: createdAt ?? Timestamp.now(),
          updatedAt: Timestamp.now(),
        );
        tx.set(ref, doc.toMap());
      } else {
        tx.update(ref, {
          "progressMinutes": newMinutes,
          "isCompleted": completed,
          "updatedAt": Timestamp.now(),
        });
      }
    });
  }

  // DELETE
  Future<void> deleteProgress(String buildingId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Not logged in.");
    await _col(user.uid).doc(buildingId).delete();
  }
}
