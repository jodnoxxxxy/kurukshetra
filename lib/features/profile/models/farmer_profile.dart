class FarmerProfile {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String location;
  final double farmArea;
  final String profilePhoto;
  final bool isVerified;
  final double organicScore;
  final String organicStatus;
  final String farmerId;
  final DateTime memberSince;
  final String preferredLanguage;
  final Map<String, bool> notificationPreferences;
  final List<LandRecord> landRecords;
  final List<CropHistory> cropHistory;
  final PaymentDetails paymentDetails;

  FarmerProfile({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.location,
    required this.farmArea,
    required this.profilePhoto,
    this.isVerified = false,
    this.organicScore = 0.0,
    this.organicStatus = 'Not Certified',
    required this.farmerId,
    required this.memberSince,
    this.preferredLanguage = 'English',
    Map<String, bool>? notificationPreferences,
    List<LandRecord>? landRecords,
    List<CropHistory>? cropHistory,
    PaymentDetails? paymentDetails,
  }) : notificationPreferences = notificationPreferences ?? {
    'weather_alerts': true,
    'pest_alerts': true,
    'market_price_alerts': true,
    'order_notifications': true,
    'government_schemes': true,
  },
       landRecords = landRecords ?? [],
       cropHistory = cropHistory ?? [],
       paymentDetails = paymentDetails ?? const PaymentDetails();

  factory FarmerProfile.fromJson(Map<String, dynamic> json, String id) {
    return FarmerProfile(
      id: id,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      location: json['location'] ?? '${json['village'] ?? ''}, ${json['taluka'] ?? ''}, ${json['district'] ?? ''}',
      farmArea: (json['farmArea'] ?? 0.0).toDouble(),
      profilePhoto: json['profilePhoto'] ?? 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=1470&auto=format&fit=crop',
      isVerified: json['isVerified'] ?? false,
      organicScore: (json['organicScore'] ?? 0.0).toDouble(),
      organicStatus: json['organicStatus'] ?? 'Not Certified',
      farmerId: json['farmerId'] ?? 'FARM-PENDING',
      memberSince: json['createdAt'] != null 
          ? (json['createdAt'] as dynamic).toDate() 
          : DateTime.now(),
      preferredLanguage: json['preferredLanguage'] ?? 'English',
      notificationPreferences: json['notificationPreferences'] != null 
          ? Map<String, bool>.from(json['notificationPreferences']) 
          : null,
      landRecords: json['landRecords'] != null 
          ? (json['landRecords'] as List).map((i) => LandRecord.fromJson(i)).toList() 
          : null,
      cropHistory: json['cropHistory'] != null 
          ? (json['cropHistory'] as List).map((i) => CropHistory.fromJson(i)).toList() 
          : null,
      paymentDetails: json['paymentDetails'] != null 
          ? PaymentDetails.fromJson(json['paymentDetails']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'location': location,
      'farmArea': farmArea,
      'profilePhoto': profilePhoto,
      'isVerified': isVerified,
      'organicScore': organicScore,
      'organicStatus': organicStatus,
      'farmerId': farmerId,
      'preferredLanguage': preferredLanguage,
      'notificationPreferences': notificationPreferences,
      'landRecords': landRecords.map((e) => e.toJson()).toList(),
      'cropHistory': cropHistory.map((e) => e.toJson()).toList(),
      'paymentDetails': paymentDetails.toJson(),
    };
  }

  FarmerProfile copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? location,
    double? farmArea,
    String? profilePhoto,
    bool? isVerified,
    double? organicScore,
    String? organicStatus,
    String? farmerId,
    DateTime? memberSince,
    String? preferredLanguage,
    Map<String, bool>? notificationPreferences,
    List<LandRecord>? landRecords,
    List<CropHistory>? cropHistory,
    PaymentDetails? paymentDetails,
  }) {
    return FarmerProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      location: location ?? this.location,
      farmArea: farmArea ?? this.farmArea,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      isVerified: isVerified ?? this.isVerified,
      organicScore: organicScore ?? this.organicScore,
      organicStatus: organicStatus ?? this.organicStatus,
      farmerId: farmerId ?? this.farmerId,
      memberSince: memberSince ?? this.memberSince,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      notificationPreferences: notificationPreferences ?? this.notificationPreferences,
      landRecords: landRecords ?? this.landRecords,
      cropHistory: cropHistory ?? this.cropHistory,
      paymentDetails: paymentDetails ?? this.paymentDetails,
    );
  }
}

class LandRecord {
  final String id;
  final double area;
  final String surveyNumber;
  final String soilType;
  final String waterSource;
  final String district;
  final String state;
  final List<String> documents;
  final DateTime createdAt;

  LandRecord({
    required this.id,
    required this.area,
    required this.surveyNumber,
    required this.soilType,
    required this.waterSource,
    required this.district,
    required this.state,
    this.documents = const [],
    required this.createdAt,
  });

  factory LandRecord.fromJson(Map<String, dynamic> json) {
    return LandRecord(
      id: json['id'] ?? '',
      area: (json['area'] ?? 0.0).toDouble(),
      surveyNumber: json['surveyNumber'] ?? '',
      soilType: json['soilType'] ?? '',
      waterSource: json['waterSource'] ?? '',
      district: json['district'] ?? '',
      state: json['state'] ?? '',
      documents: json['documents'] != null ? List<String>.from(json['documents']) : [],
      createdAt: json['createdAt'] != null ? (json['createdAt'] as dynamic).toDate() : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'area': area,
      'surveyNumber': surveyNumber,
      'soilType': soilType,
      'waterSource': waterSource,
      'district': district,
      'state': state,
      'documents': documents,
      'createdAt': createdAt,
    };
  }

