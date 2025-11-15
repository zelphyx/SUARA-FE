import 'package:flutter/material.dart' as material;
import 'package:flutter/foundation.dart';

class CampaignImageCard extends material.StatelessWidget {
  final String imageUrl;
  final double height;

  const CampaignImageCard({
    Key? key,
    required this.imageUrl,
    this.height = 200,
  }) : super(key: key);

  @override
  material.Widget build(material.BuildContext context) {
    return material.ClipRRect(
      borderRadius: material.BorderRadius.circular(12),
      child: material.Image.network(
        imageUrl,
        height: height,
        width: double.infinity,
        fit: material.BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return material.Container(
            height: height,
            color: material.Colors.grey[300],
            child: const material.Icon(material.Icons.image, size: 50),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return material.Container(
            height: height,
            color: material.Colors.grey[200],
            child: const material.Center(
              child: material.CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}

class ProgressBar extends material.StatelessWidget {
  final double currentAmount;
  final double targetAmount;
  final double progress;
  final String? percentageLabel; // new

  const ProgressBar({
    Key? key,
    required this.currentAmount,
    required this.targetAmount,
    required this.progress,
    this.percentageLabel,
  }) : super(key: key);

  @override
  material.Widget build(material.BuildContext context) {
    final label = percentageLabel ?? '${(progress * 100).toStringAsFixed(0)}%';
    return material.Column(
      crossAxisAlignment: material.CrossAxisAlignment.start,
      children: [
        const material.Text(
          'Progress',
          style: material.TextStyle(
            fontSize: 16,
            fontWeight: material.FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
        const material.SizedBox(height: 12),
        material.ClipRRect(
          borderRadius: material.BorderRadius.circular(4),
          child: material.Stack(
            children: [
              material.LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                backgroundColor: material.Colors.grey[200],
                valueColor: const material.AlwaysStoppedAnimation<material.Color>(
                  material.Color(0xFF2C6B6F),
                ),
                minHeight: 10,
              ),
              material.Positioned.fill(
                child: material.Center(
                  child: material.Text(
                    label,
                    style: const material.TextStyle(
                      fontSize: 12,
                      fontWeight: material.FontWeight.w600,
                      fontFamily: 'Inter',
                      color: material.Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const material.SizedBox(height: 12),
        material.Row(
          mainAxisAlignment: material.MainAxisAlignment.spaceBetween,
          children: [
            material.Text(
              _formatAmount(currentAmount),
              style: const material.TextStyle(
                fontSize: 16,
                fontWeight: material.FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
            material.Text(
              _formatAmount(targetAmount),
              style: const material.TextStyle(
                color: material.Color(0xFF2C6B6F),
                fontWeight: material.FontWeight.bold,
                fontSize: 16,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }
}

class UpdateTimeline extends material.StatelessWidget {
  final String title;
  final String description;
  final bool isCompleted;
  final bool isLast;

  const UpdateTimeline({
    Key? key,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.isLast,
  }) : super(key: key);

  @override
  material.Widget build(material.BuildContext context) {
    return material.Row(
      crossAxisAlignment: material.CrossAxisAlignment.start,
      children: [
        material.Column(
          children: [
            material.Container(
              width: 32,
              height: 32,
              decoration: material.BoxDecoration(
                shape: material.BoxShape.circle,
                color: isCompleted
                    ? const material.Color(0xFF2C6B6F)
                    : material.Colors.grey[300],
              ),
              child: material.Center(
                child: material.Icon(
                  isCompleted
                      ? material.Icons.check
                      : material.Icons.radio_button_unchecked,
                  color:
                      isCompleted ? material.Colors.white : material.Colors.grey,
                  size: 18,
                ),
              ),
            ),
            if (!isLast)
              material.Container(
                width: 2,
                height: 60,
                color: material.Colors.grey[300],
              ),
          ],
        ),
        const material.SizedBox(width: 16),
        material.Expanded(
          child: material.Column(
            crossAxisAlignment: material.CrossAxisAlignment.start,
            children: [
              material.Text(
                title,
                style: const material.TextStyle(
                  fontSize: 14,
                  fontWeight: material.FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
              const material.SizedBox(height: 4),
              material.Text(
                description,
                style: material.TextStyle(
                  fontSize: 12,
                  fontFamily: 'Inter',
                  color: material.Colors.grey[600],
                ),
              ),
              const material.SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }
}

class PrimaryButton extends material.StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  const PrimaryButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  }) : super(key: key);

  @override
  material.Widget build(material.BuildContext context) {
    return material.SizedBox(
      width: double.infinity,
      height: 52,
      child: material.ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: material.ElevatedButton.styleFrom(
          backgroundColor: const material.Color(0xFF2C6B6F),
          shape: material.RoundedRectangleBorder(
            borderRadius: material.BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const material.SizedBox(
                height: 20,
                width: 20,
                child: material.CircularProgressIndicator(
                  color: material.Colors.white,
                  strokeWidth: 2,
                ),
              )
            : material.Text(
                label,
                style: const material.TextStyle(
                  fontSize: 16,
                  fontWeight: material.FontWeight.w600,
                  fontFamily: 'Inter',
                  color: material.Colors.white,
                ),
              ),
      ),
    );
  }
}
