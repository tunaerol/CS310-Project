// screens/completion_screen.dart

import 'package:build_your_focus/screens/building_collection_page.dart';
import 'package:build_your_focus/screens/focus_session_screen.dart';
import 'package:build_your_focus/screens/building_selection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:build_your_focus/building_model/building_model.dart';
import 'package:build_your_focus/user_data/user_data_service.dart'
;

class CompletionScreen extends StatelessWidget {
  final Building building;
  final int sessionMinutes;

  const CompletionScreen({
    super.key,
    required this.building,
    required this.sessionMinutes,
  });

  @override
  Widget build(BuildContext context) {
    final UserDataService userDataService = UserDataService();
    UserBuilding userBuilding = userDataService.getUserBuilding(building.id);
    bool isComplete = building.isComplete(userBuilding.progressMinutes);
    int currentStage = building.getCurrentStage(userBuilding.progressMinutes);
    double progress = building.getProgress(userBuilding.progressMinutes);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              SizedBox(height: 40),

              // Celebration header
              Text(
                isComplete ? "🎉 Building Complete!" : "✨ Great Work!",
                style: GoogleFonts.montserrat(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 8),

              Text(
                isComplete
                    ? "${building.name} is finished!"
                    : "Session completed successfully",
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 40),

              // Building display
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: isComplete ? Colors.green[50] : Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isComplete ? Colors.green : Colors.grey[300]!,
                      width: isComplete ? 3 : 1,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Builder(
                            builder: (context) {
                              // Create the service instance here
                              final UserDataService userDataService = UserDataService();
                              UserBuilding userBuilding = userDataService.getUserBuilding(building.id);
                              int currentStage = building.getCurrentStage(userBuilding.progressMinutes);

                              // If complete, show the final stage, otherwise show current stage
                              int stageToShow = building.isComplete(userBuilding.progressMinutes)
                                  ? building.stages.length - 1
                                  : currentStage;

                              return building.stages[stageToShow].getImage(
                                height: 160,
                                width: 160,
                              );
                            }
                        ),
                        SizedBox(height: 16),
                        if (isComplete) ...[
                          Text(
                            "Complete!",
                            style: GoogleFonts.montserrat(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.green,
                            ),
                          ),
                        ] else ...[
                          Text(
                            "Stage ${currentStage + 1} of ${building.stages.length}",
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            building.stages[currentStage].name,
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30),

              // Progress info
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isComplete ? Colors.green : Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    if (!isComplete) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Progress:",
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "${(progress * 100).toInt()}%",
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 12,
                          backgroundColor: Colors.white,
                          valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(
                              250, 147, 246, 246)),
                        ),
                      ),
                      SizedBox(height: 12),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              "+$sessionMinutes min",
                              style: GoogleFonts.montserrat(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: isComplete ? Colors.white : Colors.black,
                              ),
                            ),
                            Text(
                              "Added",
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isComplete ? Colors.white : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: isComplete ? Colors.white : Colors.grey[300],
                        ),
                        Column(
                          children: [
                            Text(
                              "${userBuilding.progressMinutes} / ${building.requiredMinutes}",
                              style: GoogleFonts.montserrat(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: isComplete ? Colors.white : Colors.black,
                              ),
                            ),
                            Text(
                              "Total Minutes",
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isComplete ? Colors.white : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Action buttons
              if (isComplete) ...[
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => BuildingCollectionPage()),
                            (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "🏙️ View My City",
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => BuildingSelectionScreen()),
                            (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF5F5F5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: BorderSide(color: Colors.black, width: 2),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "Start New Project",
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                // Change this section (around line 230):
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: GestureDetector(
                    onTap: () {

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FocusSessionScreen(building: building),
                        ),
                            (route) => route.settings.name == '/home_page',
                      );
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
                      child: Center(
                        child: Text(
                          "Continue Building",
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BuildingSelectionScreen(),
                        ),
                            (route) => route.settings.name == '/home_page',
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Center(
                        child: Text(
                          "Choose Another Project",
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
