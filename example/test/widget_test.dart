import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie_onboarding_screen/lottie_onboarding_screen.dart';
import 'package:mockito/mockito.dart';

class MockCallback extends Mock {
  void call();
}

void main() {
  group('OnboardingScreen Tests', () {
    late MockCallback onSkip;
    late MockCallback onFinish;

    setUp(() {
      onSkip = MockCallback();
      onFinish = MockCallback();
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: LottieOnboardingScreen(
          pages: [
            {
              'title': 'Welcome!',
              'subtitle': 'Let’s get started',
              'description': 'This is an introduction screen',
              'animation': 'assets/animations/example.json',
              'gradient': [Colors.blue, Colors.green]
            },
            {
              'title': 'Explore!',
              'subtitle': 'Discover features',
              'description': 'Explore the app’s functionalities',
              'animation': 'assets/animations/example2.json',
              'gradient': [Colors.red, Colors.orange]
            }
          ],
          onSkip: onSkip,
          onFinish: onFinish,
        ),
      );
    }

    testWidgets('renders onboarding pages correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('Welcome!'), findsOneWidget);
      expect(find.text('Let’s get started'), findsOneWidget);
      expect(find.text('This is an introduction screen'), findsOneWidget);
    });

    testWidgets('navigates between pages using next button',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      expect(find.text('Explore!'), findsOneWidget);
      expect(find.text('Discover features'), findsOneWidget);
    });

    testWidgets('calls onSkip when Skip button is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();

      verify(onSkip()).called(1);
    });

    testWidgets('calls onFinish when Start button is tapped on last page',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Start'));
      await tester.pumpAndSettle();

      verify(onFinish()).called(1);
    });
  });
}
