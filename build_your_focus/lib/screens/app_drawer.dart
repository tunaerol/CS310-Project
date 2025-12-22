import 'package:build_your_focus/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'help_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Mevcut sayfanın adını alıyoruz
    final String? currentRoute = ModalRoute.of(context)?.settings.name;
    final AuthService _authService = AuthService();

    final String userName = _authService.currentUser?.displayName ?? "User";

    // Ortak gradyan stilimiz
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
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 30),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Welcome back,",
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "$userName !",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
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

            // ----- MAIN MENU ITEMS -----
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _DrawerItem(
                      icon: Icons.home,
                      label: "Home",
                      isActive: currentRoute == '/home_page' || currentRoute == null,
                      onTap: () {
                        if (currentRoute != '/home_page') {
                          Navigator.pushNamed(context, '/home_page');
                        } else {
                          Navigator.pop(context);
                        }
                      },
                    ),
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
                    _DrawerItem(
                      icon: Icons.settings,
                      label: "Settings",
                      isActive: currentRoute == '/settings_page',
                      onTap: () => Navigator.pop(context),
                    ),
                    _DrawerItem(
                      icon: Icons.help_outline,
                      label: "Help & Support",
                      isActive: currentRoute == '/help_page',
                      onTap: () {
                        if (currentRoute != '/help_page') {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HelpPage(),
                              settings: const RouteSettings(name: '/help_page'),
                            ),
                          );
                        } else {
                          Navigator.pop(context);
                        }
                      },
                    ),
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
                      style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Spacer(),
                  // Profil butonu alanı: Aktifse gradyan çerçeve ekledik
                  Container(
                    decoration: BoxDecoration(
                      gradient: currentRoute == '/profile_page' ? activeGradient : null,
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
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        foregroundColor: Colors.black87,
                        // Gradyan görünebilmesi için butonun kendi rengini şeffaf yaptık (aktifken)
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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