import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:kurukshetra/features/profile/providers/profile_provider.dart';
import 'package:kurukshetra/features/profile/models/farmer_profile.dart';

class LandRecordsScreen extends ConsumerStatefulWidget {
  const LandRecordsScreen({super.key});

  @override
  ConsumerState<LandRecordsScreen> createState() => _LandRecordsScreenState();
}

class _LandRecordsScreenState extends ConsumerState<LandRecordsScreen> {
  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF9),
      appBar: AppBar(
        title: const Text('Land Records', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        backgroundColor: const Color(0xFFF9FBF9),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: () => _addLandRecord(),
            icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primaryGreen, size: 28),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: profileState.profile == null
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen))
          : profileState.profile!.landRecords.isEmpty
              ? _buildEmptyState()
              : _buildLandRecordsList(profileState.profile!.landRecords),
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
            child: Icon(Icons.description_outlined, size: 80, color: Colors.grey.shade300),
          ),
          const SizedBox(height: 32),
          const Text('No Land Records', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 12),
          Text(
            'Securely store and manage your official\nland ownership certificates here.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500, height: 1.5),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _addLandRecord(),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Your First Record', style: TextStyle(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLandRecordsList(List<LandRecord> landRecords) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
      itemCount: landRecords.length,
      itemBuilder: (context, index) {
        final record = landRecords[index];
        return _buildLandRecordCard(record);
      },
    );
  }

  Widget _buildLandRecordCard(LandRecord record) {
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
                  child: const Icon(Icons.article_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Survey #${record.surveyNumber}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                      Text('${record.district}, ${record.state}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                _buildActionMenu(record),
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
                    _buildQuickStat('Area', '${record.area} Ac', Icons.square_foot_rounded),
                    _buildQuickStat('Soil', record.soilType, Icons.grass_rounded),
                    _buildQuickStat('Water', record.waterSource, Icons.water_drop_rounded),
                  ],
                ),
                if (record.documents.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      Icon(Icons.attach_file_rounded, size: 16, color: Colors.grey),
                      SizedBox(width: 8),
                      Text('Verification Documents', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: record.documents.length,
                      itemBuilder: (context, idx) => Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            const Icon(Icons.description, size: 14, color: AppColors.primaryGreen),
                            const SizedBox(width: 6),
                            Text(record.documents[idx].split('/').last, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade400),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildActionMenu(LandRecord record) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'edit') _editLandRecord(record);
        if (value == 'delete') _deleteLandRecord(record.id);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      icon: Icon(Icons.more_vert_rounded, color: Colors.grey.shade600),
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit_outlined), SizedBox(width: 8), Text('Edit Details')])),
        const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete_outline, color: Colors.red), SizedBox(width: 8), Text('Delete Record', style: TextStyle(color: Colors.red))])),
      ],
    );
  }

  void _addLandRecord() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddEditLandRecordScreen()));
  }

  void _editLandRecord(LandRecord record) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddEditLandRecordScreen(record: record)));
  }

  void _deleteLandRecord(String recordId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Delete Land Record', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('This action cannot be undone. Are you sure you want to remove this record?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(profileProvider.notifier).deleteLandRecord(recordId);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class AddEditLandRecordScreen extends ConsumerStatefulWidget {
  final LandRecord? record;
  const AddEditLandRecordScreen({super.key, this.record});
  @override
  ConsumerState<AddEditLandRecordScreen> createState() => _AddEditLandRecordScreenState();
}

class _AddEditLandRecordScreenState extends ConsumerState<AddEditLandRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _areaController = TextEditingController();
  final _surveyController = TextEditingController();
  final _districtController = TextEditingController();
  final _stateController = TextEditingController();
  String _soilType = 'Black Soil';
  String _waterSource = 'Borewell';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.record != null) {
      _areaController.text = widget.record!.area.toString();
      _surveyController.text = widget.record!.surveyNumber;
      _districtController.text = widget.record!.district;
      _stateController.text = widget.record!.state;
      _soilType = widget.record!.soilType;
      _waterSource = widget.record!.waterSource;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF9),
      appBar: AppBar(
        title: Text(widget.record == null ? 'Add Land Record' : 'Edit Land Record', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
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
              _buildModernTextField(_surveyController, 'Survey Number', Icons.description_outlined),
              const SizedBox(height: 20),
              _buildModernTextField(_areaController, 'Farm Area (Acres)', Icons.agriculture_outlined, isNumber: true),
              const SizedBox(height: 20),
              _buildModernDropdown('Soil Type', _soilType, ['Black Soil', 'Red Soil', 'Clay Soil', 'Sandy Soil', 'Loamy Soil'], (v) => setState(() => _soilType = v!)),
              const SizedBox(height: 20),
              _buildModernDropdown('Water Source', _waterSource, ['Borewell', 'Canal', 'Well', 'Rainfed', 'Drip Irrigation'], (v) => setState(() => _waterSource = v!)),
              const SizedBox(height: 20),
              _buildModernTextField(_districtController, 'District', Icons.location_city_outlined),
              const SizedBox(height: 20),
              _buildModernTextField(_stateController, 'State', Icons.map_outlined),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _save,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('SAVE RECORD', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1)),
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
      validator: (v) => (v == null || v.isEmpty) ? 'Required field' : null,
    );
  }

  Widget _buildModernDropdown(String label, String val, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      initialValue: val,
      items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.tune_rounded, color: AppColors.primaryGreen),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2)),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final landRecord = LandRecord(
        id: widget.record?.id ?? DateTime.now().toString(),
        area: double.parse(_areaController.text),
        surveyNumber: _surveyController.text.trim(),
        soilType: _soilType,
        waterSource: _waterSource,
        district: _districtController.text.trim(),
        state: _stateController.text.trim(),
        createdAt: widget.record?.createdAt ?? DateTime.now(),
      );
      if (widget.record == null) await ref.read(profileProvider.notifier).addLandRecord(landRecord);
      else await ref.read(profileProvider.notifier).updateLandRecord(landRecord);
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
