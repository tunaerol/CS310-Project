import 'package:flutter/material.dart';\
\
const Color _primaryColor = Color(0xFF3B82F6);\
const Color _iconBackgroundColor = Color(0xFFEEF2FF);\
const Color _barChartGray = Color(0xFFE5E7EB);\
\
class ConstructionProgressScreen extends StatefulWidget \{\
  const ConstructionProgressScreen(\{super.key\});\
\
  @override\
  State<ConstructionProgressScreen> createState() =>\
      _ConstructionProgressScreenState();\
\}\
\
class _ConstructionProgressScreenState\
    extends State<ConstructionProgressScreen> \{\
  Widget _buildHeader() \{\
    return Row(\
      mainAxisAlignment: MainAxisAlignment.spaceBetween,\
      children: [\
        Column(\
          crossAxisAlignment: CrossAxisAlignment.start,\
          children: [\
            Row(\
              children: const [\
                Icon(Icons.apartment_outlined,\
                    color: Colors.amber, size: 28),\
                SizedBox(width: 8),\
                Text(\
                  'Weekly Construction',\
                  style: TextStyle(\
                    fontSize: 24,\
                    fontWeight: FontWeight.bold,\
                  ),\
                ),\
              ],\
            ),\
            const SizedBox(height: 4),\
            const Text(\
              'Nov 24 - Nov 30',\
              style: TextStyle(\
                fontSize: 16,\
                color: Colors.grey,\
                fontWeight: FontWeight.w500,\
              ),\
            ),\
          ],\
        ),\
        Row(\
          children: [\
            Container(\
              decoration: BoxDecoration(\
                border: Border.all(color: Colors.grey.shade300),\
                borderRadius: BorderRadius.circular(8),\
              ),\
              padding: const EdgeInsets.all(4),\
              child: const Icon(Icons.arrow_back_ios_new,\
                  size: 16, color: Colors.grey),\
            ),\
            const SizedBox(width: 8),\
            Container(\
              decoration: BoxDecoration(\
                border: Border.all(color: Colors.grey.shade300),\
                borderRadius: BorderRadius.circular(8),\
              ),\
              padding: const EdgeInsets.all(4),\
              child: const Icon(Icons.arrow_forward_ios,\
                  size: 16, color: Colors.grey),\
            ),\
          ],\
        ),\
      ],\
    );\
  \}\
\
  Widget _buildProgressCards(BuildContext context) \{\
    return Column(\
      children: const [\
        ProgressCard(\
          title: 'Total Construction Time',\
          value: '15h 30m',\
          icon: Icons.apartment_outlined,\
          iconColor: Colors.blue,\
        ),\
        SizedBox(height: 16),\
        ProgressCard(\
          title: 'Daily Blueprint',\
          value: '2h 13m',\
          icon: Icons.handyman_outlined,\
          iconColor: Colors.redAccent,\
        ),\
        SizedBox(height: 16),\
        ProgressCard(\
          title: 'Longest Build Streak',\
          value: '5 days',\
          icon: Icons.local_fire_department_outlined,\
          iconColor: Colors.orange,\
        ),\
        SizedBox(height: 16),\
        ProgressCard(\
          title: 'Longest Work Session',\
          value: '2h',\
          icon: Icons.timer_outlined,\
          iconColor: Colors.purple,\
        ),\
      ],\
    );\
  \}\
\
  @override\
  Widget build(BuildContext context) \{\
    return Scaffold(\
      drawer: const Drawer(), // your group's drawer\
      appBar: AppBar(\
        title: const Text('Construction Progress'),\
        backgroundColor: Colors.white,\
        elevation: 0,\
        iconTheme: const IconThemeData(color: Colors.black),\
        leading: Builder(\
          builder: (context) => IconButton(\
            icon: const Icon(Icons.menu),\
            tooltip: '', // removes "open navigation menu"\
            onPressed: () => Scaffold.of(context).openDrawer(),\
          ),\
        ),\
      ),\
      body: SingleChildScrollView(\
        child: Padding(\
          padding: const EdgeInsets.all(16.0),\
          child: Column(\
            crossAxisAlignment: CrossAxisAlignment.start,\
            children: [\
              const SizedBox(height: 32),\
              _buildHeader(),\
              const SizedBox(height: 24),\
              _buildProgressCards(context),\
              const SizedBox(height: 24),\
              const FocusStatisticsCard(),\
              const SizedBox(height: 100),\
            ],\
          ),\
        ),\
      ),\
    );\
  \}\
\}\
\
class ProgressCard extends StatelessWidget \{\
  final String title;\
  final String value;\
  final IconData icon;\
  final Color iconColor;\
\
  const ProgressCard(\{\
    super.key,\
    required this.title,\
    required this.value,\
    required this.icon,\
    required this.iconColor,\
  \});\
\
  @override\
  Widget build(BuildContext context) \{\
    return Container(\
      decoration: BoxDecoration(\
        color: Colors.white,\
        borderRadius: BorderRadius.circular(15),\
        boxShadow: [\
          BoxShadow(\
            color: Colors.grey.withOpacity(0.05),\
            spreadRadius: 1,\
            blurRadius: 5,\
            offset: const Offset(0, 3),\
          ),\
        ],\
      ),\
      padding: const EdgeInsets.all(20),\
      child: Row(\
        mainAxisAlignment: MainAxisAlignment.spaceBetween,\
        children: [\
          Column(\
            crossAxisAlignment: CrossAxisAlignment.start,\
            children: [\
              Text(\
                title,\
                style: const TextStyle(\
                  fontSize: 16,\
                  color: Colors.black54,\
                  fontWeight: FontWeight.w500,\
                ),\
              ),\
              const SizedBox(height: 4),\
              Text(\
                value,\
                style: const TextStyle(\
                  fontSize: 22,\
                  fontWeight: FontWeight.bold,\
                  color: _primaryColor,\
                ),\
              ),\
            ],\
          ),\
          Container(\
            padding: const EdgeInsets.all(12),\
            decoration: BoxDecoration(\
              color: _iconBackgroundColor,\
              borderRadius: BorderRadius.circular(10),\
            ),\
            child: Icon(\
              icon,\
              size: 28,\
              color: iconColor,\
            ),\
          ),\
        ],\
      ),\
    );\
  \}\
\}\
\
class FocusStatisticsCard extends StatelessWidget \{\
  const FocusStatisticsCard(\{super.key\});\
\
  @override\
  Widget build(BuildContext context) \{\
    return Container(\
      padding: const EdgeInsets.all(20),\
      decoration: BoxDecoration(\
        color: Colors.white,\
        borderRadius: BorderRadius.circular(15),\
        boxShadow: [\
          BoxShadow(\
            color: Colors.grey.withOpacity(0.05),\
            spreadRadius: 1,\
            blurRadius: 5,\
            offset: const Offset(0, 3),\
          ),\
        ],\
      ),\
      child: Column(\
        crossAxisAlignment: CrossAxisAlignment.start,\
        children: const [\
          Text(\
            'Focus Statistics',\
            style: TextStyle(\
              fontSize: 18,\
              fontWeight: FontWeight.bold,\
            ),\
          ),\
          SizedBox(height: 20),\
          InteractiveFocusBarChart(),\
        ],\
      ),\
    );\
  \}\
\}\
\
class InteractiveFocusBarChart extends StatefulWidget \{\
  const InteractiveFocusBarChart(\{super.key\});\
\
  @override\
  State<InteractiveFocusBarChart> createState() =>\
      _InteractiveFocusBarChartState();\
\}\
\
class _InteractiveFocusBarChartState extends State<InteractiveFocusBarChart> \{\
  final List<List<dynamic>> _weeklyData = [\
    [0.75, "3h 5m", "3 sessions"],\
    [1.0, "4h 0m", "4 sessions"],\
    [0.65, "2h 45m", "3 sessions"],\
    [0.85, "3h 25m", "4 sessions"],\
    [0.55, "2h 15m", "2 sessions"],\
    [0.0, "0h 0m", "0 sessions"],\
    [0.0, "0h 0m", "0 sessions"],\
  ];\
\
  int _selectedIndex = 0;\
  final List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];\
