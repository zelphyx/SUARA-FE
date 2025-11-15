// pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../methods/login_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 60),

              // Illustration
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Image.asset(
                    'asset/login.png',
                    height: 180,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.assignment_outlined,
                        size: 100,
                        color: Colors.teal[700],
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Title
              const Text(
                'Selamat Datang',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Inter',
                  color: Color(0xFF4E8A8A),
                ),
              ),

              const SizedBox(height: 8),

              // Subtitle
              const Text(
                'Masuk ke aplikasi RUANG untuk mulai menyalurkan kebaikan anda',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Inter',
                  color: Colors.grey,
                  fontWeight: FontWeight.w600 ,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 32),

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

              const SizedBox(height: 8),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: controller.forgotPassword,
                  child: const Text(
                    'Lupa Password?',
                    style: TextStyle(
                      color: Color(0xFFE8B655),
                      fontSize: 14,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Login Button
              Obx(() => SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.login,
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
                    'Masuk',
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

              // Register Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Belum punya akun? ',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontFamily: 'Inter',
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.offNamed('/register');
                    },
                    child: const Text(
                      'Daftar Akun',
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