import 'package:flutter/material.dart';
import 'package:build_your_focus/building_model/building_model.dart';

class UserDataService {
  // Singleton pattern
  static final UserDataService _instance = UserDataService._internal();
  factory UserDataService() => _instance;
  UserDataService._internal();

  // User's buildings progress
  final Map<String, UserBuilding> _userBuildings = {};

  // Current active building
  String? _currentBuildingId;

  // Get or create user building
  UserBuilding getUserBuilding(String buildingId) {
    if (!_userBuildings.containsKey(buildingId)) {
      _userBuildings[buildingId] = UserBuilding(buildingId: buildingId);
    }
    return _userBuildings[buildingId]!;
  }

  // Add progress to a building
  void addProgress(String buildingId, int minutes) {
    UserBuilding userBuilding = getUserBuilding(buildingId);
    userBuilding.progressMinutes += minutes;

    // Check if completed
    Building? building = BuildingData.getBuildingById(buildingId);
    if (building != null && building.isComplete(userBuilding.progressMinutes)) {
      userBuilding.isCompleted = true;
      userBuilding.completedAt = DateTime.now();
    }
  }

  // Get all completed buildings
  List<UserBuilding> getCompletedBuildings() {
    return _userBuildings.values.where((ub) => ub.isCompleted).toList();
  }

  // Get total focus time
  int getTotalFocusMinutes() {
    return _userBuildings.values.fold(0, (sum, ub) => sum + ub.progressMinutes);
  }

  // Set current active building
  void setCurrentBuilding(String buildingId) {
    _currentBuildingId = buildingId;
  }

  // Get current active building
  String? getCurrentBuildingId() {
    return _currentBuildingId;
  }

  // Check if building has been started
  bool isBuildingStarted(String buildingId) {
    return _userBuildings.containsKey(buildingId) &&
        _userBuildings[buildingId]!.progressMinutes > 0;
  }
}