  LandRecord copyWith({
    String? id,
    double? area,
    String? surveyNumber,
    String? soilType,
    String? waterSource,
    String? district,
    String? state,
    List<String>? documents,
    DateTime? createdAt,
  }) {
    return LandRecord(
      id: id ?? this.id,
      area: area ?? this.area,
      surveyNumber: surveyNumber ?? this.surveyNumber,
      soilType: soilType ?? this.soilType,
      waterSource: waterSource ?? this.waterSource,
      district: district ?? this.district,
      state: state ?? this.state,
      documents: documents ?? this.documents,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class CropHistory {
  final String id;
  final String cropName;
  final String season;
  final double cropYield;
  final double profit;
  final DateTime plantingDate;
  final DateTime harvestDate;
  final double area;

  CropHistory({
    required this.id,
    required this.cropName,
    required this.season,
    required this.cropYield,
    required this.profit,
    required this.plantingDate,
    required this.harvestDate,
    required this.area,
  });

  factory CropHistory.fromJson(Map<String, dynamic> json) {
    return CropHistory(
      id: json['id'] ?? '',
      cropName: json['cropName'] ?? '',
      season: json['season'] ?? '',
      cropYield: (json['cropYield'] ?? 0.0).toDouble(),
      profit: (json['profit'] ?? 0.0).toDouble(),
      plantingDate: json['plantingDate'] != null ? (json['plantingDate'] as dynamic).toDate() : DateTime.now(),
      harvestDate: json['harvestDate'] != null ? (json['harvestDate'] as dynamic).toDate() : DateTime.now(),
      area: (json['area'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cropName': cropName,
      'season': season,
      'cropYield': cropYield,
      'profit': profit,
      'plantingDate': plantingDate,
      'harvestDate': harvestDate,
      'area': area,
    };
  }

  CropHistory copyWith({
    String? id,
    String? cropName,
    String? season,
    double? cropYield,
    double? profit,
    DateTime? plantingDate,
    DateTime? harvestDate,
    double? area,
  }) {
    return CropHistory(
      id: id ?? this.id,
      cropName: cropName ?? this.cropName,
      season: season ?? this.season,
      cropYield: cropYield ?? this.cropYield,
      profit: profit ?? this.profit,
      plantingDate: plantingDate ?? this.plantingDate,
      harvestDate: harvestDate ?? this.harvestDate,
      area: area ?? this.area,
    );
  }
}

class PaymentDetails {
  final String bankName;
  final String accountNumber;
  final String accountHolder;
  final String ifscCode;
  final String upiId;
  final List<PaymentTransaction> transactionHistory;

  const PaymentDetails({
    this.bankName = 'SBI',
    this.accountNumber = 'XXXXXXXXXXXX1234',
    this.accountHolder = 'Farmer Name',
    this.ifscCode = 'SBIN0001234',
    this.upiId = 'farmer@upi',
    this.transactionHistory = const [],
  });

  factory PaymentDetails.fromJson(Map<String, dynamic> json) {
    return PaymentDetails(
      bankName: json['bankName'] ?? 'SBI',
      accountNumber: json['accountNumber'] ?? 'XXXXXXXXXXXX1234',
      accountHolder: json['accountHolder'] ?? 'Farmer Name',
      ifscCode: json['ifscCode'] ?? 'SBIN0001234',
      upiId: json['upiId'] ?? 'farmer@upi',
      transactionHistory: json['transactions'] != null 
          ? (json['transactions'] as List).map((i) => PaymentTransaction.fromJson(i)).toList() 
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bankName': bankName,
      'accountNumber': accountNumber,
      'accountHolder': accountHolder,
      'ifscCode': ifscCode,
      'upiId': upiId,
      'transactions': transactionHistory.map((e) => e.toJson()).toList(),
    };
  }

  PaymentDetails copyWith({
    String? bankName,
    String? accountNumber,
    String? accountHolder,
    String? ifscCode,
    String? upiId,
    List<PaymentTransaction>? transactionHistory,
  }) {
    return PaymentDetails(
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      accountHolder: accountHolder ?? this.accountHolder,
      ifscCode: ifscCode ?? this.ifscCode,
      upiId: upiId ?? this.upiId,
      transactionHistory: transactionHistory ?? this.transactionHistory,
    );
  }
}

class PaymentTransaction {
  final String id;
  final double amount;
  final String type; // 'credit' or 'debit'
  final String description;
  final DateTime date;
  final String status; // 'completed', 'pending', 'failed'

  PaymentTransaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.description,
    required this.date,
    required this.status,
  });

  factory PaymentTransaction.fromJson(Map<String, dynamic> json) {
    return PaymentTransaction(
      id: json['id'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      type: json['type'] ?? 'credit',
      description: json['description'] ?? '',
      date: json['date'] != null ? (json['date'] as dynamic).toDate() : DateTime.now(),
      status: json['status'] ?? 'completed',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'type': type,
      'description': description,
      'date': date,
      'status': status,
    };
  }
}

class FarmReport {
  final String id;
  final String type;
  final String title;
  final String description;
  final DateTime generatedDate;
  final String fileUrl;

  FarmReport({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.generatedDate,
    required this.fileUrl,
  });
}

enum NotificationType {
  weather_alerts,
  pest_alerts,
  market_price_alerts,
  order_notifications,
  government_schemes,
}
