import 'package:flutter/material.dart';
import 'app_drawer.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/todotask_provider.dart';
import '../models/todotask_model.dart';

class toDoPage extends StatefulWidget {
  const toDoPage({super.key});

  @override
  State<toDoPage> createState() => _toDoPageState();
}

class _toDoPageState extends State<toDoPage> {
  final TextEditingController myController = TextEditingController();
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  void addNewTask() {
    if (myController.text.isNotEmpty) {
      Provider.of<ToDoTaskProvider>(context, listen: false).addTask(
          myController.text, currentUserId);
      myController.clear();
    }
  }

  void toggleTaskCompletion(ToDoTaskModel task) {
    Provider.of<ToDoTaskProvider>(context, listen: false).toggleTaskStatus(
        task.id, task.isCompleted);
  }

  void deleteTask(String taskId) {
    Provider.of<ToDoTaskProvider>(context, listen: false).deleteTask(taskId);
  }

  @override
  Widget build(BuildContext context) {
    final todoTaskProvider = Provider.of<ToDoTaskProvider>(context);

    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Build Your Day', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black)),
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(Icons.menu_rounded, color: Colors.black),
          ),
        ),
      ),
      body: Builder(
        builder: (context) {
          final currentUser = FirebaseAuth.instance.currentUser;
          if (currentUser == null) {
            return const Center(child: Text("Please log in"));
          }

          return StreamBuilder<List<ToDoTaskModel>>(
            stream: todoTaskProvider.getTasks(currentUser.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error loading tasks: ${snapshot.error}'));
              }

              final tasks = snapshot.data ?? [];
              final inProgressTasks = tasks.where((task) => !task.isCompleted).toList();
              final completedTasks = tasks.where((task) => task.isCompleted).toList();
              double progress = tasks.isNotEmpty ? completedTasks.length / tasks.length : 0.0;

              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildProgressBar(progress, completedTasks.length, tasks.length),
                  const SizedBox(height: 25),
                  _buildTaskInput(),
                  const SizedBox(height: 25),
                  _buildSectionHeader('In progress', inProgressTasks.length),
                  ...inProgressTasks.map((task) => _buildTaskTile(task)).toList(),
                  const SizedBox(height: 30),
                  _buildSectionHeader('Completed', completedTasks.length),
                  ...completedTasks.map((task) => _buildTaskTile(task)).toList(),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTaskInput() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: myController,
                decoration: const InputDecoration(hintText: "Add a new task...", border: InputBorder.none),
              ),
            ),
            IconButton(onPressed: addNewTask, icon: const Icon(Icons.add, color: Colors.indigo)),
          ],
        ),
      );
    }

    Widget _buildTaskTile(ToDoTaskModel task) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            leading: const Icon(Icons.drag_indicator_rounded, color: Colors.grey, size: 20),
            title: Text(
              task.title,
              style: TextStyle(
                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                color: task.isCompleted ? Colors.grey[600] : Colors.black,
              ),
            ),
            trailing: Checkbox(
              value: task.isCompleted,
              onChanged: (_) => toggleTaskCompletion(task),
              activeColor: Colors.blueAccent,
            ),
            onLongPress: () => deleteTask(task.id),
          ),
        ),
      );
    }

    Widget _buildProgressBar(double progress, int completed, int total) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.15), blurRadius: 5, offset: const Offset(0, 3))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text("Today's Progress", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const Spacer(),
                Text('${(progress * 100).toStringAsFixed(0)}%', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
              ],
            ),
            const SizedBox(height: 8),
            Text('$completed of $total tasks completed', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            const SizedBox(height: 10),
            LinearProgressIndicator(value: progress, backgroundColor: Colors.blue.shade100, color: Colors.blueAccent, minHeight: 12, borderRadius: BorderRadius.circular(6)),
          ],
        ),
      );
    }

    Widget _buildSectionHeader(String title, int count) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text('$title ($count)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800])),
      );
    }
  }
