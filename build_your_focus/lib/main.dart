import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const toDoPage(),
    );
  }
}

class toDoPage extends StatefulWidget {
  const toDoPage({super.key});

  @override
  State<toDoPage> createState() => _toDoPageState();
}

class _toDoPageState extends State<toDoPage> {
  final TextEditingController myController = TextEditingController();

  List toDoList = [
    ["Plan weekly study calendar", false],
    ["Update project team on progress", false],
    ["Review project phase requirements", true],
    ["Complete project page designs", true],
  ];

  void toggleTaskCompletion(int index) {
    setState(() {
      toDoList[index][1] = !toDoList[index][1];
    });
  }

  void addNewTask() {
    setState(() {
      if (myController.text.isNotEmpty) {
        toDoList.add([myController.text, false]);
        myController.clear();
      }
    });
  }
  
  Widget TaskTile(String taskName, bool isCompleted, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          leading: Icon(
            Icons.drag_indicator_rounded,
            color: Colors.grey[400],
            size: 20,
          ),
          title: Text(
            taskName,
            style: TextStyle(
              decoration: isCompleted ? TextDecoration.lineThrough : null,
              color: isCompleted ? Colors.grey[600] : Colors.black,
            ),
          ),
          trailing: Checkbox(
            value: isCompleted,
            onChanged: (value) => toggleTaskCompletion(index),
            activeColor: Colors.blueAccent,
            checkColor: Colors.white,
            side: const BorderSide(color: Colors.grey, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
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
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.description_outlined, color: Colors.blueAccent),
              ),
              const SizedBox(width: 10),
              const Text("Today's Progress", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const Spacer(),
              Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('$completed of $total tasks completed', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.blue.shade100,
            color: Colors.blueAccent,
            minHeight: 12,
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      ),
    );
}
  
  @override
  Widget build(BuildContext context) {
    final inProgressTasks = toDoList.where((task) => !task[1]).toList();
    final completedTasks = toDoList.where((task) => task[1]).toList();

    int totalTasks = toDoList.length;
    int completedCount = completedTasks.length;
    double progress = totalTasks == 0 ? 0.0 : completedCount / totalTasks;
    
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Build Your Day', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black)),
            Text('Monday, Nov 24', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            ],
          ),
        ),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu_rounded, color: Colors.black), // Changed to a rounded menu icon
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.calendar_today_outlined, color: Colors.black), // Matches the design
          )
        ],
      ),
      
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
   
          _buildProgressBar(progress, completedCount, totalTasks),

          const SizedBox(height: 25),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: myController,
                    decoration: const InputDecoration(
                      hintText: "Add a new task...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: addNewTask,
                  icon: const Icon(Icons.add, color: Colors.indigo),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          Text('In progress (${inProgressTasks.length})', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800])),
          const SizedBox(height: 10),
          ...inProgressTasks.map((task) {
            int originalIndex = toDoList.indexOf(task);
            return TaskTile(task[0], task[1], originalIndex);
          }).toList(),

          const SizedBox(height: 30),

          Text('Completed (${completedTasks.length})', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800])),
          const SizedBox(height: 10),
          ...completedTasks.map((task) {
            int originalIndex = toDoList.indexOf(task);
            return TaskTile(task[0], task[1], originalIndex);
          }).toList(),
        ],
      ),
    );
  }
}
