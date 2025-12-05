import 'package:flutter/material.dart';

class Building {
  final String id;
  final String name;
  final String completedImagePath;
  final int requiredMinutes;
  final String description;
  final List<BuildingStage> stages;

  Building({
    required this.id,
    required this.name,
    required this.completedImagePath,
    required this.requiredMinutes,
    required this.description,
    required this.stages,
  });

  // Helper method to get the completed image widget
  Widget getCompletedImage({double? height, double? width}) {
    return Image.asset(
      completedImagePath,
      height: height,
      width: width,
      fit: BoxFit.contain,
    );
  }

  int getCurrentStage(int progressMinutes) {
    double percentage = progressMinutes / requiredMinutes;
    int stageIndex = (percentage * stages.length).floor();
    return stageIndex.clamp(0, stages.length - 1);
  }

  bool isComplete(int progressMinutes) {
    return progressMinutes >= requiredMinutes;
  }

  double getProgress(int progressMinutes) {
    return (progressMinutes / requiredMinutes).clamp(0.0, 1.0);
  }
}

class BuildingStage {
  final String name;
  final String description;
  final String imagePath;

  BuildingStage({
    required this.name,
    required this.description,
    required this.imagePath,
  });

  // Helper method to get the stage image widget
  Widget getImage({double? height, double? width}) {
    return Image.asset(
      imagePath,
      height: height,
      width: width,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.image_not_supported, size: height ?? 48, color: Colors.grey);
      },
    );
  }
}

class UserBuilding {
  final String buildingId;
  int progressMinutes;
  bool isCompleted;
  DateTime? completedAt;

  UserBuilding({
    required this.buildingId,
    this.progressMinutes = 0,
    this.isCompleted = false,
    this.completedAt,
  });
}

class BuildingData {
  static List<Building> getAllBuildings() {
    return [
      Building(
        id: 'anitkabir',
        name: 'Anıtkabir',
        completedImagePath: "lib/assets/images/buildings/anitkabir/anitkabir8.png",
        requiredMinutes: 200,
        description: 'Build the place of Father of The Turks',
        stages: [
          BuildingStage(
            name: 'Stage 1',
            description: 'Laying the base',
            imagePath: "lib/assets/images/buildings/anitkabir/anitkabir1.png",
          ),
          BuildingStage(
            name: 'Stage 2',
            description: 'Building collonades',
            imagePath: "lib/assets/images/buildings/anitkabir/anitkabir2.png",
          ),
          BuildingStage(
            name: 'Stage 3',
            description: 'Rising higher',
            imagePath: "lib/assets/images/buildings/anitkabir/anitkabir3.png",
          ),
          BuildingStage(
            name: 'Stage 4',
            description: 'Taking shape',
            imagePath: "lib/assets/images/buildings/anitkabir/anitkabir4.png",
          ),
          BuildingStage(
            name: 'Stage 5!',
            description: 'Completing the top',
            imagePath: "lib/assets/images/buildings/anitkabir/anitkabir5.png",
          ),
          BuildingStage(
            name: 'Stage 6!',
            description: 'Constructing the side walls',
            imagePath: "lib/assets/images/buildings/anitkabir/anitkabir6.png",
          ),
          BuildingStage(
            name: 'Stage 7!',
            description: 'Compliting side walls',
            imagePath: "lib/assets/images/buildings/anitkabir/anitkabir7.png",
          ),
          BuildingStage(
            name: 'Stage 8!',
            description: 'Finished masterpiece',
            imagePath: "lib/assets/images/buildings/anitkabir/anitkabir8.png",
          ),
        ],
      ),
    ];
  }

  static Building? getBuildingById(String id) {
    try {
      return getAllBuildings().firstWhere((b) => b.id == id);
    } catch (e) {
      return null;
    }
  }
}