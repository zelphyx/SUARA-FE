import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suarafe/services/auth_service.dart';
import 'package:suarafe/models/user_model.dart';

class ProfileController extends GetxController {
  final _authService = AuthService();

  final user = Rxn<UserModel>();
  final wallet = Rxn<WalletInfo>();
  final isLoading = false.obs;
  final isSaving = false.obs;
  final error = Rxn<String>(); // fix RxnString()

  // Form fields reactive mirrors
  final nameInput = ''.obs;
  final phoneInput = ''.obs;

  // Text editing controllers for stable input
  late final TextEditingController nameController;
  late final TextEditingController phoneController;

  bool get hasChanges =>
      user.value != null && (nameInput.value.trim() != user.value!.name.trim() || (phoneInput.value.trim() != (user.value!.phone ?? '').trim()));

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    fetchProfile();
    fetchWallet();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      error.value = null;
      final profile = await _authService.getProfile();
      if (profile == null) {
        error.value = 'Gagal memuat profil';
        return;
      }
      user.value = profile;
      nameInput.value = profile.name;
      phoneInput.value = profile.phone ?? '';
      nameController.text = nameInput.value;
      phoneController.text = phoneInput.value;
    } catch (e) {
      error.value = 'Error: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  void onNameChanged(String v) {
    nameInput.value = v;
  }

  void onPhoneChanged(String v) {
    phoneInput.value = v;
  }

  Future<void> fetchWallet() async {
    try {
      final data = await _authService.getWallet();
      wallet.value = data;
    } catch (_) {}
  }

  Future<void> saveProfile() async {
    if (user.value == null || !hasChanges) return;
    try {
      isSaving.value = true;
      final result = await _authService.updateProfile(
        name: nameInput.value.trim().isEmpty ? null : nameInput.value.trim(),
        phone: phoneInput.value.trim().isEmpty ? null : phoneInput.value.trim(),
      );
      if (result['success'] == true && result['user'] != null) {
        user.value = result['user'] as UserModel;
        nameInput.value = user.value!.name;
        phoneInput.value = user.value!.phone ?? '';
        nameController.text = nameInput.value;
        phoneController.text = phoneInput.value;
        Get.snackbar('Sukses', 'Profil diperbarui');
      } else {
        Get.snackbar('Gagal', result['message'] ?? 'Update gagal');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> logout() async {
    final result = await _authService.logout();
    if (result['success'] == true) {
      Get.offAllNamed('/login');
    } else {
      Get.snackbar('Error', result['message'] ?? 'Logout gagal');
    }
  }
}
