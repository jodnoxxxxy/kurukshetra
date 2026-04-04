import 'package:flutter/material.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kurukshetra/features/warehouse/providers/warehouse_provider.dart';
import 'package:kurukshetra/features/warehouse/models/warehouse_model.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final Warehouse warehouse;

  const BookingScreen({super.key, required this.warehouse});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _notesController = TextEditingController();
  
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedProduct;
  String? _farmerId;
  String? _farmerName;

  @override
  void initState() {
    super.initState();
    _initializeFarmer();
    _startDate = DateTime.now();
    _endDate = DateTime.now().add(const Duration(days: 30));
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _initializeFarmer() async {
    final prefs = await SharedPreferences.getInstance();
    _farmerId = prefs.getString('user_id') ?? 'farmer_1';
    _farmerName = prefs.getString('user_name') ?? 'Ramesh Farmer';
  }

  @override
  Widget build(BuildContext context) {
    final warehouseState = ref.watch(warehouseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Warehouse'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: warehouseState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Warehouse Summary
                    _buildWarehouseSummary(),
                    
                    const SizedBox(height: 24),
                    
                    // Product Selection
                    _buildProductSelection(),
                    
                    const SizedBox(height: 24),
                    
                    // Quantity Input
                    _buildQuantityInput(),
                    
                    const SizedBox(height: 24),
                    
                    // Date Selection
                    _buildDateSelection(),
                    
                    const SizedBox(height: 24),
                    
                    // Notes
                    _buildNotesSection(),
                    
                    const SizedBox(height: 24),
                    
                    // Price Calculation
                    _buildPriceCalculation(),
                    
                    const SizedBox(height: 32),
                    
                    // Book Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _handleBooking,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Confirm Booking',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildWarehouseSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.warehouse.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                widget.warehouse.location,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Available: ${widget.warehouse.availableCapacity.toInt()} tons',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '₹${widget.warehouse.pricePerTonPerDay.toInt()}/ton/day',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Product',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: _selectedProduct,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          hint: const Text('Choose a product'),
          items: widget.warehouse.availableProducts.map((product) {
            return DropdownMenuItem(
              value: product,
              child: Text(product),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => _selectedProduct = value);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a product';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildQuantityInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quantity (tons)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _quantityController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            hintText: 'Enter quantity in tons',
            helperText: 'Max available: ${widget.warehouse.availableCapacity.toInt()} tons',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter quantity';
            }
            final quantity = double.tryParse(value);
            if (quantity == null) {
              return 'Please enter a valid number';
            }
            if (quantity <= 0) {
              return 'Quantity must be greater than 0';
            }
            if (quantity > widget.warehouse.availableCapacity) {
              return 'Quantity exceeds available capacity';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDateSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Storage Duration',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: _selectStartDate,
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    labelText: 'Start Date',
                  ),
                  child: Text(
                    _startDate != null
                        ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                        : 'Select start date',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: _selectEndDate,
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    labelText: 'End Date',
                  ),
                  child: Text(
                    _endDate != null
                        ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                        : 'Select end date',
                  ),
                ),
              ),
            ),
          ],
        ),
        if (_startDate != null && _endDate != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Duration: ${_endDate!.difference(_startDate!).inDays} days',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Additional Notes (Optional)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _notesController,
          maxLines: 3,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            hintText: 'Add any special requirements or notes...',
          ),
        ),
      ],
    );
  }

  Widget _buildPriceCalculation() {
    final quantity = double.tryParse(_quantityController.text) ?? 0;
    final durationDays = _startDate != null && _endDate != null
        ? _endDate!.difference(_startDate!).inDays
        : 0;
    final totalPrice = quantity * widget.warehouse.pricePerTonPerDay * durationDays;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Price Breakdown',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _buildPriceRow('Quantity', '${quantity.toInt()} tons'),
          _buildPriceRow('Duration', '$durationDays days'),
          _buildPriceRow('Rate per ton/day', '₹${widget.warehouse.pricePerTonPerDay.toInt()}'),
          const Divider(),
          _buildPriceRow(
            'Total Price',
            '₹${totalPrice.toInt()}',
            isBold: true,
            color: AppColors.primaryGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _startDate = date);
      // Adjust end date if it's before start date
      if (_endDate != null && _endDate!.isBefore(_startDate!)) {
        _endDate = _startDate!.add(const Duration(days: 30));
      }
    }
  }

  Future<void> _selectEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _endDate = date);
    }
  }

  void _handleBooking() async {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select start and end dates')),
      );
      return;
    }
    if (_farmerId == null || _farmerName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User information not available')),
      );
      return;
    }

    final quantity = double.parse(_quantityController.text);

    try {
      await ref.read(warehouseProvider.notifier).bookWarehouse(
        warehouseId: widget.warehouse.id,
        farmerId: _farmerId!,
        farmerName: _farmerName!,
        productName: _selectedProduct!,
        quantity: quantity,
        startDate: _startDate!,
        endDate: _endDate!,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Warehouse booked successfully!')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking failed: $e')),
        );
      }
    }
  }
}
