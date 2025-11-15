import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suarafe/controllers/profile_controller.dart';
import 'package:suarafe/shared/widgets/bottom_navbar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          appBar: AppBar(
            title: const Text(
              'Profil Saya',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
                color: Colors.black87,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF2C6B6F),
                ),
              );
            }
            if (controller.error.value != null) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      controller.error.value ?? '',
                      style: const TextStyle(fontFamily: 'Inter'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: controller.fetchProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2C6B6F),
                      ),
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            }
            final user = controller.user.value;
            if (user == null) {
              return const Center(child: Text('Tidak ada data user'));
            }
            return RefreshIndicator(
              color: const Color(0xFF2C6B6F),
              onRefresh: () async {
                await controller.fetchProfile();
                await controller.fetchWallet();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // Header Card with Gradient
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2C6B6F), Color(0xFF4E8A8A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2C6B6F).withOpacity(0.2),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 42,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 38,
                                backgroundColor: const Color(0xFFE8D4A0),
                                child: Text(
                                  user.name.isNotEmpty
                                      ? user.name[0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2C6B6F),
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter',
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              user.email ?? '-',
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'Inter',
                                color: Colors.white70,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: (user.isVerifiedCivitas ?? false)
                                        ? Colors.green.withOpacity(0.9)
                                        : Colors.orange.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        (user.isVerifiedCivitas ?? false)
                                            ? Icons.verified
                                            : Icons.info_outline,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        (user.isVerifiedCivitas ?? false)
                                            ? 'Terverifikasi'
                                            : 'Belum Verifikasi',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontFamily: 'Inter',
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (user.role != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.white30),
                                    ),
                                    child: Text(
                                      user.role!.toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontFamily: 'Inter',
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Content
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Wallet Card
                          Obx(() {
                            final w = controller.wallet.value;
                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 12,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF2C6B6F)
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: const Icon(
                                          Icons.account_balance_wallet,
                                          color: Color(0xFF2C6B6F),
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'Wallet Saya',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Inter',
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  if (w == null)
                                    const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  else ...[
                                    _walletRow('Saldo', w.balance,
                                        Icons.account_balance, true),
                                    const Divider(height: 24),
                                    _walletRow('Saldo Tersedia',
                                        w.availableBalance, Icons.savings),
                                    const SizedBox(height: 12),
                                    _walletRow('Total Masuk', w.totalIncome,
                                        Icons.arrow_downward, false, Colors.green),
                                    const SizedBox(height: 12),
                                    _walletRow('Total Ditarik',
                                        w.totalWithdrawn, Icons.arrow_upward,
                                        false, Colors.orange),
                                  ],
                                ],
                              ),
                            );
                          }),

                          const SizedBox(height: 16),

                          // Edit Profile Card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 12,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF2C6B6F)
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.edit,
                                        color: Color(0xFF2C6B6F),
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'Edit Profil',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Inter',
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                TextField(
                                  controller: controller.nameController,
                                  onChanged: controller.onNameChanged,
                                  decoration: InputDecoration(
                                    labelText: 'Nama Lengkap',
                                    labelStyle:
                                        const TextStyle(fontFamily: 'Inter'),
                                    prefixIcon: const Icon(
                                        Icons.person_outline,
                                        color: Color(0xFF2C6B6F)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide:
                                          BorderSide(color: Colors.grey[300]!),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide:
                                          BorderSide(color: Colors.grey[300]!),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: Color(0xFF2C6B6F), width: 2),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                  ),
                                  style: const TextStyle(fontFamily: 'Inter'),
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: controller.phoneController,
                                  onChanged: controller.onPhoneChanged,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    labelText: 'Nomor Telepon',
                                    labelStyle:
                                        const TextStyle(fontFamily: 'Inter'),
                                    prefixIcon: const Icon(
                                        Icons.phone_outlined,
                                        color: Color(0xFF2C6B6F)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide:
                                          BorderSide(color: Colors.grey[300]!),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide:
                                          BorderSide(color: Colors.grey[300]!),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: Color(0xFF2C6B6F), width: 2),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                  ),
                                  style: const TextStyle(fontFamily: 'Inter'),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Action Buttons
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: controller.isSaving.value ||
                                      !controller.hasChanges
                                  ? null
                                  : controller.saveProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2C6B6F),
                                disabledBackgroundColor: Colors.grey[300],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: controller.isSaving.value
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.save, size: 20),
                                        const SizedBox(width: 8),
                                        Text(
                                          controller.hasChanges
                                              ? 'Simpan Perubahan'
                                              : 'Tidak Ada Perubahan',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: OutlinedButton(
                              onPressed: controller.logout,
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: Colors.redAccent, width: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.logout,
                                      color: Colors.redAccent, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Logout',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Inter',
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          bottomNavigationBar: CustomBottomNavBar(
            items: const [
              BottomNavItem(
                  label: 'Donasi',
                  icon: Icons.favorite_outline,
                  routeName: '/home'),
              BottomNavItem(
                  label: 'Galang Dana',
                  icon: Icons.campaign,
                  routeName: '/allcampaign'),
              BottomNavItem(
                  label: 'Donasiku',
                  icon: Icons.receipt,
                  routeName: '/my-donations'),
              BottomNavItem(
                  label: 'Akun',
                  icon: Icons.person_outline,
                  routeName: '/profile'),
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

  Widget _walletRow(String label, double value, IconData icon,
      [bool isPrimary = false, Color? iconColor]) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (iconColor ?? const Color(0xFF2C6B6F)).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 18,
            color: iconColor ?? const Color(0xFF2C6B6F),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: isPrimary ? 14 : 13,
              fontFamily: 'Inter',
              color: isPrimary ? Colors.black87 : Colors.black54,
              fontWeight: isPrimary ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
        Text(
          _formatAmount(value),
          style: TextStyle(
            fontSize: isPrimary ? 18 : 14,
            fontFamily: 'Inter',
            fontWeight: isPrimary ? FontWeight.bold : FontWeight.w600,
            color: isPrimary ? const Color(0xFF2C6B6F) : Colors.black87,
          ),
        ),
      ],
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 1000000000) {
      return 'Rp ${(amount / 1000000000).toStringAsFixed(1)}M';
    }
    if (amount >= 1000000) {
      return 'Rp ${(amount / 1000000).toStringAsFixed(1)}jt';
    }
    if (amount >= 1000) {
      return 'Rp ${(amount / 1000).toStringAsFixed(0)}rb';
    }
    return 'Rp ${amount.toStringAsFixed(0)}';
  }
}

