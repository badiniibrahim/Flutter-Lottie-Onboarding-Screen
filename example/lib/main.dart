import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:lottie_onboarding_screen/lottie_onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        home: LottieOnboardingScreen(
      pages: [
        {
          'title': 'Plan Your Dream trip',
          'subtitle': 'Your Next Adventure Starts Here',
          'description':
              'Create personalized itineraries and discover extraordinary destinations',
          'animation': 'assets/animations/travel_planning.json',
          'gradient': [Color(0xFFF8BDEB), Color(0xFFB4E4FF)],
        },
        {
          'title': 'Explore New Horizons',
          'subtitle': 'A World of Possibilities',
          'description':
              'Find the best activities and places to visit for an unforgettable experience',
          'animation': 'assets/animations/world_exploration.json',
          'gradient': [Color(0xFFB4E4FF), Color(0xFFBBF7D0)],
        },
        {
          'title': 'Travel with Peace of Mind',
          'subtitle': 'Enjoy Every Moment',
          'description':
              'Plan every detail of your trip and make magical memories',
          'animation': 'assets/animations/travel_relax.json',
          'gradient': [Color(0xFFBBF7D0), Color(0xFFFDE68A)],
        },
      ],
      onSkip: () {},
      onFinish: () {},
      indicatorActiveColor: Color(0xFF70B9BE),
      indicatorInactiveColor: Colors.grey,
      skipText: "Skip",
      nextText: "Next",
      startText: "Start",
      skipTextStyle: const TextStyle(
          fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF70B9BE)),
      buttonBackgroundColor: Color(0xFF70B9BE),
      buttonBoxShadow: [
        BoxShadow(
          color: Color(0xFF70B9BE).withAlpha(3),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
      fontFamily: 'Gilroy',
    ));
  }
}
