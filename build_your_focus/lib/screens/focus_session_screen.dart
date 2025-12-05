
import 'dart:async';
import 'package:build_your_focus/screens/completion_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:build_your_focus/building_model/building_model.dart';
import 'package:build_your_focus/user_data/user_data_service.dart';
class FocusSessionScreen extends StatefulWidget {
  final Building building;

  const FocusSessionScreen({super.key, required this.building});

  @override
  State<FocusSessionScreen> createState() => _FocusSessionScreenState();
}

class _FocusSessionScreenState extends State<FocusSessionScreen> {
  final UserDataService _userDataService = UserDataService();

  // Timer variables
  Timer? _timer;
  int _remainingSeconds = 25*60; // 25 minutes default
  bool _isRunning = false;
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

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          _sessionMinutes = 25 - (_remainingSeconds / 60).ceil();
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

  void _stopSession() {
    _timer?.cancel();

    // Add progress even if stopped early
    int minutesCompleted = 25 - (_remainingSeconds / 60).ceil();
    if (minutesCompleted > 0) {
      _userDataService.addProgress(widget.building.id, minutesCompleted);
    }

    Navigator.pop(context);
  }

  void _completeSession() {
    _timer?.cancel();

    // Add 25 minutes progress
    _userDataService.addProgress(widget.building.id, 25);

    // Navigate to completion screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CompletionScreen(
          building: widget.building,
          sessionMinutes: 25,
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    UserBuilding userBuilding = _userDataService.getUserBuilding(widget.building.id);
    int currentStage = widget.building.getCurrentStage(userBuilding.progressMinutes);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (_isRunning) {
              _showExitDialog();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          "Focus Session",
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Building name
              Text(
                "Building: ${widget.building.name}",
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 30),

              // Building visualization
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Builder(
                            builder: (context) {
                              int currentStage = widget.building.getCurrentStage(
                                  _userDataService.getUserBuilding(widget.building.id).progressMinutes
                              );

                              return widget.building.stages[currentStage].getImage(
                                height: 180,
                                width: 180,
                              );
                            }
                        ),
                        SizedBox(height: 16),
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

              SizedBox(height: 30),

              // Timer display
              Text(
                _formatTime(_remainingSeconds),
                style: GoogleFonts.montserrat(
                  fontSize: 64,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),

              SizedBox(height: 30),

              // Control buttons
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isRunning ? _pauseTimer : _startTimer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isRunning ? Color(0xFFF5F5F5) : Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                            side: _isRunning ? BorderSide(color: Colors.black, width: 2) : BorderSide.none,
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _isRunning ? Icons.pause : Icons.play_arrow,
                              color: _isRunning ? Colors.black : Colors.white,
                              size: 28,
                            ),
                            SizedBox(width: 8),
                            Text(
                              _isRunning ? "Pause" : "Start",
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: _isRunning ? Colors.black : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  SizedBox(
                    height: 55,
                    width: 55,
                    child: ElevatedButton(
                      onPressed: _stopSession,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF5F5F5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: BorderSide(color: Colors.red, width: 2),
                        ),
                        elevation: 0,
                        padding: EdgeInsets.zero,
                      ),
                      child: Icon(
                        Icons.stop,
                        color: Colors.red,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30),

              // Session info
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5),
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
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              "🧱",
                              style: TextStyle(fontSize: 24),
                            ),
                            SizedBox(height: 4),
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
                            Text(
                              "📊",
                              style: TextStyle(fontSize: 24),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "+25 min",
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
              Navigator.pop(context); // Close dialog
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
