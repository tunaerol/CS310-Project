import 'package:flutter/material.dart';
import 'help_page.dart';


// Local colors for the drawer
const Color kBackground = Color(0xFFF5F6FA);
const Color kAccentBlue = Color(0xFF3B82F6);
const Color kAccentGreen = Color(0xFF10B981);

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
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
                    icon: Icons.location_city_outlined,
                    label: "My City",
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 16),
                  _DrawerItem(
                    icon: Icons.check_box_outlined,
                    label: "To-Do",
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 16),
                  _DrawerItem(
                    icon: Icons.shopping_bag_outlined,
                    label: "Shop",
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 16),
                  _DrawerItem(
                    icon: Icons.music_note_outlined,
                    label: "Music",
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 16),
                  _DrawerItem(
                    icon: Icons.bar_chart_outlined,
                    label: "Weekly Stats",
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 16),
                  _DrawerItem(
                    icon: Icons.help_outline,
                    label: "Help & Support",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const HelpPage()));
                    },

                  ),

                  // Big space before settings pill so list fills height
                  const SizedBox(height: 28),

                  // Highlighted settings pill
                  const _SettingsPill(),
                ],
              ),
            ),

            // ----- BOTTOM BAR -----
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                    onPressed: () => Navigator.pop(context),
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

  const _DrawerItem({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14), // MORE SPACING
        child: Row(
          children: [
            Icon(icon, size: 22, color: Colors.black87),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsPill extends StatelessWidget {
  const _SettingsPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFcdffd8), Color(0xFF94b9ff)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => Navigator.pop(context),
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Row(
            children: const [
              Icon(Icons.settings, color: Colors.black),
              SizedBox(width: 12),
              Text(
                "Settings",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
