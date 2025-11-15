// controllers/register_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  void register() {
    // Validasi semua field terisi
    if (emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Semua field harus diisi',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Validasi format email
    if (!GetUtils.isEmail(emailController.text)) {
      Get.snackbar(
        'Error',
        'Format email tidak valid',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Validasi nomor telepon (minimal 10 digit)
    if (phoneController.text.length < 10) {
      Get.snackbar(
        'Error',
        'Nomor telepon minimal 10 digit',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Validasi password minimal 6 karakter
    if (passwordController.text.length < 6) {
      Get.snackbar(
        'Error',
        'Password minimal 6 karakter',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Validasi konfirmasi password
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'Password dan konfirmasi password tidak cocok',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    // Simulasi registrasi
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      Get.snackbar(
        'Berhasil',
        'Registrasi berhasil! Silakan login',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      // Redirect ke halaman login setelah berhasil registrasi
      Future.delayed(const Duration(seconds: 1), () {
        Get.offNamed('/login');
      });
    });
  }

  @override
  void onClose() {
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}