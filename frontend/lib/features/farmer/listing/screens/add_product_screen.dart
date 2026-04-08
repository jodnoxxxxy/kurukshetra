import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedCategory = 'Vegetables';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF9),
      appBar: AppBar(
        title: const Text('New Market Listing', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        backgroundColor: const Color(0xFFF9FBF9),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImageUploader(),
              const SizedBox(height: 32),
              _buildSectionLabel('ITEM DETAILS'),
              _buildModernTextField('Crop Name', Icons.agriculture_rounded, 'e.g. Fresh Tomatoes'),
              const SizedBox(height: 20),
              _buildModernDropdown('Category', _selectedCategory, ['Vegetables', 'Fruits', 'Grains', 'Spices'], (v) => setState(() => _selectedCategory = v!)),
              const SizedBox(height: 32),
              _buildSectionLabel('INVENTORY & PRICING'),
              Row(
                children: [
                  Expanded(flex: 2, child: _buildModernTextField('Quantity', Icons.inventory_2_rounded, '0.00', isNumber: true)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildModernDropdown('Unit', 'kg', ['kg', 'tonnes', 'dozen', 'bunch'], (v) {})),
                ],
              ),
              const SizedBox(height: 20),
              _buildModernTextField('Price per Unit (₹)', Icons.payments_rounded, '0.00', isNumber: true, prefix: '₹'),
              const SizedBox(height: 32),
              _buildSectionLabel('ADDITIONAL INFO'),
              _buildModernTextField('Description & Method', Icons.description_rounded, 'Tell buyers about your crop...', isMultiline: true),
              const SizedBox(height: 48),
              _buildMainButton(context),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.grey, letterSpacing: 1.5)),
    );
  }

  Widget _buildImageUploader() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.2), width: 2, style: BorderStyle.solid),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.05), shape: BoxShape.circle),
                child: const Icon(Icons.add_a_photo_rounded, size: 40, color: AppColors.primaryGreen),
              ),
              const SizedBox(height: 16),
              const Text('Add Crop Photo', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.black87)),
              const SizedBox(height: 4),
              Text('High quality images sell 3x faster', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernTextField(String label, IconData icon, String hint, {bool isNumber = false, String? prefix, bool isMultiline = false}) {
    return TextFormField(
      keyboardType: isNumber ? TextInputType.number : (isMultiline ? TextInputType.multiline : TextInputType.text),
      maxLines: isMultiline ? 4 : 1,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primaryGreen, size: 20),
        prefixText: prefix != null ? '$prefix ' : null,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2)),
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  Widget _buildModernDropdown(String label, String val, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      initialValue: val,
      items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2)),
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  Widget _buildMainButton(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Marketplace listing published!'), behavior: SnackBarBehavior.floating),
          );
          context.pop();
        },
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), elevation: 4, shadowColor: AppColors.primaryGreen.withValues(alpha: 0.4)),
        child: const Text('PUBLISH LISTING', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 14)),
      ),
    );
  }
}
