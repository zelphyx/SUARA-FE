import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../detail/reusable_component.dart';
import '../services/donation_service.dart';

class DonationFormPage extends StatefulWidget {
  final String campaignId;
  final String campaignTitle;
  final String campaignImage;
  final double currentAmount;
  final double targetAmount;

  const DonationFormPage({
    super.key,
    required this.campaignId,
    required this.campaignTitle,
    required this.campaignImage,
    required this.currentAmount,
    required this.targetAmount,
  });

  @override
  State<DonationFormPage> createState() => _DonationFormPageState();
}

class _DonationFormPageState extends State<DonationFormPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  final _customAmountController = TextEditingController();
  
  bool _isAnonymous = false;
  int? _selectedAmount;
  String _selectedPaymentMethod = 'QRIS';
  final double _minDonation = 10000;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    _customAmountController.dispose();
    super.dispose();
  }

  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(0)}jt';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}rb';
    }
    return amount.toStringAsFixed(0);
  }

  Future<void> _handlePayment() async {
    double amount = 0;
    
    if (_selectedAmount != null) {
      amount = _selectedAmount!.toDouble();
    } else if (_customAmountController.text.isNotEmpty) {
      amount = double.tryParse(_customAmountController.text.replaceAll('.', '')) ?? 0;
    }

    if (amount < _minDonation) {
      Get.snackbar(
        'Error',
        'Min. Donasi Sebesar Rp. ${_formatAmount(_minDonation)}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (!_isAnonymous && _nameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Masukkan Nama Anda',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (_phoneController.text.isEmpty && _emailController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Masukkan Nomor Telepon atau Email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Implement payment logic
    try {
      final donationService = DonationService();
      final result = await donationService.createDonation(
        campaignId: int.tryParse(widget.campaignId) ?? 0,
        amount: amount,
        message: _messageController.text.isEmpty ? null : _messageController.text,
        isAnonymous: _isAnonymous,
      );

      if (result['success'] == true) {
        final snapToken = result['snap_token'] as String?;
        if (snapToken != null) {
          // TODO: Integrate with Midtrans Snap
          Get.snackbar(
            'Berhasil',
            'Token pembayaran berhasil dibuat',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          // Navigate to payment page atau buka Midtrans Snap
          Get.back();
        } else {
          Get.snackbar(
            'Berhasil',
            result['message'] ?? 'Donasi berhasil dibuat',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          Get.back();
        }
      } else {
        Get.snackbar(
          'Error',
          result['message'] ?? 'Gagal membuat donasi',
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.currentAmount / widget.targetAmount;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: Text(
          widget.campaignTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campaign Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.campaignImage,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, size: 50),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            
            // Campaign Title
            const Text(
              'Title',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 16),
            
            // Progress Bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      _formatAmount(widget.currentAmount),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                    Text(
                      _formatAmount(widget.targetAmount),
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
            const SizedBox(height: 32),

            // Input Section
            const Text(
              'Masuk',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 16),

            // Name Input
            TextField(
              controller: _nameController,
              style: const TextStyle(fontFamily: 'Inter'),
              decoration: InputDecoration(
                hintText: 'Masukkan Nama Anda',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontFamily: 'Inter',
                ),
                prefixIcon: Icon(Icons.person_outline, color: Colors.grey[400]),
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
            const SizedBox(height: 16),

            // Anonymous Toggle
            Row(
              children: [
                Text(
                  'Sembunyikan Identitas Saya (Anonim)',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Inter',
                    color: Colors.grey[700],
                  ),
                ),
                const Spacer(),
                Switch(
                  value: _isAnonymous,
                  onChanged: (value) {
                    setState(() {
                      _isAnonymous = value;
                    });
                  },
                  activeColor: const Color(0xFF2C6B6F),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Phone Input
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(fontFamily: 'Inter'),
              decoration: InputDecoration(
                hintText: 'Masukkan Nomor Telepon Anda (+62)',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontFamily: 'Inter',
                ),
                prefixIcon: Icon(Icons.phone_outlined, color: Colors.grey[400]),
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
            const SizedBox(height: 16),

            // Or Separator
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey[300])),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Atau',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Inter',
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                Expanded(child: Divider(color: Colors.grey[300])),
              ],
            ),
            const SizedBox(height: 16),

            // Email Input
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(fontFamily: 'Inter'),
              decoration: InputDecoration(
                hintText: 'Masukkan Email Anda',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontFamily: 'Inter',
                ),
                prefixIcon: Icon(Icons.email_outlined, color: Colors.grey[400]),
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
            const SizedBox(height: 24),

            // Message Field
            const Text(
              'Pesan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _messageController,
              maxLines: 4,
              style: const TextStyle(fontFamily: 'Inter'),
              decoration: InputDecoration(
                hintText: 'Tulis pesan....',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontFamily: 'Inter',
                ),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 32),

            // Nominal Input Section
            const Text(
              'Masukkan Nominal',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 16),

            // Pre-defined Amounts
            Row(
              children: [
                Expanded(
                  child: _AmountButton(
                    amount: 10000,
                    label: 'Rp. 10.000,-',
                    isSelected: _selectedAmount == 10000,
                    onTap: () {
                      setState(() {
                        _selectedAmount = 10000;
                        _customAmountController.clear();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _AmountButton(
                    amount: 20000,
                    label: 'Rp. 20.000,-',
                    isSelected: _selectedAmount == 20000,
                    onTap: () {
                      setState(() {
                        _selectedAmount = 20000;
                        _customAmountController.clear();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _AmountButton(
                    amount: 50000,
                    label: 'Rp. 50.000,-',
                    isSelected: _selectedAmount == 50000,
                    onTap: () {
                      setState(() {
                        _selectedAmount = 50000;
                        _customAmountController.clear();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Or Separator
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey[300])),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Atau',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Inter',
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                Expanded(child: Divider(color: Colors.grey[300])),
              ],
            ),
            const SizedBox(height: 16),

            // Custom Amount Input
            const Text(
              'Masukkan Nominal Lainnya',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _customAmountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontFamily: 'Inter'),
              onChanged: (value) {
                setState(() {
                  _selectedAmount = null;
                });
              },
              decoration: InputDecoration(
                hintText: 'Rp.',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontFamily: 'Inter',
                ),
                prefixText: 'Rp. ',
                prefixStyle: const TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.black87,
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
            const SizedBox(height: 8),
            Text(
              'Min. Donasi Sebesar Rp. ${_formatAmount(_minDonation)}',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Inter',
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),

            // Payment Method Section
            const Text(
              'Metode Donasi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                // TODO: Show payment method selection
                Get.snackbar(
                  'Info',
                  'Pilih metode pembayaran',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'QRIS',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                          color: Color(0xFF2C6B6F),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'QRIS',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Pay Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _handlePayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2C6B6F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Bayar Sekarang',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _AmountButton extends StatelessWidget {
  final int amount;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _AmountButton({
    required this.amount,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2C6B6F) : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}

