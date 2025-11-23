import 'package:flutter/material.dart';

const Color kBackground = Color(0xFFF5F6FA);
const Color kAccentBlue = Color(0xFF3B82F6);
const Color kAccentGreen = Color(0xFF10B981);

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help & Support"),
        backgroundColor: Colors.white,
        elevation: 0,
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
              _LinkTile("Getting started"),
              _LinkTile("How focus sessions work"),
              _LinkTile("Managing streaks & coins", isLast: true),
            ],
          ),

          // ----- FAQ -----
          _Section(
            title: "FAQ",
            children: const [
              _LinkTile("What happens if I leave the app?"),
              _LinkTile("Can I change the default duration?"),
              _LinkTile("How do I back up my data?", isLast: true),
            ],
          ),

          // ----- Contact -----
          _Section(
            title: "Contact",
            children: const [
              _LinkTile("Email support", trailing: "support@focusapp.com"),
              _LinkTile("Feedback & suggestions",
                  trailing: "We love hearing from you", isLast: true),
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

  const _LinkTile(this.text, {this.trailing, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(child: Text(text)),
              if (trailing != null)
                Text(trailing!, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1),
      ],
    );
  }
}
