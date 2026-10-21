class CalcCrop {
  final String id;
  final String name;
  final String category;
  final String imageUrl;

  const CalcCrop({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'imageUrl': imageUrl,
    };
  }

  factory CalcCrop.fromJson(Map<String, dynamic> json) {
    return CalcCrop(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }
}

class Transaction {
  final String id;
  final String cropId;
  final String type; // 'expense' or 'income'
  final String category; // 'seeds', 'fertilizer', 'labor', etc for expense. Or 'yield' for income
  final String name;
  final double amount;
  final DateTime date;
  final double? yieldAmount;
  final double? pricePerUnit;

  const Transaction({
    required this.id,
    required this.cropId,
    required this.type,
    required this.category,
    required this.name,
    required this.amount,
    required this.date,
    this.yieldAmount,
    this.pricePerUnit,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cropId': cropId,
      'type': type,
      'category': category,
      'name': name,
      'amount': amount,
      'date': date.toIso8601String(),
      'yieldAmount': yieldAmount,
      'pricePerUnit': pricePerUnit,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      cropId: json['cropId'] as String,
      type: json['type'] as String,
      category: json['category'] as String,
      name: json['name'] as String,
      amount: json['amount'].toDouble(),
      date: DateTime.parse(json['date'] as String),
      yieldAmount: json['yieldAmount']?.toDouble(),
      pricePerUnit: json['pricePerUnit']?.toDouble(),
    );
  }
}
