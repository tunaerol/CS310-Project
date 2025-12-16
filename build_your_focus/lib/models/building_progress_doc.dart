import 'package:cloud_firestore/cloud_firestore.dart';

class BuildingProgressDoc {
  final String buildingId;
  final int progressMinutes;
  final bool isCompleted;

  // rubric fields
  final String createdBy;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  BuildingProgressDoc({
    required this.buildingId,
    required this.progressMinutes,
    required this.isCompleted,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "buildingId": buildingId,
      "progressMinutes": progressMinutes,
      "isCompleted": isCompleted,
      "createdBy": createdBy,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }

  factory BuildingProgressDoc.fromMap(Map<String, dynamic> map) {
    return BuildingProgressDoc(
      buildingId: (map["buildingId"] ?? "") as String,
      progressMinutes: (map["progressMinutes"] ?? 0) as int,
      isCompleted: (map["isCompleted"] ?? false) as bool,
      createdBy: (map["createdBy"] ?? "") as String,
      createdAt: (map["createdAt"] ?? Timestamp.now()) as Timestamp,
      updatedAt: (map["updatedAt"] ?? Timestamp.now()) as Timestamp,
    );
  }
}
