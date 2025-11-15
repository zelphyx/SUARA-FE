import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suarafe/shared/widgets/bottom_navbar.dart';
import '../controllers/allcampaign_controller.dart';

class AllCampaignPage extends StatelessWidget {
  const AllCampaignPage({Key? key}) : super(key: key);

  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(0)}jt';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}rb';
    }
    return amount.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllCampaignController());
    return Obx(() {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        onChanged: (value) {
                          controller.setSearchQuery(value);
                        },
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontFamily: 'Inter',
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey[400],
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Categories Section (Horizontal Scroll)
                  if (controller.categories.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Text(
                        'Kategori',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: controller.categories.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            // All categories button
                            final isSelected = controller.selectedCategoryId.value == null;
                            return GestureDetector(
                              onTap: () => controller.selectCategory(null),
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF2C6B6F)
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    'Semua',
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.black87,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }

                          final category = controller.categories[index - 1];
                          final isSelected =
                              controller.selectedCategoryId.value == category.id;

                          return GestureDetector(
                            onTap: () => controller.selectCategory(category.id),
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF2C6B6F)
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  category.name,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Colors.black87,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Section: Deadline Donasi Hampir Habis
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Text(
                      'Deadline Donasi Hampir Habis',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Urgent Campaign Cards (Horizontal List)
                  Obx(() {
                    if (controller.isLoadingUrgent.value) {
                      return const SizedBox(
                        height: 280,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (controller.urgentCampaigns.isEmpty) {
                      return const SizedBox(
                        height: 100,
                        child: Center(
                          child: Text('Tidak ada campaign mendesak'),
                        ),
                      );
                    }

                    return SizedBox(
                      height: 280,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: controller.urgentCampaigns.length,
                        itemBuilder: (context, index) {
                          final campaign = controller.urgentCampaigns[index];
                          return InkWell(
                            onTap: () => Get.toNamed('/detail/${campaign.id}'),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: SizedBox(
                                width: 280,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: campaign.imageUrl.isNotEmpty
                                          ? Image.network(
                                              campaign.imageUrl,
                                              height: 150,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Container(
                                                  height: 150,
                                                  color: Colors.grey[300],
                                                  child: const Icon(Icons.image),
                                                );
                                              },
                                            )
                                          : Container(
                                              height: 150,
                                              color: Colors.grey[300],
                                              child: const Icon(Icons.image),
                                            ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      campaign.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        fontFamily: 'Inter',
                                        color: Colors.black87,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: Stack(
                                        children: [
                                          LinearProgressIndicator(
                                            value: campaign.progressValue,
                                            backgroundColor: Colors.grey[200],
                                            valueColor:
                                                const AlwaysStoppedAnimation<Color>(
                                              Color(0xFF2C6B6F),
                                            ),
                                            minHeight: 6,
                                          ),
                                          Positioned.fill(
                                            child: Center(
                                              child: Text(
                                                campaign.progressLabel,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _formatAmount(campaign.currentAmount),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Inter',
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          _formatAmount(campaign.targetAmount),
                                          style: const TextStyle(
                                            color: Color(0xFF2C6B6F),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),

                  const SizedBox(height: 24),

                  // Section: ALL CAMPAIGNS
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Text(
                      'ALL CAMPAIGNS',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Grid Campaign Cards (2 columns)
                  Obx(() {
                    if (controller.isLoading.value) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (controller.error.value != null) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Column(
                            children: [
                              Text(controller.error.value ?? 'Error'),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => controller.fetchCampaigns(),
                                child: const Text('Coba Lagi'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (controller.campaigns.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.campaign_outlined,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Belum Ada Campaign',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600],
                                  fontFamily: 'Inter',
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Database masih kosong.\nTunggu admin menambahkan campaign.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                  fontFamily: 'Inter',
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () => controller.fetchCampaigns(),
                                icon: const Icon(Icons.refresh),
                                label: const Text('Refresh'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2C6B6F),
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.9,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.campaigns.length,
                        itemBuilder: (context, index) {
                          final campaign = controller.campaigns[index];
                          return InkWell(
                            onTap: () => Get.toNamed('/detail/${campaign.id}'),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: campaign.imageUrl.isNotEmpty
                                      ? Image.network(
                                          campaign.imageUrl,
                                          height: 120,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              height: 120,
                                              color: Colors.grey[300],
                                              child: const Icon(Icons.image),
                                            );
                                          },
                                        )
                                      : Container(
                                          height: 120,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.image),
                                        ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  campaign.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    color: Colors.black87,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Stack(
                                    children: [
                                      LinearProgressIndicator(
                                        value: campaign.progressValue,
                                        backgroundColor: Colors.grey[200],
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                          Color(0xFF2C6B6F),
                                        ),
                                        minHeight: 4,
                                      ),
                                      Positioned.fill(
                                        child: Center(
                                          child: Text(
                                            campaign.progressLabel,
                                            style: const TextStyle(
                                              fontSize: 9,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _formatAmount(campaign.currentAmount),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Inter',
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      _formatAmount(campaign.targetAmount),
                                      style: const TextStyle(
                                        color: Color(0xFF2C6B6F),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }),

                  const SizedBox(height: 24),
                ],
              ),
            ),

            // Bottom Navbar
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
          ),
        ),
      );
    });
  }
}
