import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/calculator_models.dart';

class SelectedSeason extends Notifier<String> {
  @override
  String build() => 'Kharif';
  
  void update(String value) => state = value;
}

final selectedSeasonProvider = NotifierProvider<SelectedSeason, String>(SelectedSeason.new);

class SelectedYear extends Notifier<String> {
  @override
  String build() => DateTime.now().year.toString();

  void update(String value) => state = value;
}

final selectedYearProvider = NotifierProvider<SelectedYear, String>(SelectedYear.new);

class CalculatorNotifier extends Notifier<CalculatorState> {
  @override
  CalculatorState build() {
    _loadData();
    return CalculatorState(crops: [], transactions: []);
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final cropsStr = prefs.getString('calc_crops');
    final transactionsStr = prefs.getString('calc_transactions');

    List<CalcCrop> crops = [];
    List<Transaction> transactions = [];

    if (cropsStr != null) {
      final List<dynamic> jsonList = jsonDecode(cropsStr);
      crops = jsonList.map((e) => CalcCrop.fromJson(e)).toList();
    }

    if (transactionsStr != null) {
      final List<dynamic> jsonList = jsonDecode(transactionsStr);
      transactions = jsonList.map((e) => Transaction.fromJson(e)).toList();
    }

    state = CalculatorState(crops: crops, transactions: transactions);
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'calc_crops',
      jsonEncode(state.crops.map((e) => e.toJson()).toList()),
    );
    await prefs.setString(
      'calc_transactions',
      jsonEncode(state.transactions.map((e) => e.toJson()).toList()),
    );
  }

  void addCrop(CalcCrop crop) {
    if (!state.crops.any((c) => c.id == crop.id)) {
      state = CalculatorState(
        crops: [...state.crops, crop],
        transactions: state.transactions,
      );
      _saveData();
    }
  }

  void removeCrop(String cropId) {
    state = CalculatorState(
      crops: state.crops.where((c) => c.id != cropId).toList(),
      transactions: state.transactions.where((t) => t.cropId != cropId).toList(),
    );
    _saveData();
  }

  void addTransaction(String cropId, String type, String category, String name, double amount, DateTime date, {double? yieldAmount, double? pricePerUnit}) {
    final newTransaction = Transaction(
      id: const Uuid().v4(),
      cropId: cropId,
      type: type,
      category: category,
      name: name.isEmpty ? category : name,
      amount: amount,
      date: date,
      yieldAmount: yieldAmount,
      pricePerUnit: pricePerUnit,
    );
    state = CalculatorState(
      crops: state.crops,
      transactions: [...state.transactions, newTransaction],
    );
    _saveData();
  }

  void removeTransaction(String transactionId) {
    state = CalculatorState(
        crops: state.crops,
        transactions: state.transactions.where((t) => t.id != transactionId).toList());
    _saveData();
  }
}

class CalculatorState {
  final List<CalcCrop> crops;
  final List<Transaction> transactions;

  CalculatorState({required this.crops, required this.transactions});

  double getTotalExpense(String? cropId) {
    var ts = transactions.where((t) => t.type == 'expense' && (cropId == null || t.cropId == cropId));
    return ts.fold(0.0, (sum, t) => sum + t.amount);
  }

  double getTotalIncome(String? cropId) {
    var ts = transactions.where((t) => t.type == 'income' && (cropId == null || t.cropId == cropId));
    return ts.fold(0.0, (sum, t) => sum + t.amount);
  }

  double getProfit(String? cropId) {
    return getTotalIncome(cropId) - getTotalExpense(cropId);
  }
}

final calculatorProvider = NotifierProvider<CalculatorNotifier, CalculatorState>(CalculatorNotifier.new);

// A hardcoded list of available crops for selection
final availableCropsProvider = Provider<List<CalcCrop>>((ref) {
  return [
    const CalcCrop(id: 'wheat', name: 'Wheat', category: 'Cereals', imageUrl: '🌾'),
    const CalcCrop(id: 'rice', name: 'Rice', category: 'Cereals', imageUrl: '🍚'),
    const CalcCrop(id: 'sugarcane', name: 'Sugarcane', category: 'Cash Crops', imageUrl: '🎋'),
    const CalcCrop(id: 'cotton', name: 'Cotton', category: 'Cash Crops', imageUrl: '☁️'),
    const CalcCrop(id: 'tomato', name: 'Tomato', category: 'Vegetables', imageUrl: '🍅'),
    const CalcCrop(id: 'potato', name: 'Potato', category: 'Vegetables', imageUrl: '🥔'),
    const CalcCrop(id: 'onion', name: 'Onion', category: 'Vegetables', imageUrl: '🧅'),
    const CalcCrop(id: 'mango', name: 'Mango', category: 'Fruits', imageUrl: '🥭'),
    const CalcCrop(id: 'banana', name: 'Banana', category: 'Fruits', imageUrl: '🍌'),
    const CalcCrop(id: 'chili', name: 'Chili', category: 'Spices', imageUrl: '🌶️'),
  ];
});
