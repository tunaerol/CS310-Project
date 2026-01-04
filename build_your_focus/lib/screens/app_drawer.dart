import 'package:build_your_focus/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'help_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final String? currentRoute = ModalRoute.of(context)?.settings.name;
    final AuthService _authService = AuthService();

    final String userName = _authService.currentUser?.displayName ?? "User";

    const LinearGradient activeGradient = LinearGradient(
      colors: [Color(0xFFcdffd8), Color(0xFF94b9ff)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

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
                children: [
                  const CircleAvatar(
                    radius: 26,
                    backgroundColor: Color(0xFFF5F5F5),
                    child: Icon(Icons.person, size: 30, color: Colors.black54),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Welcome back,",
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "$userName!",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    "Stay focused with us. 🔥",
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(),
            ),

            // ----- MENU ITEMS -----
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ══════ MAIN ══════
                    const _SectionHeader(title: "MAIN"),
                    const SizedBox(height: 8),
                    _DrawerItem(
                      icon: Icons.home_rounded,
                      label: "Home",
                      isActive:
                      currentRoute == '/home_page' || currentRoute == null,
                      onTap: () {
                        if (currentRoute != '/home_page') {
                          Navigator.pushNamed(context, '/home_page');
                        } else {
                          Navigator.pop(context);
                        }
                      },
                    ),
                    const SizedBox(height: 6),
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

                    const SizedBox(height: 20),

                    // ══════ BUILD ══════
                    const _SectionHeader(title: "BUILD"),
                    const SizedBox(height: 8),
                    _DrawerItem(
                      icon: Icons.construction_rounded,
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
                    const SizedBox(height: 6),
                    _DrawerItem(
                      icon: Icons.location_city_rounded,
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

                    const SizedBox(height: 20),

                    // ══════ OTHER ══════
                    const _SectionHeader(title: "OTHER"),
                    const SizedBox(height: 8),
                    _DrawerItem(
                      icon: Icons.help_outline_rounded,
                      label: "Help & Support",
                      isActive: currentRoute == '/help_page',
                      onTap: () {
                        if (currentRoute != '/help_page') {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HelpPage(),
                              settings:
                              const RouteSettings(name: '/help_page'),
                            ),
                          );
                        } else {
                          Navigator.pop(context);
                        }
                      },
                    ),

                    const Spacer(),
                  ],
                ),
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
                  TextButton.icon(
                    onPressed: () async {
                      await _authService.signOut();
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/login_page', (route) => false);
                      }
                    },
                    icon: const Icon(Icons.logout, size: 20, color: Colors.redAccent),
                    label: const Text(
                      "Log Out",
                      style: TextStyle(
                          color: Colors.redAccent, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      gradient:
                      currentRoute == '/profile_page' ? activeGradient : null,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        if (currentRoute != '/profile_page') {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/profile_page');
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(Icons.person_outline),
                      label: const Text("Profile"),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)),
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

// ----- SECTION HEADER -----
class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 2,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFcdffd8), Color(0xFF94b9ff)],
            ),
            borderRadius: BorderRadius.circular(1),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Colors.black38,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 1,
            color: Colors.black12,
          ),
        ),
      ],
    );
  }
}

// ----- DRAWER ITEM -----
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
        borderRadius: BorderRadius.circular(14),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
            child: Row(
              children: [
                Icon(icon, size: 22, color: Colors.black87),
                const SizedBox(width: 14),
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
      ),
    );
  }
}