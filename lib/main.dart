// main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suarafe/routes/PageRoutes.dart';
import 'onboarding/onboarding_controller.dart';

int? isviewed = 0;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool onboardingCompleted = await OnboardingHelper.isOnboardingCompleted();

  runApp(MyApp(initialRoute: onboardingCompleted ? '/login' : '/onboarding'));
}

class MyApp extends StatelessWidget {
  final String? initialRoute;

  const MyApp({super.key, this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Suarafe',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: initialRoute ?? '/detail/1',
      getPages: routes,
      // defaultTransition: Transition.fadeIn,
      // transitionDuration: const Duration(milliseconds: 250),
    );
  }
}