import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import '../services/building_progress_provider.dart';
import '../models/focus_session_model.dart';
import 'app_drawer.dart';

const Color _primaryColor = Color(0xFF3B82F6);
const Color _iconBackgroundColor = Color(0xFFEEF2FF);
const Color _barChartGray = Color(0xFFE5E7EB);

class ConstructionProgressScreen extends StatefulWidget {
  const ConstructionProgressScreen({super.key});

  @override
  State<ConstructionProgressScreen> createState() =>
      _ConstructionProgressScreenState();
}

class _ConstructionProgressScreenState extends State<ConstructionProgressScreen> {
  int _currentStreak = 0;
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    _loadCurrentStreak();
  }

  Future<void> _loadCurrentStreak() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentStreak = prefs.getInt('current_streak') ?? 0;
    });
  }

  String _getWeekRange() {
    DateTime now = DateTime.now();
    DateTime monday = now.subtract(Duration(days: now.weekday - 1));
    DateTime sunday = monday.add(const Duration(days: 6));
    List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return "${months[monday.month - 1]} ${monday.day} - ${months[sunday.month - 1]} ${sunday.day}";
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.apartment_outlined, color: Colors.amber, size: 28),
                SizedBox(width: 8),
                Text('Weekly Construction', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 4),
            Text(_getWeekRange(), style: const TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500)),
          ],
        ),
        Row(
          children: [
            _buildNavButton(Icons.arrow_back_ios_new),
            const SizedBox(width: 8),
            _buildNavButton(Icons.arrow_forward_ios),
          ],
        ),
      ],
    );
  }

  Widget _buildNavButton(IconData icon) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(4),
      child: Icon(icon, size: 16, color: Colors.grey),
    );
  }

  Widget _buildProgressCards(List<FocusSessionModel> sessions) {
    int totalMinutes = sessions.fold(0, (sum, s) => sum + s.duration);
    String totalTimeStr = "${totalMinutes ~/ 60}h ${totalMinutes % 60}m";

    int sessionCount = sessions.length;

    int longest = sessions.isEmpty ? 0 : sessions.map((s) => s.duration).reduce(max);
    String longestStr = longest >= 60 ? "${longest ~/ 60}h ${longest % 60}m" : "${longest}m";

    return Column(
      children: [
        ProgressCard(title: 'Total Construction Time', value: totalTimeStr, icon: Icons.apartment_outlined, iconColor: Colors.blue),
        const SizedBox(height: 16),
        ProgressCard(title: 'Daily Blueprint', value: '$sessionCount sessions', icon: Icons.handyman_outlined, iconColor: Colors.redAccent),
        const SizedBox(height: 16),
        ProgressCard(title: 'Current Build Streak', value: '$_currentStreak days', icon: Icons.local_fire_department_outlined, iconColor: Colors.orange),
        const SizedBox(height: 16),
        ProgressCard(title: 'Longest Work Session', value: longestStr, icon: Icons.timer_outlined, iconColor: Colors.purple),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final progressProvider = Provider.of<BuildingProgressProvider>(context);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Construction Progress'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: StreamBuilder<List<FocusSessionModel>>(
        stream: progressProvider.getWeeklySessions(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print("DEBUG FIRESTORE ERROR: ${snapshot.error}");
            return const Center(child: Text('Error loading progress'));
          }

          final sessions = snapshot.data ?? [];

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildProgressCards(sessions),
                  const SizedBox(height: 24),
                  FocusStatisticsCard(sessions: sessions),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProgressCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const ProgressCard({super.key, required this.title, required this.value, required this.icon, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 3))]),
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _primaryColor)),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: _iconBackgroundColor, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 28, color: iconColor),
          ),
        ],
      ),
    );
  }
}

class FocusStatisticsCard extends StatelessWidget {
  final List<FocusSessionModel> sessions;
  const FocusStatisticsCard({super.key, required this.sessions});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 3))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Focus Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          InteractiveFocusBarChart(sessions: sessions),
        ],
      ),
    );
  }
}

class InteractiveFocusBarChart extends StatefulWidget {
  final List<FocusSessionModel> sessions;
  const InteractiveFocusBarChart({super.key, required this.sessions});

