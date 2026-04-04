enum WarehouseStatus { active, inactive, maintenance }

enum StorageType { cold, dry, refrigerated, ventilated }

class Warehouse {
  final String id;
  final String name;
  final String location;
  final String address;
  final double capacity; // in tons
  final double currentOccupancy; // in tons
  final StorageType storageType;
  final WarehouseStatus status;
  final List<String> availableProducts;
  final double temperature; // for cold storage
  final double humidity; // percentage
  final String contactPerson;
  final String contactPhone;
  final double pricePerTonPerDay;
  final List<String> images;
  final DateTime createdAt;
  final DateTime? lastUpdated;

  Warehouse({
    required this.id,
    required this.name,
    required this.location,
    required this.address,
    required this.capacity,
    required this.currentOccupancy,
    required this.storageType,
    required this.status,
    required this.availableProducts,
    required this.temperature,
    required this.humidity,
    required this.contactPerson,
    required this.contactPhone,
    required this.pricePerTonPerDay,
    required this.images,
    required this.createdAt,
    this.lastUpdated,
  });

  double get occupancyPercentage => (currentOccupancy / capacity) * 100;
  bool get isAvailable => status == WarehouseStatus.active && currentOccupancy < capacity;
  double get availableCapacity => capacity - currentOccupancy;

  Warehouse copyWith({
    String? id,
    String? name,
    String? location,
    String? address,
    double? capacity,
    double? currentOccupancy,
    StorageType? storageType,
    WarehouseStatus? status,
    List<String>? availableProducts,
    double? temperature,
    double? humidity,
    String? contactPerson,
    String? contactPhone,
    double? pricePerTonPerDay,
    List<String>? images,
    DateTime? createdAt,
    DateTime? lastUpdated,
  }) {
    return Warehouse(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      address: address ?? this.address,
      capacity: capacity ?? this.capacity,
      currentOccupancy: currentOccupancy ?? this.currentOccupancy,
      storageType: storageType ?? this.storageType,
      status: status ?? this.status,
      availableProducts: availableProducts ?? this.availableProducts,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      contactPerson: contactPerson ?? this.contactPerson,
      contactPhone: contactPhone ?? this.contactPhone,
      pricePerTonPerDay: pricePerTonPerDay ?? this.pricePerTonPerDay,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

class WarehouseBooking {
  final String id;
  final String warehouseId;
  final String farmerId;
  final String farmerName;
  final String productName;
  final double quantity; // in tons
  final DateTime startDate;
  final DateTime endDate;
  final double totalPrice;
  final BookingStatus status;
  final DateTime createdAt;
  final String? notes;

  WarehouseBooking({
    required this.id,
    required this.warehouseId,
    required this.farmerId,
    required this.farmerName,
    required this.productName,
    required this.quantity,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    this.notes,
  });

  int get durationDays => endDate.difference(startDate).inDays;

  WarehouseBooking copyWith({
    String? id,
    String? warehouseId,
    String? farmerId,
    String? farmerName,
    String? productName,
    double? quantity,
    DateTime? startDate,
    DateTime? endDate,
    double? totalPrice,
    BookingStatus? status,
    DateTime? createdAt,
    String? notes,
  }) {
    return WarehouseBooking(
      id: id ?? this.id,
      warehouseId: warehouseId ?? this.warehouseId,
      farmerId: farmerId ?? this.farmerId,
      farmerName: farmerName ?? this.farmerName,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
    );
  }
}

enum BookingStatus { pending, confirmed, active, completed, cancelled }
