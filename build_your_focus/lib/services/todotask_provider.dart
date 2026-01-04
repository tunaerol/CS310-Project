import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/todotask_model.dart';

class ToDoTaskProvider extends ChangeNotifier {
  final FirebaseFirestore _db;

  ToDoTaskProvider({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;


  // 1. READ: Get a real-time stream of tasks for a specific user
  // This satisfies the "Real-time updates" requirement [cite: 34, 60]
  Stream<List<ToDoTaskModel>> getTasks(String userId) {
    return _db
        .collection('tasks')
        .where('createdBy', isEqualTo: userId) // Security: only see own data
        .orderBy('createdAt')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ToDoTaskModel.fromMap(doc.data(), doc.id))
        .toList());
  }

  // 2. CREATE: Add a new task to Firestore [cite: 30]
  Future<void> addTask(String title, String userId) async {
    try {
      await _db.collection('tasks').add({
        'title': title,
        'isCompleted': false,
        'createdBy': userId, // Linked to user ID [cite: 28]
        'createdAt': FieldValue.serverTimestamp(), // Firestore timestamp [cite: 29]
      });
    } catch (e) {
      debugPrint("Error adding task: $e");
    }
  }

  // 3. UPDATE: Toggle task completion [cite: 31]
  Future<void> toggleTaskStatus(String taskId, bool currentStatus) async {
    await _db.collection('tasks').doc(taskId).update({
      'isCompleted': !currentStatus,
    });
  }

  // 4. DELETE: Remove a task [cite: 33]
  Future<void> deleteTask(String taskId) async {
    await _db.collection('tasks').doc(taskId).delete();
  }
}