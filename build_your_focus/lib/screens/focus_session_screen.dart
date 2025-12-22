import 'dart:async';
import 'package:build_your_focus/screens/building_selection.dart';
import 'package:build_your_focus/screens/completion_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:build_your_focus/building_model/building_model.dart';
import 'package:build_your_focus/services/building_progress_firestore_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:build_your_focus/services/auth_provider.dart';
import 'package:build_your_focus/services/session_firestore_service.dart';

class FocusSessionScreen extends StatefulWidget {
  final Building building;
  const FocusSessionScreen({super.key, required this.building});

  @override
  State<FocusSessionScreen> createState() => _FocusSessionScreenState();
}

class _FocusSessionScreenState extends State<FocusSessionScreen> {
  final BuildingProgressFirestoreService _progressService =
  BuildingProgressFirestoreService();
  final SessionFirestoreService _sessionService = SessionFirestoreService();

  Timer? _timer;
  int _selectedDuration = 60;
  int _remainingSeconds = 1;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = 0;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _completeSession();
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  Future<void> _updateStreak() async {
    final prefs = await SharedPreferences.getInstance();
    const String lastDateKey = 'last_session_date';
    const String streakKey = 'current_streak';

    String today = DateTime.now().toString().split(' ')[0];
    String lastDate = prefs.getString(lastDateKey) ?? "";
    int currentStreak = prefs.getInt(streakKey) ?? 0;

    if (lastDate == today) return;

    String yesterday =
    DateTime.now().subtract(const Duration(days: 1)).toString().split(' ')[0];

    if (lastDate == yesterday) {
      currentStreak++;
    } else {
      currentStreak = 1;
    }

    await prefs.setString(lastDateKey, today);
    await prefs.setInt(streakKey, currentStreak);
  }

  Future<void> _stopSession() async {
    _timer?.cancel();

    final user = context.read<AuthProvider>().user;

    int totalSeconds = _selectedDuration * 60;
    int secondsCompleted = totalSeconds - _remainingSeconds;
    int minutesCompleted = (secondsCompleted / 60).floor();

    if (minutesCompleted > 0 && user != null) {
      await _sessionService.addSession(
        createdBy: user.uid,
        buildingName: widget.building.name,
        durationMinutes: minutesCompleted,
      );

      await _progressService.addMinutes(
        buildingId: widget.building.id,
        minutesToAdd: minutesCompleted,
      );
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

    final user = context.read<AuthProvider>().user;

    await _updateStreak();

    if (user != null) {
      await _sessionService.addSession(
        createdBy: user.uid,
        buildingName: widget.building.name,
        durationMinutes: _selectedDuration,
      );
    }

    await _progressService.addMinutes(
      buildingId: widget.building.id,
      minutesToAdd: _selectedDuration,
    );

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
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, UserBuilding>>(
      stream: _progressService.streamUserBuildings(),
      builder: (context, snapshot) {
        final progressMap = snapshot.data ?? {};
        final userBuilding = progressMap[widget.building.id] ??
            UserBuilding(buildingId: widget.building.id);
        int currentStage =
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
                            widget.building.stages[currentStage]
                                .getImage(height: 150, width: 150),
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
                  _buildControls(),
                  const SizedBox(height: 30),
                  _buildSessionInfo(),
                ],
              ),
            ),
          ),
        );
      },
    );
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
            children: [15, 30, 45, 60, 120]
                .map((m) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: _buildDurationOption(m),
            ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationOption(int minutes) {
    bool isSelected = _selectedDuration == minutes;
    return GestureDetector(
      onTap: _isRunning
          ? null
          : () => setState(() {
        _selectedDuration = minutes;
        _remainingSeconds = minutes * 60;
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
            colors: [Color(0xFFcdffd8), Color(0xFF94b9ff)],
          )
              : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color.fromARGB(150, 156, 188, 245)
                : Colors.grey[300]!,
          ),
        ),
        child: Text(
          "$minutes min",
          style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Row(
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
                    colors: [Color(0xFFcdffd8), Color(0xFF94b9ff)],
                  ),
                  color: _isRunning ? const Color(0xFFF5F5F5) : null,
                  borderRadius: BorderRadius.circular(18),
                  border: _isRunning ? Border.all(color: Colors.black, width: 2) : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(_isRunning ? Icons.pause : Icons.play_arrow, size: 28),
                    const SizedBox(width: 8),
                    Text(
                      _isRunning ? "Pause" : "Start",
                      style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_isRunning || _remainingSeconds != _selectedDuration * 60) ...[
          const SizedBox(width: 16),
          InkWell(
            onTap: _showExitDialog,
            borderRadius: BorderRadius.circular(18),
            child: Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.red, width: 2),
              ),
              child: const Center(
                child: Icon(Icons.stop, color: Colors.red, size: 28),
              ),
            ),
          ),
        ]
      ],
    );
  }

  Widget _buildSessionInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            "This Session Progress",
            style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Column(
                children: [
                  Text("🧱", style: TextStyle(fontSize: 24)),
                  Text("Building", style: TextStyle(fontSize: 12)),
                ],
              ),
              Column(
                children: [
                  const Text("📊", style: TextStyle(fontSize: 24)),
                  Text("+$_selectedDuration min", style: const TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Stop Session?", style: GoogleFonts.montserrat(fontWeight: FontWeight.w700)),
        content: const Text("Your progress will be saved to the cloud."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _stopSession();
            },
            child: Text("Stop", style: GoogleFonts.montserrat(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}