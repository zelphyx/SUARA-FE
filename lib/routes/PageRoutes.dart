import 'package:get/get.dart';
import 'package:suarafe/pages/home.dart';
import 'package:suarafe/pages/login.dart';
import 'package:suarafe/pages/register.dart';
import 'package:suarafe/pages/splash.dart';
import 'package:suarafe/detail/detail_page.dart';
import 'package:suarafe/pages/profile.dart';

import '../onboarding/onboarding_page.dart';
import '../pages/allcampaign.dart';
import '../pages/donation_form.dart';
import '../pages/my_donations.dart';

List<GetPage> routes = [
  GetPage(name: '/', page: () => const Splash()),
  GetPage(name: '/home', page: () => const HomePage()),
  GetPage(name: '/allcampaign', page: () => const AllCampaignPage()),
  GetPage(name: '/login', page: () => const LoginPage()),
  GetPage(name: '/register', page: () => const RegisterPage()),
  GetPage(name: '/onboarding', page: () => const OnboardingPage()),
  GetPage(name: '/my-donations', page: () => const MyDonationsPage()),
  GetPage(name: '/profile', page: () => const ProfilePage()),
  GetPage(
    name: '/donation-form',
    page: () {
      final args = Get.arguments as Map<String, dynamic>?;
      if (args == null) {
        // Fallback jika tidak ada arguments
        return const DonationFormPage(
          campaignId: '',
          campaignTitle: 'Nama Campaign',
          campaignImage: '',
          currentAmount: 0,
          targetAmount: 0,
        );
      }

      // Handle conversion untuk currentAmount dan targetAmount
      double currentAmount = 0.0;
      double targetAmount = 0.0;

      if (args['currentAmount'] != null) {
        final amount = args['currentAmount'];
        if (amount is num) {
          currentAmount = amount.toDouble();
        } else if (amount is String) {
          currentAmount = double.tryParse(amount) ?? 0.0;
        }
      }

      if (args['targetAmount'] != null) {
        final amount = args['targetAmount'];
        if (amount is num) {
          targetAmount = amount.toDouble();
        } else if (amount is String) {
          targetAmount = double.tryParse(amount) ?? 0.0;
        }
      }

      return DonationFormPage(
        campaignId: args['campaignId']?.toString() ?? '',
        campaignTitle: args['campaignTitle']?.toString() ?? 'Nama Campaign',
        campaignImage: args['campaignImage']?.toString() ?? '',
        currentAmount: currentAmount,
        targetAmount: targetAmount,
      );
    },
  ),
  GetPage(
    name: '/detail/:id',
    page: () {
      final id = Get.parameters['id'] ?? '';
      return DetailPage(id: id);
    },
  ),
];