class WithdrawalModel {
  final int id;
  final int campaignId;
  final double amount;
  final String status; // pending, approved, rejected
  final String? rejectionReason;
  final String? proofUrl;
  final String? bankName;
  final String? accountNumber;
  final String? accountName;
  final DateTime createdAt;
  final DateTime? updatedAt;

  WithdrawalModel({
    required this.id,
    required this.campaignId,
    required this.amount,
    required this.status,
    this.rejectionReason,
    this.proofUrl,
    this.bankName,
    this.accountNumber,
    this.accountName,
    required this.createdAt,
    this.updatedAt,
  });

  factory WithdrawalModel.fromJson(Map<String, dynamic> json) {
    return WithdrawalModel(
      id: json['id'] as int,
      campaignId: json['campaign_id'] as int,
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String? ?? 'pending',
      rejectionReason: json['rejection_reason'] as String?,
      proofUrl: json['proof_url'] as String?,
      bankName: json['bank_name'] as String?,
      accountNumber: json['account_number'] as String?,
      accountName: json['account_name'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }
}

