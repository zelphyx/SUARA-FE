// pages/onboarding_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'onboarding_controller.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF5BA3D0),
              Color(0xFF4E8A8A),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip Button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: controller.skip,
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              // PageView
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  itemCount: controller.onboardingItems.length,
                  itemBuilder: (context, index) {
                    final item = controller.onboardingItems[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Card Container
                          Container(
                            height: 450,
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Header
                                Column(
                                  children: [
                                    Text(
                                      item.category,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Inter',
                                        color: Colors.grey[500],
                                        letterSpacing: 1.2,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      item.title,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Inter',
                                        color: Color(0xFF2C3E50),
                                        height: 1.3,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      item.description,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Inter',
                                        color: Colors.grey[600],
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),

                                // Illustration
                                Expanded(
                                  child: Center(
                                    child: Image.asset(
                                      item.image,
                                      height: 220,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Icon(
                                          item.icon,
                                          size: 150,
                                          color: const Color(0xFF4E8A8A),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Bottom Section
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Page Indicators
                    Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        controller.onboardingItems.length,
                            (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: controller.currentPage.value == index ? 24 : 8,
                          decoration: BoxDecoration(
                            color: controller.currentPage.value == index
                                ? Colors.white
                                : Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    )),

                    const SizedBox(height: 32),

                    // Next/Get Started Button
                    Obx(() => SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: controller.isLastPage.value
                            ? controller.getStarted
                            : controller.nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF4E8A8A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          controller.isLastPage.value ? 'Get Started' : 'Next',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}