\
  @override\
  Widget build(BuildContext context) \{\
    const double chartMaxHeight = 150;\
\
    return Row(\
      crossAxisAlignment: CrossAxisAlignment.end,\
      children: [\
        _buildYAxisLabels(chartMaxHeight),\
        const SizedBox(width: 8),\
        Expanded(\
          child: SizedBox(\
            height: chartMaxHeight + 40,\
            child: Stack(\
              clipBehavior: Clip.none,\
              alignment: Alignment.bottomCenter,\
              children: [\
                ..._buildGridLines(chartMaxHeight),\
                Column(\
                  mainAxisAlignment: MainAxisAlignment.end,\
                  children: [\
                    Row(\
                      mainAxisAlignment: MainAxisAlignment.spaceAround,\
                      crossAxisAlignment: CrossAxisAlignment.end,\
                      children: List.generate(_weeklyData.length, (index) \{\
                        return _buildBar(\
                          index: index,\
                          data: _weeklyData[index],\
                          maxChartHeight: chartMaxHeight,\
                        );\
                      \}),\
                    ),\
                    const SizedBox(height: 8),\
                    Row(\
                      mainAxisAlignment: MainAxisAlignment.spaceAround,\
                      children: List.generate(\
                        _days.length,\
                        (index) => Text(\
                          _days[index],\
                          style: const TextStyle(\
                              fontSize: 12, color: Colors.black),\
                        ),\
                      ),\
                    ),\
                  ],\
                ),\
                if (_selectedIndex != -1)\
                  _buildTooltip(\
                    index: _selectedIndex,\
                    data: _weeklyData[_selectedIndex],\
                    maxChartHeight: chartMaxHeight,\
                  ),\
              ],\
            ),\
          ),\
        ),\
      ],\
    );\
  \}\
