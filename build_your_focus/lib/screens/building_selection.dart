// screens/building_selection_screen.dart

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
  final BuildingProgressFirestoreService _progressService =
  BuildingProgressFirestoreService();

  final List<Building> _buildings = BuildingData.getAllBuildings();

  @override
  Widget build(BuildContext context) {

    String? currentBuildingId = _userDataService.getCurrentBuildingId();

    return StreamBuilder<Map<String, UserBuilding>>(
      stream: _progressService.streamUserBuildings(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            drawer: AppDrawer(),
            backgroundColor: Colors.white,
            body: Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final progressMap = snapshot.data!;

        // Current building + its progress (from Firestore)
        Building? currentBuilding = currentBuildingId != null
            ? BuildingData.getBuildingById(currentBuildingId)
            : null;

        UserBuilding? currentUserBuilding = currentBuildingId != null
            ? (progressMap[currentBuildingId] ??
            UserBuilding(buildingId: currentBuildingId))
            : null;

        List<Building> availableBuildings = _buildings.where((building) {
          // Don't show the building if it's the current active project (and not completed)
          if (currentBuildingId != null && building.id == currentBuildingId) {
            UserBuilding ub = progressMap[building.id] ?? UserBuilding(buildingId: building.id);
            if (!ub.isCompleted) {
              return false; // Hide from grid - it's shown in "Current Project" section
            }
          }
          return true;
        }).toList();

        return Scaffold(
          drawer: AppDrawer(),
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Builder(
                          builder: (context) => IconButton(
                            icon: Icon(Icons.menu, size: 28, color: Colors.black),
                            onPressed: () => Scaffold.of(context).openDrawer(),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/profile_page');
                          },
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Color(0xFFF5F5F5),
                            child: Icon(Icons.person, color: Colors.black),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 30),

                    // Title
                    Text(
                      "Choose Your Project",
                      style: GoogleFonts.montserrat(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      "Build monuments through focus",
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
                      ),
                    ),

                    SizedBox(height: 30),

                    // Current Project (if exists)
                    if (currentBuilding != null &&
                        currentUserBuilding != null &&
                        !currentUserBuilding.isCompleted) ...[
                      Text(
                        "Current Project",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 12),
                      _buildCurrentProjectCard(currentBuilding, currentUserBuilding),
                      SizedBox(height: 30),
                    ],

                    // Available Buildings
                    Text(
                      currentBuilding != null
                          ? "Choose New Project"
                          : "Available Projects",
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),

                    SizedBox(height: 16),

                    // Building Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: availableBuildings.length,
                      itemBuilder: (context, index) {
                        final b = availableBuildings[index];
                        final ub = progressMap[b.id] ?? UserBuilding(buildingId: b.id);
                        final isStarted = (ub.progressMinutes > 0);
                        return _buildBuildingCard(b, ub, isStarted);
                      },
                    ),

                    SizedBox(height: 30),

                    // My City Button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BuildingCollectionPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFF5F5F5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "🏙️",
                              style: TextStyle(fontSize: 24),
                            ),
                            SizedBox(width: 12),
                            Text(
                              "View My City",
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCurrentProjectCard(Building building, UserBuilding userBuilding) {
    double progress = building.getProgress(userBuilding.progressMinutes);
    int currentStage = building.getCurrentStage(userBuilding.progressMinutes);

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Color.fromARGB(250, 194, 194, 194), width: 2),
      ),
      child: Column(
        children: [
          Text(
            building.name,
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),

          SizedBox(height: 16),

          // Building visualization placeholder
          Container(
            height: 150,
            child: Center(
              child: building.stages[currentStage].getImage(width: 180, height: 180),
            ),
          ),

          SizedBox(height: 10),

          Text(
            "Stage ${currentStage + 1} of ${building.stages.length}",
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),

          Text(
            building.stages[currentStage].name,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),

          SizedBox(height: 12),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(
                Color.fromARGB(250, 147, 246, 246),
              ),
            ),
          ),

          SizedBox(height: 8),

          Text(
            "${userBuilding.progressMinutes} / ${building.requiredMinutes} minutes",
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),

          SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: GestureDetector(
              onTap: () {
                _startFocusSession(building);
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFcdffd8), Color(0xFF94b9ff)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_arrow, color: Colors.black, size: 24),
                    SizedBox(width: 8),
                    Text(
                      "Continue Building",
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuildingCard(Building building, UserBuilding userBuilding, bool isStarted) {
    bool isCompleted = userBuilding.isCompleted;

    return Container(
      decoration: BoxDecoration(
        color: isCompleted ? Colors.green[50] : Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isCompleted ? Colors.green : Colors.grey[300]!,
          width: isCompleted ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: isCompleted ? null : () => _startFocusSession(building),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isCompleted)
                  Icon(Icons.check_circle, color: Colors.green, size: 24),
                Image.asset(
                  building.completedImagePath,
                  height: 120,
                  width: 150,
                  fit: BoxFit.cover,
                ),

                Text(
                  building.name,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12),

                if (isCompleted)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Complete",
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  )
                else if (isStarted)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFcdffd8), Color(0xFF94b9ff)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      "In Progress",
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  )
                else
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFcdffd8), Color(0xFF94b9ff)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      "Start",
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
              ],
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
      MaterialPageRoute(
        builder: (context) => FocusSessionScreen(building: building),
      ),
    ).then((_) {
      setState(() {}); // Refresh after returning
    });
  }
}
