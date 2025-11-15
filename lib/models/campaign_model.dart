import 'package:suarafe/core/constants.dart';
import 'package:suarafe/models/user_model.dart';

class CampaignModel {
  final int id;
  final int userId;
  final int categoryId;
  final String title;
  final String slug;
  final String description;
  final double targetAmount;
  final double collectedAmount;
  final DateTime deadline;
  final String status; // pending, approved, rejected, closed
  final String coverImage;
  final CategoryModel? category;
  final UserModel? user;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<String>? extraImages;
  final double? progressPercentage;

  CampaignModel({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.title,
    required this.slug,
    required this.description,
    required this.targetAmount,
    required this.collectedAmount,
    required this.deadline,
    required this.status,
    required this.coverImage,
    this.category,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.extraImages,
    this.progressPercentage,
  });

  // Getter untuk backward compatibility
  String get image => coverImage;
  double get currentAmount => collectedAmount;

  String get imageUrl {
    return ApiConstants.getImageUrl(coverImage);
  }

  double get progress {
    if (progressPercentage != null) {
      return (progressPercentage! / 100).clamp(0.0, 1.0);
    }
    if (targetAmount == 0) return 0.0;
    return (collectedAmount / targetAmount).clamp(0.0, 1.0);
  }

  // New helpers for UI
  double get progressValue => progressPercentage != null
      ? (progressPercentage! / 100).clamp(0.0, 1.0)
      : progress;
  String get progressLabel => '${(progressValue * 100).toStringAsFixed(0)}%';

  factory CampaignModel.fromJson(Map<String, dynamic> json) {
    return CampaignModel(
      id: json['id'] as int,
      userId: json['user_id'] as int? ?? (json['user'] as Map<String, dynamic>?)?['id'] as int? ?? 0,
      categoryId: json['category_id'] as int? ?? (json['category'] as Map<String, dynamic>?)?['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      description: json['description'] as String? ?? '',
      targetAmount: (json['target_amount'] as num?)?.toDouble() ?? 0.0,
      collectedAmount: (json['collected_amount'] as num?)?.toDouble() ?? 0.0,
      deadline: DateTime.parse(json['deadline'] as String? ?? DateTime.now().toIso8601String()),
      status: json['status'] as String? ?? 'pending',
      coverImage: json['cover_image'] as String? ?? 
                  json['image'] as String? ?? '', // Fallback untuk backward compatibility
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      user: json['user'] != null
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      createdAt: json['created_at'] != null
          ? _parseDateTime(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? _parseDateTime(json['updated_at'])
          : null,
      extraImages: (json['extra_images'] as List?)
          ?.map((e) => e as String)
          .toList(),
      progressPercentage: (json['progress_percentage'] as num?)?.toDouble(),
    );
  }

  static DateTime? _parseDateTime(dynamic dateTime) {
    if (dateTime == null) return null;
    if (dateTime is DateTime) return dateTime;
    if (dateTime is String) {
      try {
        // Handle format: "2025-11-15 12:50:08"
        return DateTime.parse(dateTime.replaceAll(' ', 'T'));
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}

class CategoryModel {
  final int id;
  final String name;
  final String? slug;
  final String? description;
  final String? icon;

  CategoryModel({
    required this.id,
    required this.name,
    this.slug,
    this.description,
    this.icon,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String?,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
    );
  }
}

class CampaignUpdate {
  final int id;
  final int campaignId;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;

  CampaignUpdate({
    required this.id,
    required this.campaignId,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
  });

  factory CampaignUpdate.fromJson(Map<String, dynamic> json) {
    return CampaignUpdate(
      id: json['id'] as int,
      campaignId: json['campaign_id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      isCompleted: json['is_completed'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
