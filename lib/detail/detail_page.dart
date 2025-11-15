import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'detail_controller.dart';
import 'reusable_component.dart';
import 'image_viewer.dart';
import 'package:suarafe/shared/widgets/bottom_navbar.dart';

class DetailPage extends StatefulWidget {
  final String id;

  const DetailPage({
    super.key,
    required this.id,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late DetailController controller;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _contentButtonKey = GlobalKey();
  final RxBool _showFloating = false.obs;

  @override
  void initState() {
    super.initState();
    controller = Get.put(DetailController());
    controller.fetchDetail(widget.id);
    _scrollController.addListener(_onScroll);
    _showFloating.value = true; // FAB shown by default on page load
  }

  void _onScroll() {
    // measure position of the in-content button and toggle floating button
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      try {
        final ctx = _contentButtonKey.currentContext;
        if (ctx == null) {
          _showFloating.value = true; // default: show FAB
          return;
        }
        final box = ctx.findRenderObject() as RenderBox?;
        if (box == null) {
          _showFloating.value = true; // default: show FAB
          return;
        }
        final pos = box.localToGlobal(Offset.zero).dy;
        final screenHeight = MediaQuery.of(context).size.height;
        final buttonHeight = box.size.height;
        // if button is visible on screen (within viewport), hide FAB
        // otherwise show FAB (button scrolled below viewport)
        _showFloating.value = pos > screenHeight || pos + buttonHeight < 0;
      } catch (_) {
        // ignore measurement errors
        _showFloating.value = true; // default: show FAB
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _showFloating.close();
    super.dispose();
  }

  void _openGallery(List<String> images, int initialIndex) {
    Get.to(() => ImageGalleryPage(images: images, initialIndex: initialIndex));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
              onPressed: () => Get.back(),
            ),
            title: const Text(
              'Nama Kampanye',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
                color: Colors.black87,
              ),
            ),
            centerTitle: true,
          ),

          // Body: tetap di dalam Obx untuk reactivity
          body: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.error.value != null) {
              return Center(
                child: Text('Error: ${controller.error.value}'),
              );
            }
            final data = controller.detail.value;
            if (data == null) {
              return const Center(child: Text('No data'));
            }

            return SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => _openGallery([data.image, ...data.extraImages], 0),
                    child: CampaignImageCard(imageUrl: data.image),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    data.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 16),
                  ProgressBar(
                    currentAmount: data.currentAmount,
                    targetAmount: data.targetAmount,
                    progress: data.progress,
                    percentageLabel: data.progressPercentage != null
                        ? '${data.progressPercentage!.toStringAsFixed(0)}%'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  if (data.deadline != null)
                    Text(
                      'Deadline: ${data.deadline!.toIso8601String().substring(0,10)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'Inter',
                        color: Colors.grey,
                      ),
                    ),
                  const SizedBox(height: 8),
                  if (data.categoryName != null || data.userName != null)
                    Row(
                      children: [
                        if (data.categoryName != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2C6B6F),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              data.categoryName!,
                              style: const TextStyle(
                                fontSize: 11,
                                fontFamily: 'Inter',
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        if (data.userName != null)
                          Text(
                            'Oleh ${data.userName!}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'Inter',
                              color: Colors.black54,
                            ),
                          ),
                      ],
                    ),
                  const SizedBox(height: 24),
                  const Text(
                    'Update',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.updates.length,
                    itemBuilder: (context, index) {
                      final update = data.updates[index];
                      return UpdateTimeline(
                        title: update.title,
                        description: update.description,
                        isCompleted: update.isCompleted,
                        isLast: index == data.updates.length - 1,
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Extra images section (single image from organizer)
                  if (data.extraImages.isNotEmpty) ...[
                    const Text(
                      'Gambar Tambahan Dari Penyelenggara Campaign',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () => _openGallery([data.image, data.extraImages.first], 1),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          data.extraImages.first,
                          width: double.infinity,
                          height: 140,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: double.infinity,
                              height: 140,
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: double.infinity,
                              height: 140,
                              color: Colors.grey[200],
                              child: const Center(child: CircularProgressIndicator()),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Description
                  const Text(
                    'Deskripsi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    data.description,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Inter',
                      color: Colors.grey[600],
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Primary button in content (default). It has a key we measure to show floating FAB.
                  Padding(
                    key: _contentButtonKey,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: PrimaryButton(
                      label: 'Donasi Sekarang',
                      isLoading: controller.isLoading.value,
                      onPressed: controller.isLoading.value
                          ? () {}
                          : () {
                              Get.toNamed('/donation-form', arguments: {
                                'campaignId': data.id,
                                'campaignTitle': data.title,
                                'campaignImage': data.image,
                                'currentAmount': data.currentAmount,
                                'targetAmount': data.targetAmount,
                              });
                            },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          }),

          // Floating action: shows only when the in-content button is scrolled off top
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Obx(() {
            final data = controller.detail.value;
            return _showFloating.value && data != null
                ? Container(
                    width: MediaQuery.of(context).size.width - 32,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: FloatingActionButton.extended(
                      onPressed: controller.isLoading.value
                          ? null
                          : () {
                              Get.toNamed('/donation-form', arguments: {
                                'campaignId': data.id,
                                'campaignTitle': data.title,
                                'campaignImage': data.image,
                                'currentAmount': data.currentAmount,
                                'targetAmount': data.targetAmount,
                              });
                            },
                      backgroundColor: const Color(0xFF4E8A8A),
                      label: controller.isLoading.value
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Donasi Sekarang',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                                color: Colors.white,
                              ),
                            ),
                    ),
                  )
                : const SizedBox.shrink();
          }),

          // Bottom navbar
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
  }
}
