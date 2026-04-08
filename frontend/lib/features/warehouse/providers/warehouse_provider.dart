import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurukshetra/features/warehouse/models/warehouse_model.dart';
import 'package:kurukshetra/features/warehouse/repositories/warehouse_repository.dart';

final warehouseRepositoryProvider = Provider<WarehouseRepository>((ref) {
  return WarehouseRepositoryImpl();
});

class WarehouseState {
  final List<Warehouse> warehouses;
  final List<WarehouseBooking> bookings;
  final bool isLoading;
  final String? errorMessage;
  final Warehouse? selectedWarehouse;

  WarehouseState({
    this.warehouses = const [],
    this.bookings = const [],
    this.isLoading = false,
    this.errorMessage,
    this.selectedWarehouse,
  });

  WarehouseState copyWith({
    List<Warehouse>? warehouses,
    List<WarehouseBooking>? bookings,
    bool? isLoading,
    String? errorMessage,
    Warehouse? selectedWarehouse,
  }) {
    return WarehouseState(
      warehouses: warehouses ?? this.warehouses,
      bookings: bookings ?? this.bookings,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      selectedWarehouse: selectedWarehouse ?? this.selectedWarehouse,
    );
  }
}

class WarehouseNotifier extends Notifier<WarehouseState> {
  late final WarehouseRepository _repository;

  @override
  WarehouseState build() {
    _repository = ref.read(warehouseRepositoryProvider);
    _loadWarehouses();
    return WarehouseState(isLoading: true);
  }

  Future<void> _loadWarehouses() async {
    try {
      final warehouses = await _repository.getWarehouses();
      final bookings = await _repository.getBookings();
      
      state = state.copyWith(
        warehouses: warehouses,
        bookings: bookings,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to load warehouses: $e',
        isLoading: false,
      );
    }
  }

  Future<void> selectWarehouse(Warehouse warehouse) async {
    state = state.copyWith(selectedWarehouse: warehouse);
  }

  Future<void> bookWarehouse({
    required String warehouseId,
    required String farmerId,
    required String farmerName,
    required String productName,
    required double quantity,
    required DateTime startDate,
    required DateTime endDate,
    String? notes,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      final warehouse = state.warehouses.firstWhere((w) => w.id == warehouseId);
      
      if (!warehouse.isAvailable) {
        state = state.copyWith(
          errorMessage: 'Warehouse is not available for booking',
          isLoading: false,
        );
        return;
      }

      if (quantity > warehouse.availableCapacity) {
        state = state.copyWith(
          errorMessage: 'Requested quantity exceeds available capacity',
          isLoading: false,
        );
        return;
      }

      final durationDays = endDate.difference(startDate).inDays;
      final totalPrice = quantity * warehouse.pricePerTonPerDay * durationDays;

      final booking = WarehouseBooking(
        id: DateTime.now().toString(),
        warehouseId: warehouseId,
        farmerId: farmerId,
        farmerName: farmerName,
        productName: productName,
        quantity: quantity,
        startDate: startDate,
        endDate: endDate,
        totalPrice: totalPrice,
        status: BookingStatus.pending,
        createdAt: DateTime.now(),
        notes: notes,
      );

      await _repository.createBooking(booking);
      
      // Update warehouse occupancy
      final updatedWarehouse = warehouse.copyWith(
        currentOccupancy: warehouse.currentOccupancy + quantity,
        lastUpdated: DateTime.now(),
      );
      await _repository.updateWarehouse(updatedWarehouse);

      // Refresh data
      await _loadWarehouses();
      
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to book warehouse: $e',
        isLoading: false,
      );
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    state = state.copyWith(isLoading: true);

    try {
      final booking = state.bookings.firstWhere((b) => b.id == bookingId);
      
      // Update booking status
      final updatedBooking = booking.copyWith(
        status: BookingStatus.cancelled,
      );
      await _repository.updateBooking(updatedBooking);

      // Update warehouse occupancy
      final warehouse = state.warehouses.firstWhere((w) => w.id == booking.warehouseId);
      final updatedWarehouse = warehouse.copyWith(
        currentOccupancy: warehouse.currentOccupancy - booking.quantity,
        lastUpdated: DateTime.now(),
      );
      await _repository.updateWarehouse(updatedWarehouse);

      // Refresh data
      await _loadWarehouses();
      
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to cancel booking: $e',
        isLoading: false,
      );
    }
  }

  List<Warehouse> getAvailableWarehouses({StorageType? storageType}) {
    var available = state.warehouses.where((w) => w.isAvailable).toList();
    
    if (storageType != null) {
      available = available.where((w) => w.storageType == storageType).toList();
    }
    
    return available;
  }

  List<WarehouseBooking> getActiveBookings(String farmerId) {
    return state.bookings
        .where((b) => b.farmerId == farmerId && 
                     (b.status == BookingStatus.active || b.status == BookingStatus.confirmed))
        .toList();
  }
}

final warehouseProvider = NotifierProvider<WarehouseNotifier, WarehouseState>(() {
  return WarehouseNotifier();
});
