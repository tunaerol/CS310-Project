import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FirstOpening extends StatefulWidget {
  const FirstOpening({super.key});

  @override
  State<FirstOpening> createState() => _FirstOpeningState();
}

class _FirstOpeningState extends State<FirstOpening> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // List of onboarding content
  final List<OnboardingContent> _pages = [
    OnboardingContent(
      title: "Focusing has never\nbeen easier",
      subtitle: "Every moment of focus builds\na new step on your path to your dreams.",
      imagePath: "lib/assets/images/opening1.png",  // cityscape
    ),

    OnboardingContent(
      title: "Time is in\nyour hands",
      subtitle: "Take control of your productivity\none moment at a time.",
      imagePath: "lib/assets/images/opening3.png", // stopwatch
    ),
    OnboardingContent(
      title: "Stay on track,\nachieve your goals",
      subtitle: "Build momentum with every\nfocused session.",
      imagePath: "lib/assets/images/opening2.png", // candle
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 25.0, right: 50.0, left: 50.0),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 100,
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      _pages[_currentPage].title,
                      key: ValueKey<int>(_currentPage),
                      style: GoogleFonts.montserrat(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),

              // Subtitle (motivation sentence)
              SizedBox(
                width: double.infinity,
                height: 60,
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 50),
                    child: Text(
                      _pages[_currentPage].subtitle,
                      key: ValueKey<int>(_currentPage + 100),
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Image PageView
              SizedBox(
                width: double.infinity,
                height: 300,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Image.asset(
                          _pages[index].imagePath,
                          height: 250,
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              // Page Indicators (dots)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                      (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: _currentPage == index ? 24 : 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index ? Colors.black : Colors.grey[400],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 50),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 45,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFcdffd8), Color(0xFF94b9ff)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login_page');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, // makes gradient visible
                      shadowColor: Colors.transparent, // removes default shadow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "Login",
                      style: GoogleFonts.montserrat(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),


              const SizedBox(height: 20),

              // Sign Up Button
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup_page');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Sign Up",
                    style: GoogleFonts.montserrat(
                      fontSize:19,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Model class for onboarding content
class OnboardingContent {
  final String title;
  final String subtitle;
  final String imagePath;

  OnboardingContent({
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });
}