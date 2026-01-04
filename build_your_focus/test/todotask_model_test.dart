import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:build_your_focus/models/todotask_model.dart';

void main() {
  test('ToDoTaskModel.fromMap converts Timestamp to DateTime', () {
    final now = DateTime(2026, 1, 4, 12, 0);

    final data = {
      'title': 'Study',
      'isCompleted': true,
      'createdBy': 'u1',
      'createdAt': Timestamp.fromDate(now),
    };

    final m = ToDoTaskModel.fromMap(data, 'doc1');

    expect(m.id, 'doc1');
    expect(m.title, 'Study');
    expect(m.isCompleted, true);
    expect(m.createdBy, 'u1');
    expect(m.createdAt, now);
  });
}
