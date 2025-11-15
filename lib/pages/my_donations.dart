import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../detail/reusable_component.dart';
import '../shared/widgets/bottom_navbar.dart';
import '../controllers/my_donations_controller.dart';
import '../models/donation_model.dart';
import '../models/campaign_model.dart';

class MyDonationsPage extends StatelessWidget {
  const MyDonationsPage({super.key});

  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(0)}jt';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}rb';
    }
    return amount.toStringAsFixed(0);
  }

  String _formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyDonationsController());
    return Obx(() {
      if (controller.isLoading.value) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'Donasiku',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
                color: Colors.black87,
              ),
            ),
          ),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.error.value != null) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'Donasiku',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
                color: Colors.black87,
              ),
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.error.value ?? 'Error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.fetchMyDonations(),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        );
      }

      if (controller.donations.isEmpty) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'Donasiku',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
                color: Colors.black87,
              ),
            ),
          ),
          body: const Center(
            child: Text('Belum ada donasi'),
          ),
          bottomNavigationBar: CustomBottomNavBar(
            items: [
              BottomNavItem(
                label: 'Donasi',
                icon: Icons.favorite_outline,
                routeName: '/home',
              ),
              BottomNavItem(
                label: 'Galang Dana',
                icon: Icons.campaign,
                routeName: '/allcampaign',
              ),
              BottomNavItem(
                label: 'Donasiku',
                icon: Icons.receipt,
                routeName: '/my-donations',
              ),
              BottomNavItem(
                label: 'Akun',
                icon: Icons.person_outline,
                routeName: '/profile',
              ),
            ],
            onItemTapped: (route) {
              if (route != Get.currentRoute) {
                Get.offNamed(route);
              }
            },
          ),
        );
      }

      // Group donations by campaign
      final donationsByCampaign = controller.donationsByCampaign;
      
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Donasiku',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
              color: Colors.black87,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ...donationsByCampaign.entries.map((entry) {
                final campaignId = entry.key;
                final campaignDonations = entry.value;
                final totalDonation = controller.getTotalDonationForCampaign(campaignId);
                
                return FutureBuilder<CampaignModel?>(
                  future: controller.getCampaignDetails(campaignId),
                  builder: (context, snapshot) {
                    final campaign = snapshot.data;
                    if (campaign == null && snapshot.connectionState != ConnectionState.waiting) {
                      return const SizedBox.shrink();
                    }
                    
                    final progress = campaign?.progress ?? 0.0;
                    final currentAmount = campaign?.currentAmount ?? 0.0;
                    final targetAmount = campaign?.targetAmount ?? 0.0;
                    
                    return FutureBuilder<List<CampaignUpdate>>(
                      future: controller.getCampaignUpdates(campaignId),
                      builder: (context, updatesSnapshot) {
                        final updates = updatesSnapshot.data ?? [];
                        
                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Campaign Image
                              Container(
                                width: double.infinity,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                ),
                                child: campaign?.image != null && campaign!.image.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(16),
                                          topRight: Radius.circular(16),
                                        ),
                                        child: Image.network(
                                          campaign.image,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              color: Colors.grey[300],
                                              child: const Icon(
                                                Icons.image,
                                                size: 50,
                                                color: Colors.grey,
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    : const Icon(
                                        Icons.image,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Campaign Title
                                    Text(
                                      campaign?.title ?? 'Campaign',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Inter',
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    
                                    // Total Donation
                                    Row(
                                      children: [
                                        const Text(
                                          'Total Donasi',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Inter',
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          _formatCurrency(totalDonation),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF2C6B6F),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    
                                    // Progress Section
                                    const Text(
                                      'Progress',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: LinearProgressIndicator(
                                        value: progress.clamp(0.0, 1.0),
                                        backgroundColor: Colors.grey[200],
                                        valueColor: const AlwaysStoppedAnimation<Color>(
                                          Color(0xFF2C6B6F),
                                        ),
                                        minHeight: 8,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _formatAmount(currentAmount),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Inter',
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        Text(
                                          _formatAmount(targetAmount),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Inter',
                                            color: Color(0xFF2C6B6F),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 24),
                                    
                                    // Update Section
                                    if (updates.isNotEmpty) ...[
                                      const Text(
                                        'Update',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      ...updates.asMap().entries.map((entry) {
                                        final index = entry.key;
                                        final update = entry.value;
                                        final isLast = index == updates.length - 1;
                                        return UpdateTimeline(
                                          title: update.title,
                                          description: update.description,
                                          isCompleted: update.isCompleted,
                                          isLast: isLast,
                                        );
                                      }).toList(),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              }).toList(),
              const SizedBox(height: 80), // Space for bottom nav
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(
          items: [
            BottomNavItem(
              label: 'Donasi',
              icon: Icons.favorite_outline,
              routeName: '/home',
            ),
            BottomNavItem(
              label: 'Galang Dana',
              icon: Icons.campaign,
              routeName: '/allcampaign',
            ),
            BottomNavItem(
              label: 'Donasiku',
              icon: Icons.receipt,
              routeName: '/my-donations',
            ),
            BottomNavItem(
              label: 'Akun',
              icon: Icons.person_outline,
              routeName: '/profile',
            ),
          ],
          onItemTapped: (route) {
            if (route != Get.currentRoute) {
              Get.offNamed(route);
            }
          },
        ),
      );
    });
  }
}
