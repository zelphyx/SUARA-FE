class StatsModel {
  final double totalRaised;
  final int totalDonors;
  final int activeCampaigns;

  StatsModel({
    required this.totalRaised,
    required this.totalDonors,
    required this.activeCampaigns,
  });

  factory StatsModel.fromJson(Map<String, dynamic> json) {
    return StatsModel(
      totalRaised: (json['total_raised'] as num?)?.toDouble() ?? 0.0,
      totalDonors: json['total_donors'] as int? ?? 0,
      activeCampaigns: json['active_campaigns'] as int? ?? 0,
    );
  }
}

class MasterAccountModel {
  final int id;
  final String bankName;
  final String accountNumber;
  final String accountName;

  MasterAccountModel({
    required this.id,
    required this.bankName,
    required this.accountNumber,
    required this.accountName,
  });

  factory MasterAccountModel.fromJson(Map<String, dynamic> json) {
    return MasterAccountModel(
      id: json['id'] as int,
      bankName: json['bank_name'] as String,
      accountNumber: json['account_number'] as String,
      accountName: json['account_name'] as String,
    );
  }
}

