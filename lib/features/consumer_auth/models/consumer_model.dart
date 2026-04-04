class ConsumerModel {
  final String id;
  final String fullName;
  final String phone;
  final String email;
  final String address;
  final String city;
  final String pincode;

  ConsumerModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.address,
    required this.city,
    required this.pincode,
  });

  factory ConsumerModel.fromJson(Map<String, dynamic> json) {
    return ConsumerModel(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      pincode: json['pincode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'phone': phone,
      'email': email,
      'address': address,
      'city': city,
      'pincode': pincode,
    };
  }
}
