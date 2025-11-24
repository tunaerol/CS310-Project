import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  double focusGoal = 2.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Colors.teal, Colors.green]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.person, color: Colors.white),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Username', style: TextStyle(color: Colors.white, fontSize: 16)),
                      Text('username@mail.com', style: TextStyle(color: Colors.white70)),
                      Text('Builder since 2025', style: TextStyle(color: Colors.white70)),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('Name'), TextField(controller: nameController),
            const SizedBox(height: 10),
            const Text('Email'), TextField(controller: emailController),
            const SizedBox(height: 10),
            const Text('Daily focus goal (hours):'),
            Slider(
              value: focusGoal,
              onChanged: (value) {
                setState(() {
                  focusGoal = value;
                });
              },
              min: 0,
              max: 5,
              divisions: 10,
              label: "${focusGoal.toStringAsFixed(1)}h",
            ),
            ElevatedButton(onPressed: () {}, child: const Text('Save changes')),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Column(children: [
                  Icon(Icons.timer),
                  Text('Current streak'),
                  Text('5 days'),
                ]),
                Column(children: [
                  Icon(Icons.monetization_on),
                  Text('Coins'),
                  Text('245'),
                ]),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Achievements', style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 10,
              children: const [
                Chip(label: Text('First Building')),
                Chip(label: Text('2h in a day')),
                Chip(label: Text('Night Owl')),
              ],
            )
          ],
        ),
      ),
    );
  }
}