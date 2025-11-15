class UserModel {
  final int id;
  final String name;
  final String? email;
  final String? phone;
  final String? nidn;
  final String? nim;
  final String status; // unverified, active
  final String? avatar;
  final String? role;
  final bool? isVerifiedCivitas;
  final DateTime? emailVerifiedAt;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.nidn,
    this.nim,
    required this.status,
    this.avatar,
    this.role,
    this.isVerifiedCivitas,
    this.emailVerifiedAt,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      nidn: json['nidn'] as String?,
      nim: json['nim'] as String?,
      status: (json['status'] as String?) ?? (json['role'] as String?) ?? 'unverified',
      avatar: json['avatar'] as String?,
      role: json['role'] as String?,
      isVerifiedCivitas: json['is_verified_civitas'] as bool?,
      emailVerifiedAt: json['email_verified_at'] != null ? _parseDate(json['email_verified_at']) : null,
      createdAt: json['created_at'] != null ? _parseDate(json['created_at']) : null,
    );
  }

  static DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    if (v is String) {
      try { return DateTime.parse(v); } catch (_) { return null; }
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'nidn': nidn,
      'nim': nim,
      'status': status,
      'avatar': avatar,
      'role': role,
      'is_verified_civitas': isVerifiedCivitas,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
    };
  }
}

class WalletInfo {
  final double balance;
  final double availableBalance;
  final double totalIncome;
  final double totalWithdrawn;
  final List<WalletMutation> mutations;

  WalletInfo({
    required this.balance,
    required this.availableBalance,
    required this.totalIncome,
    required this.totalWithdrawn,
    required this.mutations,
  });

  factory WalletInfo.fromJson(Map<String, dynamic> json) {
    return WalletInfo(
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      availableBalance: (json['available_balance'] as num?)?.toDouble() ?? 0.0,
      totalIncome: (json['total_income'] as num?)?.toDouble() ?? 0.0,
      totalWithdrawn: (json['total_withdrawn'] as num?)?.toDouble() ?? 0.0,
      mutations: (json['mutations'] as List?)
              ?.map((e) => WalletMutation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class WalletMutation {
  final int id;
  final String type; // credit, debit
  final double amount;
  final String description;
  final DateTime createdAt;

  WalletMutation({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.createdAt,
  });

  factory WalletMutation.fromJson(Map<String, dynamic> json) {
    return WalletMutation(
      id: json['id'] as int,
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
