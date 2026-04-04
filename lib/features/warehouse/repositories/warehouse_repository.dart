import 'package:kurukshetra/features/warehouse/models/warehouse_model.dart';

abstract class WarehouseRepository {
  Future<List<Warehouse>> getWarehouses();
  Future<List<WarehouseBooking>> getBookings();
  Future<Warehouse> getWarehouseById(String id);
  Future<void> createBooking(WarehouseBooking booking);
  Future<void> updateBooking(WarehouseBooking booking);
  Future<void> updateWarehouse(Warehouse warehouse);
  Future<List<WarehouseBooking>> getBookingsByFarmer(String farmerId);
}

class WarehouseRepositoryImpl implements WarehouseRepository {
  @override
  Future<List<Warehouse>> getWarehouses() async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    return [
      Warehouse(
        id: '1',
        name: 'Kisan Cold Storage',
        location: 'Pune, Maharashtra',
        address: '123 Agricultural Road, Pune - 411001',
        capacity: 500.0,
        currentOccupancy: 320.0,
        storageType: StorageType.cold,
        status: WarehouseStatus.active,
        availableProducts: ['Wheat', 'Rice', 'Vegetables', 'Fruits'],
        temperature: 4.0,
        humidity: 85.0,
        contactPerson: 'Rajesh Kumar',
        contactPhone: '+91 98765 43210',
        pricePerTonPerDay: 50.0,
        images: [
          'https://images.unsplash.com/photo-1589927986089-35812388d1b4?q=80&w=1470&auto=format&fit=crop',
          'https://images.unsplash.com/photo-1605000797496-8a6949c5d6a6?q=80&w=1470&auto=format&fit=crop',
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
        lastUpdated: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Warehouse(
        id: '2',
        name: 'Green Valley Dry Storage',
        location: 'Nashik, Maharashtra',
        address: '456 Farm Road, Nashik - 422001',
        capacity: 1000.0,
        currentOccupancy: 450.0,
        storageType: StorageType.dry,
        status: WarehouseStatus.active,
        availableProducts: ['Wheat', 'Rice', 'Pulses', 'Spices'],
        temperature: 25.0,
        humidity: 60.0,
        contactPerson: 'Suresh Patel',
        contactPhone: '+91 87654 32109',
        pricePerTonPerDay: 25.0,
        images: [
          'https://images.unsplash.com/photo-1592982506702-1a0d5d3f8bf8?q=80&w=1470&auto=format&fit=crop',
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 180)),
        lastUpdated: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Warehouse(
        id: '3',
        name: 'Fresh Farm Refrigerated Storage',
        location: 'Mumbai, Maharashtra',
        address: '789 Industrial Area, Mumbai - 400001',
        capacity: 300.0,
        currentOccupancy: 280.0,
        storageType: StorageType.refrigerated,
        status: WarehouseStatus.active,
        availableProducts: ['Dairy Products', 'Meat', 'Seafood', 'Frozen Foods'],
        temperature: -2.0,
        humidity: 90.0,
        contactPerson: 'Amit Singh',
        contactPhone: '+91 76543 21098',
        pricePerTonPerDay: 80.0,
        images: [
          'https://images.unsplash.com/photo-1589927986089-35812388d1b4?q=80&w=1470&auto=format&fit=crop',
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        lastUpdated: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      Warehouse(
        id: '4',
        name: 'Organic Storage Solutions',
        location: 'Nagpur, Maharashtra',
        address: '321 Organic Lane, Nagpur - 440001',
        capacity: 750.0,
        currentOccupancy: 200.0,
        storageType: StorageType.ventilated,
        status: WarehouseStatus.active,
        availableProducts: ['Organic Vegetables', 'Organic Fruits', 'Herbs'],
        temperature: 20.0,
        humidity: 70.0,
        contactPerson: 'Priya Deshmukh',
        contactPhone: '+91 65432 10987',
        pricePerTonPerDay: 35.0,
        images: [
          'https://images.unsplash.com/photo-1515003197210-e0cd71810b5f?q=80&w=1470&auto=format&fit=crop',
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 270)),
        lastUpdated: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }

  @override
  Future<List<WarehouseBooking>> getBookings() async {
    await Future.delayed(const Duration(milliseconds: 600));
    
    return [
      WarehouseBooking(
        id: '1',
        warehouseId: '1',
        farmerId: 'farmer_1',
        farmerName: 'Ramesh Farmer',
        productName: 'Wheat',
        quantity: 50.0,
        startDate: DateTime.now().subtract(const Duration(days: 5)),
        endDate: DateTime.now().add(const Duration(days: 25)),
        totalPrice: 125000.0,
        status: BookingStatus.active,
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
        notes: 'Premium quality wheat harvest',
      ),
      WarehouseBooking(
        id: '2',
        warehouseId: '2',
        farmerId: 'farmer_2',
        farmerName: 'Suresh Farmer',
        productName: 'Rice',
        quantity: 100.0,
        startDate: DateTime.now().add(const Duration(days: 2)),
        endDate: DateTime.now().add(const Duration(days: 32)),
        totalPrice: 75000.0,
        status: BookingStatus.confirmed,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        notes: 'Basmati rice batch',
      ),
    ];
  }

  @override
  Future<Warehouse> getWarehouseById(String id) async {
    final warehouses = await getWarehouses();
    return warehouses.firstWhere((w) => w.id == id);
  }

  @override
  Future<void> createBooking(WarehouseBooking booking) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // In a real implementation, this would save to a database
    // TODO: persist booking to backend
  }

  @override
  Future<void> updateBooking(WarehouseBooking booking) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // In a real implementation, this would update in a database
    // TODO: update booking in backend
  }

  @override
  Future<void> updateWarehouse(Warehouse warehouse) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // In a real implementation, this would update in a database
    // TODO: update warehouse in backend
  }

  @override
  Future<List<WarehouseBooking>> getBookingsByFarmer(String farmerId) async {
    final bookings = await getBookings();
    return bookings.where((b) => b.farmerId == farmerId).toList();
  }
}
