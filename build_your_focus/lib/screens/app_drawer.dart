import 'package:flutter/material.dart';
import 'help_page.dart';

// Local colors for the drawer
const Color kBackground = Color(0xFFF5F6FA);
const Color kAccentBlue = Color(0xFF3B82F6);
const Color kAccentGreen = Color(0xFF10B981);

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Automatically gets the name of the current page
    final String? currentRoute = ModalRoute.of(context)?.settings.name;

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----- TOP HEADER -----
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 30),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Welcome back,",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Username !",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Stay focused with us. 🔥",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(),
            ),
            const SizedBox(height: 8),

            // ----- MAIN MENU ITEMS -----
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const SizedBox(height: 12),

                  _DrawerItem(
                    icon: Icons.home,
                    label: "Home",
                    // Highlight Home if route is explicitly home OR null (app start)
                    isActive: currentRoute == '/home_page' || currentRoute == null,
                    onTap: () {
                      if (currentRoute != '/home_page') {
                        Navigator.pushNamed(context, '/home_page');
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  _DrawerItem(
                    icon: Icons.check_box_outlined,
                    label: "To-Do",
                    isActive: currentRoute == '/to_do_page',
                    onTap: () {
                      if (currentRoute != '/to_do_page') {
                        Navigator.pushNamed(context, '/to_do_page');
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  _DrawerItem(
                    icon: Icons.construction,
                    label: "Construction",
                    isActive: currentRoute == '/construction_page',
                    onTap: () {
                      if (currentRoute != '/construction_page') {
                        Navigator.pushNamed(context, '/construction_page');
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  _DrawerItem(
                    icon: Icons.bar_chart_outlined,
                    label: "Weekly Stats",
                    isActive: currentRoute == '/weekly_stats',
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 16),

                  _DrawerItem(
                    icon: Icons.location_city_outlined,
                    label: "My City",
                    isActive: currentRoute == '/building_page',
                    onTap: () {
                      if (currentRoute != '/building_page') {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/building_page');
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  _DrawerItem(
                    icon: Icons.help_outline,
                    label: "Help & Support",
                    // This now works because we pass the name when pushing!
                    isActive: currentRoute == '/help_page',
                    onTap: () {
                      if (currentRoute != '/help_page') {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HelpPage(),
                            // THIS LINE FIXES EVERYTHING:
                            settings: const RouteSettings(name: '/help_page'),
                          ),
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),

                  const SizedBox(height: 16),

                  _DrawerItem(
                    icon: Icons.settings,
                    label: "Settings",
                    isActive: currentRoute == '/settings_page',
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // ----- BOTTOM BAR -----
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.logout,
                            size: 20, color: Colors.redAccent),
                        SizedBox(width: 6),
                        Text(
                          "Log Out",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/profile_page');
                    },
                    icon: const Icon(Icons.person_outline),
                    label: const Text("Profile"),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isActive;

  const _DrawerItem({
    required this.icon,
    required this.label,
    this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: isActive
            ? const LinearGradient(
          colors: [Color(0xFFcdffd8), Color(0xFF94b9ff)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        )
            : null,
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          child: Row(
            children: [
              Icon(icon, size: 22, color: Colors.black87),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}