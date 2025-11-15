class DetailModel {
  final String id;
  final String title;
  final String description;
  final String image;
  final double currentAmount;
  final double targetAmount;
  final double progress; // 0..1
  final double? progressPercentage; // raw percentage (0-100)
  final DateTime? deadline;
  final String? userName;
  final String? categoryName;
  final List<UpdateItem> updates;
  final List<String> extraImages; // added field

  DetailModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.currentAmount,
    required this.targetAmount,
    required this.progress,
    this.progressPercentage,
    this.deadline,
    this.userName,
    this.categoryName,
    required this.updates,
    required this.extraImages,
  });

  factory DetailModel.fromJson(Map<String, dynamic> json) {
    return DetailModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      currentAmount: (json['currentAmount'] as num).toDouble(),
      targetAmount: (json['targetAmount'] as num).toDouble(),
      progress: (json['progress'] as num).toDouble(),
      progressPercentage: (json['progressPercentage'] as num?)?.toDouble(),
      deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
      userName: json['userName'] as String?,
      categoryName: json['categoryName'] as String?,
      updates: (json['updates'] as List?)
              ?.map((e) => UpdateItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      extraImages: (json['extraImages'] as List?)?.map((e) => e as String).toList() ?? [],
    );
  }
}

class UpdateItem {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;

  UpdateItem({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
  });

  factory UpdateItem.fromJson(Map<String, dynamic> json) {
    return UpdateItem(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}
