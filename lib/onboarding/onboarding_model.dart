// models/onboarding_model.dart
import 'package:flutter/material.dart';

class OnboardingModel {
  final String category;
  final String title;
  final String description;
  final String image;
  final IconData icon;

  OnboardingModel({
    required this.category,
    required this.title,
    required this.description,
    required this.image,
    required this.icon,
  });
}