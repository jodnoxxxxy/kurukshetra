import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:kurukshetra/features/profile/providers/profile_provider.dart';
import 'package:kurukshetra/features/profile/models/farmer_profile.dart';

class CropHistoryScreen extends ConsumerStatefulWidget {
  const CropHistoryScreen({super.key});

  @override
  ConsumerState<CropHistoryScreen> createState() => _CropHistoryScreenState();
}

class _CropHistoryScreenState extends ConsumerState<CropHistoryScreen> {
  String _selectedSeason = 'All';

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF9),
      appBar: AppBar(
        title: const Text('Crop History', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        backgroundColor: const Color(0xFFF9FBF9),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: () => _addCropHistory(),
            icon: const Icon(Icons.add_chart_rounded, color: AppColors.primaryGreen, size: 28),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: profileState.profile == null
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen))
          : Column(
              children: [
                _buildSeasonFilter(),
                Expanded(
                  child: _buildCropHistoryList(profileState.profile!.cropHistory),
                ),
              ],
            ),
    );
  }

  Widget _buildSeasonFilter() {
    final seasons = ['All', 'Kharif', 'Rabi', 'Zaid'];
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: seasons.length,
        itemBuilder: (ctx, i) {
          final s = seasons[i];
          final selected = _selectedSeason == s;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ChoiceChip(
              label: Text(s),
              selected: selected,
              onSelected: (v) => setState(() => _selectedSeason = s),
              selectedColor: AppColors.primaryGreen,
              backgroundColor: Colors.white,
              labelStyle: TextStyle(color: selected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: selected ? AppColors.primaryGreen : Colors.grey.shade200)),
              elevation: selected ? 4 : 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCropHistoryList(List<CropHistory> cropHistory) {
    List<CropHistory> filtered = _selectedSeason == 'All' 
        ? cropHistory 
        : cropHistory.where((c) => c.season == _selectedSeason).toList();

    if (filtered.isEmpty) return _buildEmptyState();

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
      itemCount: filtered.length,
      itemBuilder: (ctx, i) => _buildCropHistoryCard(filtered[i]),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20)]),
            child: Icon(Icons.history_rounded, size: 80, color: Colors.grey.shade300),
          ),
          const SizedBox(height: 32),
          const Text('No Records Found', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 12),
          Text(
            'Track your growth journey by adding\nyour past harvest records.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildCropHistoryCard(CropHistory crop) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.primaryGreen, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.eco_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(crop.cropName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                      Text(crop.season, style: TextStyle(fontSize: 12, color: AppColors.primaryGreen, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                _buildActionMenu(crop),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildQuickStat('Yield', '${crop.cropYield} q', Icons.inventory_2_rounded, Colors.green),
                    _buildQuickStat('Profit', '₹${crop.profit.toInt()}', Icons.payments_rounded, Colors.blue),
                    _buildQuickStat('Area', '${crop.area} Ac', Icons.square_foot_rounded, Colors.orange),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDateInfo('PLANTED', crop.plantingDate),
                    _buildDateInfo('HARVESTED', crop.harvestDate),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 18, color: color.withValues(alpha: 0.6)),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildDateInfo(String label, DateTime date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.grey, letterSpacing: 1)),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.calendar_today_rounded, size: 12, color: Colors.black54),
            const SizedBox(width: 6),
            Text('${date.day}/${date.month}/${date.year}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
          ],
        ),
      ],
    );
  }

  Widget _buildActionMenu(CropHistory crop) {
    return PopupMenuButton<String>(
      onSelected: (v) {
        if (v == 'edit') _editCropHistory(crop);
        if (v == 'delete') _deleteCropHistory(crop.id);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      icon: Icon(Icons.more_vert_rounded, color: Colors.grey.shade600),
      itemBuilder: (ctx) => [
        const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit_outlined), SizedBox(width: 8), Text('Edit')])),
        const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete_outline, color: Colors.red), SizedBox(width: 8), Text('Delete', style: TextStyle(color: Colors.red))])),
      ],
    );
  }

  void _addCropHistory() {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => AddEditCropHistoryScreen()));
  }

  void _editCropHistory(CropHistory crop) {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => AddEditCropHistoryScreen(crop: crop)));
  }

  void _deleteCropHistory(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Confirm Delete'),
        content: const Text('Remove this harvest record permanently?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('CANCEL')),
          ElevatedButton(
            onPressed: () { 
              Navigator.pop(ctx);
              // Implement delete logic if needed
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
  }
}

class AddEditCropHistoryScreen extends ConsumerStatefulWidget {
  final CropHistory? crop;
  const AddEditCropHistoryScreen({super.key, this.crop});
  @override
  ConsumerState<AddEditCropHistoryScreen> createState() => _AddEditCropHistoryScreenState();
}

class _AddEditCropHistoryScreenState extends ConsumerState<AddEditCropHistoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _yieldController = TextEditingController();
  final _profitController = TextEditingController();
  final _areaController = TextEditingController();
  String _season = 'Kharif';
  DateTime _plantingDate = DateTime.now();
  DateTime _harvestDate = DateTime.now().add(const Duration(days: 120));
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.crop != null) {
      _nameController.text = widget.crop!.cropName;
      _yieldController.text = widget.crop!.cropYield.toString();
      _profitController.text = widget.crop!.profit.toString();
      _areaController.text = widget.crop!.area.toString();
      _season = widget.crop!.season;
      _plantingDate = widget.crop!.plantingDate;
      _harvestDate = widget.crop!.harvestDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF9),
      appBar: AppBar(
        title: Text(widget.crop == null ? 'Record Harvest' : 'Edit Record', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        backgroundColor: const Color(0xFFF9FBF9),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildModernTextField(_nameController, 'Crop Name', Icons.agriculture_outlined),
              const SizedBox(height: 20),
              _buildModernDropdown('Season', _season, ['Kharif', 'Rabi', 'Zaid'], (v) => setState(() => _season = v!)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _buildDatePicker('Planting', _plantingDate, (d) => setState(() => _plantingDate = d))),
                  const SizedBox(width: 16),
                  Expanded(child: _buildDatePicker('Harvest', _harvestDate, (d) => setState(() => _harvestDate = d))),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _buildModernTextField(_yieldController, 'Yield (q)', Icons.inventory_2_outlined, isNumber: true)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildModernTextField(_profitController, 'Profit (₹)', Icons.payments_outlined, isNumber: true)),
                ],
              ),
              const SizedBox(height: 20),
              _buildModernTextField(_areaController, 'Farm Area (Acres)', Icons.square_foot_outlined, isNumber: true),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _save,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('SAVE HARVEST RECORD', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernTextField(TextEditingController controller, String label, IconData icon, {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primaryGreen),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2)),
      ),
      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
    );
  }

  Widget _buildModernDropdown(String label, String val, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      initialValue: val,
      items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.eco_rounded, color: AppColors.primaryGreen),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2)),
      ),
    );
  }

  Widget _buildDatePicker(String label, DateTime date, Function(DateTime) onPicked) {
    return InkWell(
      onTap: () async {
        final d = await showDatePicker(context: context, initialDate: date, firstDate: DateTime(2020), lastDate: DateTime(2030));
        if (d != null) onPicked(d);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Text('${date.day}/${date.month}/${date.year}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final h = CropHistory(
        id: widget.crop?.id ?? DateTime.now().toString(),
        cropName: _nameController.text,
        season: _season,
        cropYield: double.parse(_yieldController.text),
        profit: double.parse(_profitController.text),
        plantingDate: _plantingDate,
        harvestDate: _harvestDate,
        area: double.parse(_areaController.text),
      );
      await ref.read(profileProvider.notifier).addCropHistory(h);
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
