import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:build_your_focus/building_model/building_model.dart';
import 'package:build_your_focus/services/building_progress_firestore_service.dart';
import 'app_drawer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final BuildingProgressFirestoreService _progressService = BuildingProgressFirestoreService();
  User? user;

  late TextEditingController nameController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    nameController = TextEditingController(text: user?.displayName ?? "");
    emailController = TextEditingController(text: user?.email ?? "");
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    try {
      if (user != null) {
        await user!.updateDisplayName(nameController.text);
        await user!.reload();
        setState(() => user = _auth.currentUser);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully!'))
          );
        }
      }
    } catch (e) {
      debugPrint("Update error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Building> allBuildings = BuildingData.getAllBuildings();

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const AppDrawer(),
      body: StreamBuilder<Map<String, UserBuilding>>(
        stream: _progressService.streamUserBuildings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final progressMap = snapshot.data ?? <String, UserBuilding>{};

          // Toplam süre ve tamamlanma hesaplaması
          int totalMinutes = 0;
          int completedCount = 0;
          for (var ub in progressMap.values) {
            totalMinutes += ub.progressMinutes;
            if (ub.isCompleted) completedCount++;
          }

          double totalHours = totalMinutes / 60;
          bool allBuildingsCompleted = allBuildings.isNotEmpty && completedCount == allBuildings.length;

          return SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 30),
                  _buildProfileCard(totalHours, completedCount, allBuildings.length),
                  const SizedBox(height: 30),
                  _buildLabel("Achievements"),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildBadgeCard("Novice", "10h focus", Icons.timer, totalHours >= 10, Colors.blue),
                      _buildBadgeCard("Architect", "100h focus", Icons.architecture, totalHours >= 100, Colors.amber),
                      _buildBadgeCard("Legend", "All buildings", Icons.location_city, allBuildingsCompleted, Colors.purple),
                    ],
                  ),
                  const SizedBox(height: 30),
                  _buildLabel("Name"),
                  const SizedBox(height: 8),
                  TextField(
                      controller: nameController,
                      style: GoogleFonts.montserrat(),
                      decoration: _inputDecoration()
                  ),
                  const SizedBox(height: 20),
                  _buildLabel("Email"),
                  const SizedBox(height: 8),
                  TextField(
                    controller: emailController,
                    readOnly: true,
                    style: GoogleFonts.montserrat(color: Colors.grey[600]),
                    decoration: _inputDecoration().copyWith(fillColor: Colors.grey[100]),
                  ),
                  const SizedBox(height: 40),
                  _buildSaveButton(),
                  const SizedBox(height: 30), // Alt kısımda temiz bir bitiş için boşluk
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Builder(builder: (context) => IconButton(
            icon: const Icon(Icons.menu, size: 28),
            onPressed: () => Scaffold.of(context).openDrawer()
        )),
        Text("Build Your Focus", style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(width: 48),
      ],
    );
  }

  Widget _buildProfileCard(double hours, int completed, int total) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFcdffd8), Color(0xFF94b9ff)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const CircleAvatar(
              radius: 35,
              backgroundColor: Colors.white70,
              child: Icon(Icons.person, size: 40, color: Colors.blueGrey)
          ),
          const SizedBox(height: 12),
          Text(user?.displayName ?? 'Username', style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("🏛️ $completed/$total Buildings", style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(width: 15),
              Text("⏱️ ${hours.toStringAsFixed(1)}h Total", style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeCard(String name, String desc, IconData icon, bool isUnlocked, Color color) {
    return Opacity(
      opacity: isUnlocked ? 1.0 : 0.3,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isUnlocked ? color.withOpacity(0.5) : Colors.grey.shade300, width: 2),
        ),
        child: Column(
          children: [
            Icon(icon, color: isUnlocked ? color : Colors.grey, size: 30),
            const SizedBox(height: 8),
            Text(name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            Text(desc, style: const TextStyle(fontSize: 9, color: Colors.grey), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(text, style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w700));

  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: _updateProfile,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFcdffd8), Color(0xFF94b9ff)]),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(child: Text("Save Changes", style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w700))),
      ),
    );
  }

  InputDecoration _inputDecoration() => InputDecoration(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF85DDB2), width: 2)),
  );
}