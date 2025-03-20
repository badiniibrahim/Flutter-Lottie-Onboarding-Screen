import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

/// A widget that represents an onboarding screen with a series of pages to guide users through an introductory experience.
///
/// The [pages], [onSkip], and [onFinish] parameters must not be null.
///
/// The [indicatorActiveColor], [indicatorInactiveColor], [fontFamily], [skipText], [nextText], [startText]
/// parameters control the appearance and behavior of the page indicator and navigation elements.
///
/// Example usage:
/// ```dart
/// OnboardingScreen(
///   pages: [
///     {
///       'title': 'Welcome!',
///       'subtitle': 'Let’s get started',
///       'description': 'This is an introduction screen',
///       'animation': 'assets/animations/example.json',
///     },
///   ],
///   onSkip: () => Navigator.pushNamed(context, '/home'),
///   onFinish: () => Navigator.pushNamed(context, '/home'),
///   indicatorActiveColor: Colors.blue,
///   indicatorInactiveColor: Colors.grey,
///   skipText: "Skip",
///   nextText: "Next",
///   startText: "Start",
/// );
/// ```
class OnboardingScreen extends StatefulWidget {
  /// List of onboarding pages containing title, subtitle, description, and animation.
  final List<Map<String, dynamic>> pages;

  /// Callback triggered when the user skips the onboarding process.
  final VoidCallback onSkip;

  /// Callback triggered when the user completes the onboarding process.
  final VoidCallback onFinish;

  /// Color of the active page indicator.
  final Color indicatorActiveColor;

  /// Color of the inactive page indicators.
  final Color indicatorInactiveColor;

  /// Custom font family for text styling.
  final String fontFamily;

  /// Text for the 'Skip' button.
  final String skipText;

  /// Text for the 'Next' button.
  final String nextText;

  /// Text for the 'Start' button when onboarding is completed.
  final String startText;

  // Style for the 'Skip' button text.
  final TextStyle skipTextStyle;

  /// Background color for the action button.
  final Color buttonBackgroundColor;

  /// Box shadow styling for the action button.
  final List<BoxShadow> buttonBoxShadow;

  // Primary color used for various UI elements.
  final Color primaryColor;

  const OnboardingScreen({
    super.key,
    required this.pages,
    required this.onSkip,
    required this.onFinish,
    this.indicatorActiveColor = const Color(0xFF70B9BE),
    this.indicatorInactiveColor = Colors.grey,
    this.fontFamily = 'Arial',
    this.skipText = 'Skip',
    this.nextText = 'Next',
    this.startText = 'Start',
    this.skipTextStyle = const TextStyle(
        fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF70B9BE)),
    this.buttonBackgroundColor = const Color(0xFF70B9BE),
    this.primaryColor = const Color(0xFF70B9BE),
    this.buttonBoxShadow = const [
      BoxShadow(
        color: Colors.blue,
        blurRadius: 20,
        offset: Offset(0, 10),
      ),
    ],
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  /// Handles page change animation and updates the current page index.
  void _onPageChanged(int page) {
    _animationController.reset();
    setState(() {
      _currentPage = page;
    });
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated gradient background
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: widget.pages[_currentPage]['gradient'],
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withAlpha((0.9 * 255).toInt()),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Header with skip button
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // App logo
                      FadeInLeft(
                        child: Container(
                            padding: const EdgeInsets.all(12),
                            child: SizedBox.shrink()),
                      ),
                      // Skip button
                      FadeInRight(
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: InkWell(
                            onTap: widget.onSkip,
                            child: Text(
                              widget.skipText,
                              style: widget.skipTextStyle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Page content
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: widget.pages.length,
                    itemBuilder: (context, index) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildPage(
                          title: widget.pages[index]['title'],
                          subtitle: widget.pages[index]['subtitle'],
                          description: widget.pages[index]['description'],
                          animation: widget.pages[index]['animation'],
                          primaryColor: widget.primaryColor,
                          fontFamily: widget.fontFamily,
                        ),
                      );
                    },
                  ),
                ),

                // Navigation and progress
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                    boxShadow: widget.buttonBoxShadow,
                  ),
                  child: Column(
                    children: [
                      // Page indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          widget.pages.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 8,
                            width: _currentPage == index ? 24 : 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? widget.indicatorActiveColor
                                  : widget.indicatorInactiveColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Action button
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: widget.buttonBoxShadow,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_currentPage < widget.pages.length - 1) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeOutCubic,
                              );
                            } else {
                              widget.onFinish();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.buttonBackgroundColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _currentPage < widget.pages.length - 1
                                    ? widget.nextText
                                    : widget.startText,
                                style: TextStyle(
                                  fontFamily: widget.fontFamily,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds an individual onboarding page with an animation, title, subtitle, and description.
  Widget _buildPage(
      {required String title,
      required String subtitle,
      required String description,
      required String animation,
      required Color primaryColor,
      required String fontFamily}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: Get.height * 0.35,
            margin: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withAlpha(
                      (0.1 * 255).toInt()), // Conversion de 0.1 en alpha
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Lottie.asset(
                animation,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  primaryColor.withAlpha(
                      (0.02 * 255).toInt()), // Approximation de 5% (0.02)
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: primaryColor
                      .withAlpha((0.004 * 255).toInt()), // Approximation de 1%
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor.withAlpha(
                        (0.004 * 255).toInt()), // Approximation de 1%
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                      fontFamily: fontFamily,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontFamily: fontFamily,
                    height: 1.2,
                  ),
                ),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                    fontFamily: fontFamily,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
