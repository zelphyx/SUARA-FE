import 'package:suarafe/models/user_model.dart';
import 'package:suarafe/models/campaign_model.dart';

class DonationModel {
  final int id;
  final int campaignId;
  final CampaignModel? campaign;
  final int userId;
  final UserModel? user;
  final double amount;
  final String status; // pending, success, failed
  final String? snapToken;
  final String? message;
  final bool isAnonymous;
  final DateTime createdAt;
  final DateTime? updatedAt;

  DonationModel({
    required this.id,
    required this.campaignId,
    this.campaign,
    required this.userId,
    this.user,
    required this.amount,
    required this.status,
    this.snapToken,
    this.message,
    this.isAnonymous = false,
    required this.createdAt,
    this.updatedAt,
  });

  factory DonationModel.fromJson(Map<String, dynamic> json) {
    return DonationModel(
      id: json['id'] as int,
      campaignId: json['campaign_id'] as int,
      campaign: json['campaign'] != null
          ? CampaignModel.fromJson(json['campaign'] as Map<String, dynamic>)
          : null,
      userId: json['user_id'] as int,
      user: json['user'] != null
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String? ?? 'pending',
      snapToken: json['snap_token'] as String?,
      message: json['message'] as String?,
      isAnonymous: json['is_anonymous'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }
}

