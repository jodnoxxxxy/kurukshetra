class CropModel {
  final String id;
  final String name;
  final DateTime sowingDate;
  final String farmerId;
  final String? stage;
  final String? status;

  const CropModel({
    required this.id,
    required this.name,
    required this.sowingDate,
    required this.farmerId,
    this.stage,
    this.status,
  });

  int get daysSinceSowing => DateTime.now().difference(sowingDate).inDays;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'sowingDate': sowingDate.toIso8601String(),
        'farmerId': farmerId,
        'stage': stage,
        'status': status,
      };

  factory CropModel.fromJson(Map<String, dynamic> json) => CropModel(
        id: json['id'] as String,
        name: json['name'] as String,
        sowingDate: DateTime.parse(json['sowingDate'] as String),
        farmerId: json['farmerId'] as String,
        stage: json['stage'] as String?,
        status: json['status'] as String?,
      );
}
