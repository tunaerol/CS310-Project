import 'package:cloud_firestore/cloud_firestore.dart';

class ToDoTaskModel {
  String id;
  String title;
  bool isCompleted;
  String createdBy;
  DateTime createdAt;

  ToDoTaskModel({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.createdBy,
    required this.createdAt,
  });

  // Convert Firestore Document to TaskModel (For Reading Data)
  factory ToDoTaskModel.fromMap(Map<String, dynamic> data, String id) {
    return ToDoTaskModel(
      id: id,
      title: data['title'] ?? '',
      isCompleted: data['isCompleted'] ?? false,
      createdBy: data['createdBy'] ?? '',
      // Handles the Firestore Timestamp conversion
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Convert TaskModel to Map (For Writing Data to Firestore)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isCompleted': isCompleted,
      'createdBy': createdBy,
      'createdAt': FieldValue.serverTimestamp(), // Firestore generates the time
    };
  }
}