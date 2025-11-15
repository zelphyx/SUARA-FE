import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suarafe/shared/widgets/bottom_navbar.dart';
import '../controllers/home_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
    final controller = Get.put(HomeController());
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
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: const AssetImage('assets/profile.png'),
                        onBackgroundImageError: (_, __) {},
                      ),
                      const SizedBox(width: 12),
                      Obx(() => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi, ${controller.user.value?.name ?? 'User'}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                              color: Colors.black87,
                            ),
                          ),
                          const Text(
                            'Lakukan Kebaikan Hari Ini!',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      )),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.mail_outline, color: Colors.black87),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                // Title Card Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2C6B6F), Color(0xFFE8D4A0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      children: [
                        // Right side - Image dengan opacity gradient di kiri
                        Positioned(
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                            child: ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.transparent,
                                    Color.fromRGBO(255, 255, 255, 0.3),
                                    Color.fromRGBO(255, 255, 255, 0.7),
                                    Colors.white,
                                  ],
                                  stops: const [0.0, 0.3, 0.6, 1.0],
                                ).createShader(bounds);
                              },
                              blendMode: BlendMode.dstIn,
                              child: Image.asset(
                                'asset/cfd.webp',
                                width: 200,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 200,
                                    height: double.infinity,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFE8D4A0),
                                    ),
                                    child: const Icon(
                                      Icons.image,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        // Gradient overlay untuk transisi lebih halus
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF2C6B6F),
                                  Color.fromRGBO(44, 107, 111, 0.8),
                                  Color.fromRGBO(44, 107, 111, 0.4),
                                  Color.fromRGBO(44, 107, 111, 0.1),
                                  Colors.transparent,
                                ],
                                stops: const [0.0, 0.3, 0.5, 0.7, 0.85],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                          ),
                        ),
                        // Pattern overlay - diamond shapes
                        Positioned.fill(
                          child: CustomPaint(painter: _StarPatternPainter()),
                        ),
                        // Left side - Text content
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Mari Berbagi Kebaikan',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Inter',
                                  color: Colors.white,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Bersama kita wujudkan perubahan untuk masa depan yang lebih baik',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  color: Colors.white,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 16),
                              OutlinedButton(
                                onPressed: () => Get.toNamed('/allcampaign'),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2C6B6F),
                                  side: const BorderSide(
                                    color: Color(0xFFE8D4A0),
                                    width: 2,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 8,
                                  ),
                                ),
                                child: const Text(
                                  'Donate Now',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Categories Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Text(
                    'Kategori',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Obx(() {
                  if (controller.isLoadingCategories.value) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  
                  if (controller.categories.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.7,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      children: controller.categories.take(4).map((category) {
                        return _categoryCard(category.name, category.icon);
                      }).toList(),
                    ),
                  );
                }),
                const SizedBox(height: 2),
                // Campaign Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Campaign',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF2C6B6F),
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  
                  if (controller.campaigns.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.campaign_outlined,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Belum ada campaign',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.campaigns.length,
                      itemBuilder: (context, index) {
                        final campaign = controller.campaigns[index];
                        return InkWell(
                          onTap: () => Get.toNamed('/detail/${campaign.id}'),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16),
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
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              height: 150,
                                              width: double.infinity,
                                              color: Colors.grey[300],
                                              child: const Icon(Icons.image),
                                            );
                                          },
                                        )
                                      : Container(
                                          height: 150,
                                          width: double.infinity,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.image),
                                        ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  campaign.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    color: Colors.black87,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                // Progress Bar
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Stack(
                                    children: [
                                      LinearProgressIndicator(
                                        value: campaign.progressValue,
                                        backgroundColor: Colors.grey[200],
                                        valueColor: const AlwaysStoppedAnimation<Color>(
                                          Color(0xFF2C6B6F),
                                        ),
                                        minHeight: 6,
                                      ),
                                      Positioned.fill(
                                        child: Center(
                                          child: Text(
                                            campaign.progressLabel,
                                            style: const TextStyle(
                                              fontSize: 11,
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _formatAmount(campaign.currentAmount),
                                      style: const TextStyle(
                                        fontSize: 16,
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
                                        fontSize: 16,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
              // explicit navigation handler dengan transisi smooth
              if (route != Get.currentRoute) {
                Get.offNamed(
                  route,

                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _categoryCard(String title, String? icon) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 3),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 12),
          Icon(
            icon != null ? Icons.category : Icons.folder_outlined,
            size: 40,
            color: const Color(0xFF2C6B6F),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                fontFamily: 'Inter',
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

// Custom painter for star pattern
class _StarPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color.fromRGBO(44, 107, 111, 0.2)
      ..style = PaintingStyle.fill;

    // Draw scattered star/diamond shapes
    final positions = [
      Offset(size.width * 0.7, size.height * 0.2),
      Offset(size.width * 0.85, size.height * 0.4),
      Offset(size.width * 0.6, size.height * 0.6),
      Offset(size.width * 0.9, size.height * 0.7),
      Offset(size.width * 0.75, size.height * 0.85),
    ];

    for (final position in positions) {
      _drawStar(canvas, paint, position, 8);
    }
  }

  void _drawStar(Canvas canvas, Paint paint, Offset center, double radius) {
    // Draw a diamond shape (4-pointed star)
    final path = Path();
    path.moveTo(center.dx, center.dy - radius); // Top
    path.lineTo(center.dx + radius, center.dy); // Right
    path.lineTo(center.dx, center.dy + radius); // Bottom
    path.lineTo(center.dx - radius, center.dy); // Left
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

