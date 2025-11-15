// controllers/onboarding_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_model.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final currentPage = 0.obs;
  final isLastPage = false.obs;

  final List<OnboardingModel> onboardingItems = [
    OnboardingModel(
      category: 'TEAMWORK',
      title: 'Enable Efficient\nTeamwork',
      description: 'Fugiat nulla pariatur excepteur sint\noccaecat Lorem irure incididunt.',
      image: 'asset/onboarding1.png',
      icon: Icons.people_outline,
    ),
    OnboardingModel(
      category: 'PRODUCTIVITY',
      title: 'Save Time For\nSmarter Work',
      description: 'Fugiat nulla pariatur excepteur sint\noccaecat Lorem irure incididunt.',
      image: 'asset/onboarding2.png',
      icon: Icons.access_time_outlined,
    ),
    OnboardingModel(
      category: 'COLLABORATION',
      title: 'Put Collaboration\nIn Motion',
      description: 'Fugiat nulla pariatur excepteur sint\noccaecat Lorem irure incididunt.',
      image: 'asset/onboarding3.png',
      icon: Icons.business_center_outlined,
    ),
  ];

  void onPageChanged(int index) {
    currentPage.value = index;
    isLastPage.value = index == onboardingItems.length - 1;
  }

  void nextPage() {
    if (currentPage.value < onboardingItems.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> skip() async {
    await _completeOnboarding();
  }

  Future<void> getStarted() async {
    await _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    // Simpan status bahwa user sudah melihat onboarding
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);

    // Navigate ke login page
    Get.offAllNamed('/login');
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

// Helper method untuk cek apakah onboarding sudah selesai
class OnboardingHelper {
  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_completed') ?? false;
  }

  static Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('onboarding_completed');
  }
}