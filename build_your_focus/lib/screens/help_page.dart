import 'package:flutter/material.dart';
import 'app_drawer.dart';

const Color kBackground = Color(0xFFF5F6FA);
const Color kAccentBlue = Color(0xFF3B82F6);
const Color kAccentGreen = Color(0xFF10B981);

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(), // Standard drawer
      appBar: AppBar(
        title: const Text(
          "Help & Support",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      backgroundColor: kBackground,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ----- Gradient Header -----
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFcdffd8), Color(0xFF94b9ff)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: const [
                Icon(Icons.help_outline, color: Colors.black, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Need a hand?\nFind answers or contact support.",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ----- Quick Help -----
          _Section(
            title: "Quick Help",
            children: const [
              _LinkTile(
                "Getting started",
                answer:
                "To get started, simply choose a building from the 'Home' screen, set your timer duration, and hit 'Start'. As you focus, your building will construct itself!",
              ),
              _LinkTile(
                "How focus sessions work",
                answer:
                "A focus session locks your attention on a task. If you leave the app, the session might pause or fail depending on your settings. Complete the timer to earn your building progress.",
              ),
              _LinkTile(
                "Managing streaks & coins",
                isLast: true,
                answer:
                "You earn a streak for every consecutive day you complete at least one session. Coins are earned by completing sessions and can be used to unlock new building designs.",
              ),
            ],
          ),

          // ----- FAQ -----
          _Section(
            title: "FAQ",
            children: const [
              _LinkTile(
                "What happens if I leave the app?",
                answer:
                "If you leave the app during a session, it is marked as failed. You should stay on the focus page in order to not loose your progress. Stay focused!",
              ),
              _LinkTile(
                "Can I change the default duration?",
                answer:
                "Yes! Before starting a session, you can tap on the time selector to choose between 15, 30, 45, 60, or 120 minutes.",
              ),
              _LinkTile(
                "How do I back up my data?",
                isLast: true,
                answer:
                "Your data is automatically synced to your account if you are logged in. Make sure you sign in with your email to prevent data loss.",
              ),
            ],
          ),

          // ----- Contact -----
          _Section(
            title: "Contact",
            children: const [
              _LinkTile(
                "Email support",
                trailing: "support@focusapp.com",
                answer:
                "You can reach our support team directly at support@focusapp.com. We typically respond within 24 hours.",
              ),
              _LinkTile(
                "Feedback & suggestions",
                trailing: "We love hearing from you",
                isLast: true,
                answer:
                "We build this app for you! If you have ideas for new buildings or features, please send us an email or leave a review on the store.",
              ),
            ],
          ),

          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: kBackground,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Text(
              "Tip: Most issues can be solved by checking your session "
                  "settings and notification permissions.",
              style: TextStyle(fontSize: 13),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// -------------------------- Section --------------------------

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            width: double.infinity,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }
}

// -------------------------- Link Tile --------------------------

class _LinkTile extends StatelessWidget {
  final String text;
  final String? trailing;
  final bool isLast;
  final String answer;

  const _LinkTile(this.text,
      {this.trailing, this.isLast = false, required this.answer});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                Text(
                  answer,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 30),

                // --- CHANGED BUTTON ---
                Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFcdffd8), Color(0xFF94b9ff)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "Got it",
                      style: TextStyle(
                        color: Colors.black, // Changed text to black for better contrast
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
                // ---------------------
              ],
            ),
          ),
        );
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(child: Text(text)),
                if (trailing != null)
                  Text(trailing!, style: const TextStyle(fontSize: 12)),
                if (trailing == null)
                  Icon(Icons.chevron_right, size: 16, color: Colors.grey[400])
              ],
            ),
          ),
          if (!isLast) const Divider(height: 1),
        ],
      ),
    );
  }
}