\
  Widget _buildBar(\{\
    required int index,\
    required List<dynamic> data,\
    required double maxChartHeight,\
  \}) \{\
    final double normalizedHeight = data[0] * maxChartHeight;\
    final bool isSelected = index == _selectedIndex;\
\
    return Expanded(\
      child: GestureDetector(\
        onTap: () \{\
          setState(() => _selectedIndex = index);\
        \},\
        child: Align(\
          alignment: Alignment.bottomCenter,\
          child: AnimatedContainer(\
            duration: const Duration(milliseconds: 200),\
            width: 16,\
            height: normalizedHeight,\
            decoration: BoxDecoration(\
              color: isSelected ? _primaryColor : _barChartGray,\
              borderRadius: const BorderRadius.only(\
                topLeft: Radius.circular(4),\
                topRight: Radius.circular(4),\
              ),\
            ),\
          ),\
        ),\
      ),\
    );\
  \}\
\
  Widget _buildYAxisLabels(double height) \{\
    return SizedBox(\
      height: height + 40,\
      child: Column(\
        crossAxisAlignment: CrossAxisAlignment.end,\
        mainAxisAlignment: MainAxisAlignment.spaceBetween,\
        children: const [\
          Text('4h', style: TextStyle(fontSize: 12, color: Colors.grey)),\
          Text('3h', style: TextStyle(fontSize: 12, color: Colors.grey)),\
          Text('2h', style: TextStyle(fontSize: 12, color: Colors.grey)),\
          Text('1h', style: TextStyle(fontSize: 12, color: Colors.grey)),\
          Text('0h', style: TextStyle(fontSize: 12, color: Colors.grey)),\
        ],\
      ),\
    );\
  \}\
\
  List<Widget> _buildGridLines(double height) \{\
    return List.generate(4, (i) \{\
      final double verticalPosition = height * ((i + 1) / 4);\
      return Positioned(\
        bottom: verticalPosition,\
        left: 0,\
        right: 0,\
        child: Container(\
          height: 1,\
          color: Colors.grey.shade200,\
        ),\
      );\
    \});\
  \}\
\
  Widget _buildTooltip(\{\
    required int index,\
    required List<dynamic> data,\
    required double maxChartHeight,\
  \}) \{\
    final double normalizedHeight = data[0] * maxChartHeight;\
    final screenWidth = MediaQuery.of(context).size.width;\
    const double chartAreaPadding = 16 * 2 + 30;\
    final double chartAreaWidth = screenWidth - chartAreaPadding;\
    final double barSlotWidth = chartAreaWidth / 7;\
    final double leftOffset = (index * barSlotWidth) + (barSlotWidth / 2);\
\
    return Positioned(\
      bottom: normalizedHeight + 16,\
      left: leftOffset,\
      child: Transform.translate(\
        offset: const Offset(-50, 0),\
        child: Container(\
          padding: const EdgeInsets.all(12),\
          decoration: BoxDecoration(\
            color: Colors.white,\
            borderRadius: BorderRadius.circular(8),\
            boxShadow: [\
              BoxShadow(\
                color: Colors.black.withOpacity(0.1),\
                spreadRadius: 1,\
                blurRadius: 5,\
              ),\
            ],\
          ),\
          child: Column(\
            crossAxisAlignment: CrossAxisAlignment.start,\
            children: [\
              Text(\
                _days[index],\
                style: const TextStyle(\
                    fontWeight: FontWeight.bold, fontSize: 14),\
              ),\
              const SizedBox(height: 4),\
              Row(\
                children: [\
                  const Icon(Icons.watch_later_outlined,\
                      size: 14, color: _primaryColor),\
                  const SizedBox(width: 4),\
                  Text(\
                    data[1] as String,\
                    style: const TextStyle(\
                      color: _primaryColor,\
                      fontWeight: FontWeight.bold,\
                    ),\
                  ),\
                ],\
              ),\
              const SizedBox(height: 4),\
              Row(\
                children: [\
                  const Icon(Icons.apartment_outlined,\
                      size: 14, color: Colors.grey),\
                  const SizedBox(width: 4),\
                  Text(\
                    data[2] as String,\
                    style: const TextStyle(color: Colors.grey),\
                  ),\
                ],\
              ),\
            ],\
          ),\
        ),\
      ),\
    );\
  \}\
\}\
}