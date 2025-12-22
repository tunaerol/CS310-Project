import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:build_your_focus/building_model/building_model.dart';
import 'package:build_your_focus/services/building_progress_firestore_service.dart';
import 'app_drawer.dart';

class BuildingCollectionPage extends StatelessWidget {
  const BuildingCollectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final BuildingProgressFirestoreService progressService =
    BuildingProgressFirestoreService();
    final List<Building> allBuildings = BuildingData.getAllBuildings();

    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black, size: 28),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          "My City",
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<Map<String, UserBuilding>>(
        stream: progressService.streamUserBuildings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final progressMap = snapshot.data ?? <String, UserBuilding>{};

          final completedBuildings = allBuildings.where((building) {
            final ub = progressMap[building.id];
            return ub != null && ub.isCompleted;
          }).toList();

          if (completedBuildings.isEmpty) {
            return _buildEmptyState();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "🏆 Completed Buildings",
                  style: GoogleFonts.montserrat(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "${completedBuildings.length} building${completedBuildings.length > 1 ? 's' : ''} completed",
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),

                const SizedBox(height: 24),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: completedBuildings.length,
                  itemBuilder: (context, index) {
                    final building = completedBuildings[index];
                    final userBuilding = progressMap[building.id]!;
                    return _buildCompletedBuildingCard(building, userBuilding);
                  },
                ),

                const SizedBox(height: 30),

                _buildStatsCard(progressMap, allBuildings),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "🏗️",
              style: TextStyle(fontSize: 80),
            ),

            const SizedBox(height: 24),

            Text(
              "Your City is Empty",
              style: GoogleFonts.montserrat(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            Text(
              "Complete focus sessions to build monuments and grow your city!",
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedBuildingCard(Building building, UserBuilding userBuilding) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.green, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 24),

            const SizedBox(height: 8),

            Expanded(
              child: building.stages[building.stages.length - 1].getImage(),
            ),

            const SizedBox(height: 8),

            Text(
              building.name,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 4),

            Text(
              "${userBuilding.progressMinutes} min",
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Complete",
                style: GoogleFonts.montserrat(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(Map<String, UserBuilding> progressMap, List<Building> allBuildings) {
    int totalMinutes = 0;
    int completedCount = 0;

    for (var ub in progressMap.values) {
      totalMinutes += ub.progressMinutes;
      if (ub.isCompleted) completedCount++;
    }

    int totalHours = totalMinutes ~/ 60;
    int remainingMinutes = totalMinutes % 60;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFcdffd8), Color(0xFF94b9ff)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem("🏛️", "$completedCount / ${allBuildings.length}", "Buildings"),
          Container(width: 1, height: 40, color: Colors.black26),
          _buildStatItem("⏱️", "${totalHours}h ${remainingMinutes}m", "Total Focus"),
        ],
      ),
    );
  }

  Widget _buildStatItem(String emoji, String value, String label) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}