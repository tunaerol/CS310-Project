
import 'dart:async';
import 'package:build_your_focus/screens/building_selection.dart';
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
  int _selectedDuration = 15;
  int _remainingSeconds = 15*60; //time
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

    int totalSeconds = _selectedDuration * 60;
    int secondsCompleted = totalSeconds - _remainingSeconds;
    int minutesCompleted = (secondsCompleted / 60).ceil();

    if (minutesCompleted > 0) {
      _userDataService.addProgress(widget.building.id, minutesCompleted);
    }

    _goToHome();
  }

  void _goToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => BuildingSelectionScreen()),
          (route) => false,
    );
  }

  void _completeSession() {
    _timer?.cancel();



    _userDataService.addProgress(widget.building.id, _selectedDuration);
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
    int secs = seconds % 60;    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Widget _buildDurationSelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
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
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDurationOption(15),
              SizedBox(width: 2,),
              _buildDurationOption(30),
              SizedBox(width: 2,),
              _buildDurationOption(45),
              SizedBox(width: 2,),
              _buildDurationOption(60),
              SizedBox(width: 2,),
              _buildDurationOption(120),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDurationOption(int minutes) {
    bool isSelected = _selectedDuration == minutes;
    bool canChange = !_isRunning; // Can only change when timer is not running

    return Opacity(
      opacity: canChange ? 1.0 : 0.5,
      child: GestureDetector(
        onTap: canChange ? () {
          setState(() {
            _selectedDuration = minutes;
            _remainingSeconds = minutes * 60;
          });
        } : null,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
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
              color: isSelected ? Color.fromARGB(150, 156, 188, 245) : Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: Text(
            "$minutes min",
            style: GoogleFonts.montserrat(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.black : Colors.black,
            ),
          ),
        ),
      ),
    );
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
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        )
            : null,

      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
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

              SizedBox(height: 10),
              _buildDurationSelector(), // -------------
              SizedBox(height: 20),

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
                                height: 150,
                                width: 150,
                              );
                            }
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
                      child: GestureDetector(
                        onTap: _isRunning ? _pauseTimer : _startTimer,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: _isRunning
                                ? null
                                : const LinearGradient(
                              colors: [Color(0xFFcdffd8), Color(0xFF94b9ff)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            color: _isRunning ? Color(0xFFF5F5F5) : null,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: _isRunning ? Colors.black : Colors.transparent,
                              width: _isRunning ? 2 : 0,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _isRunning ? Icons.pause : Icons.play_arrow,
                                color: _isRunning ? Colors.black : Colors.black,
                                size: 28,
                              ),
                              SizedBox(width: 8),
                              Text(
                                _isRunning ? "Pause" : "Start",
                                style: GoogleFonts.montserrat(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: _isRunning ? Colors.black : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  if (_isRunning || _remainingSeconds != _selectedDuration * 60)
                    SizedBox(
                      height: 55,
                      width: 55,
                      child: ElevatedButton(
                        onPressed: _showExitDialog,
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
