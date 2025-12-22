import 'package:cloud_firestore/cloud_firestore.dart';

class FocusSessionModel {
  final String id;
  final String buildingName;
  final int duration; // in minutes
  final DateTime date;
  final String userId;

  FocusSessionModel({
    required this.id,
    required this.buildingName,
    required this.duration,
    required this.date,
    required this.userId,
  });

  factory FocusSessionModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return FocusSessionModel(
      id: doc.id,
      buildingName: data['buildingName'] ?? '',
      duration: data['duration'] ?? 0,
      date: (data['date'] as Timestamp).toDate(),
      userId: data['userId'] ?? '',
    );
  }
}