
// controllers/login_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Email dan password harus diisi',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    
    try {
      final authService = AuthService();
      final result = await authService.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (result['success'] == true) {
        Get.snackbar(
          'Berhasil',
          result['message'] ?? 'Login berhasil!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed('/home');
      } else {
        Get.snackbar(
          'Error',
          result['message'] ?? 'Login gagal',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void forgotPassword() {
    Get.snackbar(
      'Info',
      'Fitur lupa password',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void register() {
    Get.snackbar(
      'Info',
      'Halaman daftar akun',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}