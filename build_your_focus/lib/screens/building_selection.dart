import 'package:build_your_focus/screens/building_collection_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:build_your_focus/building_model/building_model.dart';
import 'package:build_your_focus/user_data/user_data_service.dart';
import 'package:build_your_focus/services/building_progress_firestore_service.dart';
import 'focus_session_screen.dart';
import 'app_drawer.dart';

class BuildingSelectionScreen extends StatefulWidget {
  const BuildingSelectionScreen({super.key});

  @override
  State<BuildingSelectionScreen> createState() => _BuildingSelectionScreenState();
}

class _BuildingSelectionScreenState extends State<BuildingSelectionScreen> {
  final UserDataService _userDataService = UserDataService();
  final BuildingProgressFirestoreService _progressService = BuildingProgressFirestoreService();
  final List<Building> _buildings = BuildingData.getAllBuildings();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, UserBuilding>>(
      stream: _progressService.streamUserBuildings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final progressMap = snapshot.data ?? <String, UserBuilding>{};

        String? currentBuildingId = _userDataService.getCurrentBuildingId();

        UserBuilding? currentUserBuilding;
        Building? currentBuilding;

        if (currentBuildingId != null) {
          currentBuilding = BuildingData.getBuildingById(currentBuildingId);
          currentUserBuilding = progressMap[currentBuildingId] ?? UserBuilding(buildingId: currentBuildingId);
        }

        List<Building> availableBuildings = _buildings.where((building) {
          final ub = progressMap[building.id] ?? UserBuilding(buildingId: building.id);

          if (ub.isCompleted) {
            return false;
          }

          if (currentBuildingId != null && building.id == currentBuildingId) {
            return false;
          }

          return true;
        }).toList();

        bool hasActiveProject = currentBuilding != null &&
            currentUserBuilding != null &&
            !currentUserBuilding.isCompleted;

        return Scaffold(
          drawer: const AppDrawer(),
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 30),
                    _buildTitleSection(),
                    const SizedBox(height: 30),

                    if (hasActiveProject) ...[
                      _buildLabel("Current Project"),
                      const SizedBox(height: 12),
                      _buildCurrentProjectCard(currentBuilding, currentUserBuilding),
                      const SizedBox(height: 30),
                    ],

                    if (availableBuildings.isEmpty && !hasActiveProject) ...[
                      _buildAllCompletedMessage(),
                    ] else if (availableBuildings.isNotEmpty) ...[
                      _buildLabel(hasActiveProject ? "Choose New Project" : "Available Projects"),
                      const SizedBox(height: 16),

                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.62,
                        ),
                        itemCount: availableBuildings.length,
                        itemBuilder: (context, index) {
                          final b = availableBuildings[index];
                          final ub = progressMap[b.id] ?? UserBuilding(buildingId: b.id);
                          return _buildBuildingCard(b, ub);
                        },
                      ),
                    ],

                    const SizedBox(height: 30),
                    _buildMyCityButton(context),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, size: 28, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        Text(
          "Build Your Focus",
          style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(width: 48),
      ],
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Choose Your Project",
          style: GoogleFonts.montserrat(fontSize: 28, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          "Build monuments through focus",
          style: GoogleFonts.montserrat(fontSize: 16, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w700),
    );
  }

  Widget _buildCurrentProjectCard(Building building, UserBuilding userBuilding) {
    double progress = building.getProgress(userBuilding.progressMinutes);
    int currentStage = building.getCurrentStage(userBuilding.progressMinutes);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300, width: 2),
      ),
      child: Column(
        children: [
          Text(building.name, style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          building.stages[currentStage].getImage(height: 140, width: 140),
          const SizedBox(height: 10),
          Text("Stage ${currentStage + 1} of ${building.stages.length}",
              style: GoogleFonts.montserrat(fontSize: 14, color: Colors.grey[600])),
          Text(building.stages[currentStage].name,
              style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation(Color(0xFF85DDB2)),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 10),
          Text("${userBuilding.progressMinutes} / ${building.requiredMinutes} min",
              style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 18),
          _buildContinueButton(building),
        ],
      ),
    );
  }

  Widget _buildContinueButton(Building building) {
    return GestureDetector(
      onTap: () => _startFocusSession(building),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFcdffd8), Color(0xFF94b9ff)]),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.play_arrow, color: Colors.black),
            const SizedBox(width: 8),
            Text("Continue Building",
                style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Widget _buildBuildingCard(Building building, UserBuilding userBuilding) {
    bool isStarted = userBuilding.progressMinutes > 0;
    int currentStage = building.getCurrentStage(userBuilding.progressMinutes);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _startFocusSession(building),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: building.stages[currentStage].getImage(),
              ),
              const SizedBox(height: 8),
              Text(building.name,
                  style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center, maxLines: 1),
              if (isStarted) ...[
                const SizedBox(height: 4),
                Text("Stage ${currentStage + 1}", style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: building.getProgress(userBuilding.progressMinutes),
                    minHeight: 4,
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF85DDB2)),
                  ),
                ),
              ],
              const SizedBox(height: 8),
              _buildBadge(isStarted),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(bool isStarted) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isStarted ? const Color(0xFF85DDB2).withOpacity(0.3) : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isStarted ? "Progress" : "Start",
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  Widget _buildAllCompletedMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.green, width: 2),
      ),
      child: Column(
        children: [
          const Text(
            "🎉",
            style: TextStyle(fontSize: 60),
          ),
          const SizedBox(height: 16),
          Text(
            "Congratulations!",
            style: GoogleFonts.montserrat(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.green[700],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "You've completed all buildings!\nYour city is now complete.",
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMyCityButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const BuildingCollectionPage(),
            settings: const RouteSettings(name: '/building_page'),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFcdffd8), Color(0xFF94b9ff)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
            child: Text(
              "🏙️ View My City",
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _startFocusSession(Building building) {
    _userDataService.setCurrentBuilding(building.id);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FocusSessionScreen(building: building)),
    ).then((_) {
      if (mounted) setState(() {});
    });
  }
}