import 'dart:async';

import 'package:build_your_focus/building_model/building_model.dart';
import 'package:build_your_focus/screens/building_selection.dart';
import 'package:build_your_focus/screens/completion_screen.dart';
import 'package:build_your_focus/services/building_progress_firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FocusSessionScreen extends StatefulWidget {
  final Building building;

  const FocusSessionScreen({super.key, required this.building});

  @override
  State<FocusSessionScreen> createState() => _FocusSessionScreenState();
}

class _FocusSessionScreenState extends State<FocusSessionScreen> {
  final BuildingProgressFirestoreService _progressService =
  BuildingProgressFirestoreService();

  // Timer variables
  Timer? _timer;
  int _selectedDuration = 15;
  int _remainingSeconds = 15 * 60;
  bool _isRunning = false;

  // (kept as-is; you had it before)
  int _sessionMinutes = 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          _sessionMinutes = _selectedDuration - (_remainingSeconds / 60).ceil();
        } else {
          _completeSession();
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  Future<void> _stopSession() async {
    _timer?.cancel();

    final totalSeconds = _selectedDuration * 60;
    final secondsCompleted = totalSeconds - _remainingSeconds;
    final minutesCompleted = (secondsCompleted / 60).ceil();

    if (minutesCompleted > 0) {
      try {
        await _progressService.addMinutes(
          buildingId: widget.building.id,
          minutesToAdd: minutesCompleted,
        );
      } catch (e) {
        debugPrint("Firestore addMinutes failed: $e");
      }
    }

    if (!mounted) return;
    _goToHome();
  }

  void _goToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const BuildingSelectionScreen()),
          (route) => false,
    );
  }

  Future<void> _completeSession() async {
    _timer?.cancel();

    try {
      await _progressService.addMinutes(
        buildingId: widget.building.id,
        minutesToAdd: _selectedDuration,
      );
    } catch (e) {
      debugPrint("Firestore addMinutes failed: $e");
    }

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CompletionScreen(
          building: widget.building,
          sessionMinutes: _selectedDuration,
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Widget _buildDurationSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            "Session Duration",
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDurationOption(15),
              const SizedBox(width: 2),
              _buildDurationOption(30),
              const SizedBox(width: 2),
              _buildDurationOption(45),
              const SizedBox(width: 2),
              _buildDurationOption(60),
              const SizedBox(width: 2),
              _buildDurationOption(120),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDurationOption(int minutes) {
    final isSelected = _selectedDuration == minutes;
    final canChange = !_isRunning;

    return Opacity(
      opacity: canChange ? 1.0 : 0.5,
      child: GestureDetector(
        onTap: canChange
            ? () {
          setState(() {
            _selectedDuration = minutes;
            _remainingSeconds = minutes * 60;
          });
        }
            : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
              colors: [Color(0xFFcdffd8), Color(0xFF94b9ff)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            )
                : null,
            color: isSelected ? null : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color.fromARGB(150, 156, 188, 245)
                  : Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: Text(
            "$minutes min",
            style: GoogleFonts.montserrat(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, UserBuilding>>(
      stream: _progressService.streamUserBuildings(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
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
        final userBuilding = progressMap[widget.building.id] ??
            UserBuilding(buildingId: widget.building.id);

        final currentStage =
        widget.building.getCurrentStage(userBuilding.progressMinutes);

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              "Focus Session",
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
            leading: !_isRunning
                ? IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            )
                : null,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  Text(
                    "Building: ${widget.building.name}",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  _buildDurationSelector(),
                  const SizedBox(height: 20),

                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            widget.building.stages[currentStage].getImage(
                              height: 150,
                              width: 150,
                            ),
                            Text(
                              "Stage ${currentStage + 1} of ${widget.building.stages.length}",
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                            Text(
                              widget.building.stages[currentStage].name,
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                  Text(
                    _formatTime(_remainingSeconds),
                    style: GoogleFonts.montserrat(
                      fontSize: 64,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30),

                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 55,
                          child: GestureDetector(
                            onTap: _isRunning ? _pauseTimer : _startTimer,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: _isRunning
                                    ? null
                                    : const LinearGradient(
                                  colors: [
                                    Color(0xFFcdffd8),
                                    Color(0xFF94b9ff)
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                color: _isRunning
                                    ? const Color(0xFFF5F5F5)
                                    : null,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: _isRunning
                                      ? Colors.black
                                      : Colors.transparent,
                                  width: _isRunning ? 2 : 0,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _isRunning
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.black,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _isRunning ? "Pause" : "Start",
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
                        ),
                      ),
                      const SizedBox(width: 16),
                      if (_isRunning ||
                          _remainingSeconds != _selectedDuration * 60)
                        SizedBox(
                          height: 55,
                          width: 55,
                          child: ElevatedButton(
                            onPressed: _showExitDialog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF5F5F5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                                side: const BorderSide(
                                    color: Colors.red, width: 2),
                              ),
                              elevation: 0,
                              padding: EdgeInsets.zero,
                            ),
                            child: const Icon(
                              Icons.stop,
                              color: Colors.red,
                              size: 28,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "This Session Progress",
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                const Text("🧱", style: TextStyle(fontSize: 24)),
                                const SizedBox(height: 4),
                                Text(
                                  "Building",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Text("📊", style: TextStyle(fontSize: 24)),
                                const SizedBox(height: 4),
                                Text(
                                  "+$_selectedDuration min",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Stop Session?",
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w700),
        ),
        content: Text(
          "Your progress will be saved, but the session will end.",
          style: GoogleFonts.montserrat(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: GoogleFonts.montserrat()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _stopSession();
            },
            child: Text(
              "Stop",
              style: GoogleFonts.montserrat(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
