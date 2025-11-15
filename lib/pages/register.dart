// pages/register_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../methods/register_controller.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Illustration
              Container(
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Image.asset(
                    'asset/login.png',
                    height: 140,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.person_add_outlined,
                        size: 80,
                        color: Colors.teal[700],
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Title
              const Text(
                'Daftar Akun',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Inter',
                  color: Color(0xFF4E8A8A),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Buat akun baru untuk bergabung dengan aplikasi RUANG',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Inter',
                  color: Colors.grey,
                  fontWeight: FontWeight.w600 ,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 24),

              // Email Field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Inter',
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                    ),
                    decoration: InputDecoration(
                      hintText: 'Masukkan Email Anda',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontFamily: 'Inter',
                      ),
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: Colors.grey[400],
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Phone Number Field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nomor Telepon',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Inter',
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller.phoneController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                    ),
                    decoration: InputDecoration(
                      hintText: 'Masukkan Nomor Telepon',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontFamily: 'Inter',
                      ),
                      prefixIcon: Icon(
                        Icons.phone_outlined,
                        color: Colors.grey[400],
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Password Field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Inter',
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(() => TextField(
                    controller: controller.passwordController,
                    obscureText: !controller.isPasswordVisible.value,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                    ),
                    decoration: InputDecoration(
                      hintText: 'Masukkan Password Anda',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontFamily: 'Inter',
                      ),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Colors.grey[400],
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordVisible.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.grey[400],
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  )),
                ],
              ),

              const SizedBox(height: 16),

              // Confirm Password Field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Konfirmasi Password',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Inter',
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(() => TextField(
                    controller: controller.confirmPasswordController,
                    obscureText: !controller.isConfirmPasswordVisible.value,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                    ),
                    decoration: InputDecoration(
                      hintText: 'Konfirmasi Password Anda',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontFamily: 'Inter',
                      ),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Colors.grey[400],
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isConfirmPasswordVisible.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.grey[400],
                        ),
                        onPressed: controller.toggleConfirmPasswordVisibility,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  )),
                ],
              ),

              const SizedBox(height: 24),

              // Register Button
              Obx(() => SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4E8A8A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Text(
                    'Daftar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                      color: Colors.white,
                    ),
                  ),
                ),
              )),

              const SizedBox(height: 16),

              // Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sudah punya akun? ',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontFamily: 'Inter',
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.offNamed('/login');
                    },
                    child: const Text(
                      'Masuk',
                      style: TextStyle(
                        color: Color(0xFFE8B655),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}