  @override
  State<InteractiveFocusBarChart> createState() => _InteractiveFocusBarChartState();
}

class _InteractiveFocusBarChartState extends State<InteractiveFocusBarChart> {
  int _selectedIndex = 0;
  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  List<List<dynamic>> _getDynamicWeeklyData() {
    List<List<dynamic>> dynamicData = List.generate(7, (index) => [0.0, "0h 0m", "0 sessions"]);
    for (var session in widget.sessions) {
      int dayIndex = session.date.weekday - 1;
      if (dayIndex >= 0 && dayIndex < 7) {
        int currentMins = int.parse(dynamicData[dayIndex][1].split('h ')[0]) * 60 +
            int.parse(dynamicData[dayIndex][1].split('h ')[1].split('m')[0]);
        int totalMins = currentMins + session.duration;

        dynamicData[dayIndex][0] = (totalMins / 240).clamp(0.0, 1.0);
        dynamicData[dayIndex][1] = "${totalMins ~/ 60}h ${totalMins % 60}m";

        int sCount = int.parse(dynamicData[dayIndex][2].split(' ')[0]) + 1;
        dynamicData[dayIndex][2] = "$sCount sessions";
      }
    }
    return dynamicData;
  }

  @override
  Widget build(BuildContext context) {
    const double chartMaxHeight = 150;
    final weeklyData = _getDynamicWeeklyData();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildYAxisLabels(chartMaxHeight),
        const SizedBox(width: 8),
        Expanded(
          child: SizedBox(
            height: chartMaxHeight + 40,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                ..._buildGridLines(chartMaxHeight),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(weeklyData.length, (index) {
                        return _buildBar(index: index, data: weeklyData[index], maxChartHeight: chartMaxHeight);
                      }),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(_days.length, (index) => Text(_days[index], style: const TextStyle(fontSize: 12, color: Colors.black))),
                    ),
                  ],
                ),
                if (_selectedIndex != -1) _buildTooltip(index: _selectedIndex, data: weeklyData[_selectedIndex], maxChartHeight: chartMaxHeight),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBar({required int index, required List<dynamic> data, required double maxChartHeight}) {
    final double normalizedHeight = data[0] * maxChartHeight;
    final bool isSelected = index == _selectedIndex;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedIndex = index),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 16,
            height: normalizedHeight,
            decoration: BoxDecoration(color: isSelected ? _primaryColor : _barChartGray, borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4))),
          ),
        ),
      ),
    );
  }

  Widget _buildYAxisLabels(double height) {
    return SizedBox(height: height + 40, child: Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [Text('4h', style: TextStyle(fontSize: 12, color: Colors.grey)), Text('3h', style: TextStyle(fontSize: 12, color: Colors.grey)),
          Text('2h', style: TextStyle(fontSize: 12, color: Colors.grey)), Text('1h', style: TextStyle(fontSize: 12, color: Colors.grey)), Text('0h', style: TextStyle(fontSize: 12, color: Colors.grey))]));
  }

  List<Widget> _buildGridLines(double height) {
    return List.generate(4, (i) => Positioned(bottom: height * ((i + 1) / 4), left: 0, right: 0, child: Container(height: 1, color: Colors.grey.shade200)));
  }

  Widget _buildTooltip({required int index, required List<dynamic> data, required double maxChartHeight}) {
    final double normalizedHeight = data[0] * maxChartHeight;
    final double leftOffset = (index * (MediaQuery.of(context).size.width - 62) / 7) + 20;
    return Positioned(
      bottom: normalizedHeight + 16,
      left: leftOffset,
      child: Transform.translate(
        offset: const Offset(-40, 0),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 1, blurRadius: 5)]),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_days[index], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Row(children: [const Icon(Icons.watch_later_outlined, size: 14, color: _primaryColor), const SizedBox(width: 4), Text(data[1] as String, style: const TextStyle(color: _primaryColor, fontWeight: FontWeight.bold))]),
            Row(children: [const Icon(Icons.apartment_outlined, size: 14, color: Colors.grey), const SizedBox(width: 4), Text(data[2] as String, style: const TextStyle(color: Colors.grey))]),
          ]),
        ),
      ),
    );
  }
}