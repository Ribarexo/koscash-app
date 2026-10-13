import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionProvider with ChangeNotifier {
  final List<TransactionModel> _transactions = [
    // Data dummy awal untuk pengujian
    TransactionModel(
      id: '1',
      title: 'Nasi Goreng Ayam',
      amount: 15000,
      category: 'Makan',
      isExpense: true,
      date: DateTime.now(),
    ),
    TransactionModel(
      id: '2',
      title: 'Transfer Uang Saku',
      amount: 1500000,
      category: 'Pemasukan',
      isExpense: false,
      date: DateTime.now(),
    ),
  ];

  // Batas Anggaran Bulanan Dummy
  final double _monthlyBudget = 1000000;

  List<TransactionModel> get transactions => [..._transactions];

  double get totalExpense {
    return _transactions
        .where((tx) => tx.isExpense)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  double get totalIncome {
    return _transactions
        .where((tx) => !tx.isExpense)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  double get remainingBudget => _monthlyBudget - totalExpense;

  void addTransaction(TransactionModel tx) {
    _transactions.insert(0, tx);
    notifyListeners(); // Memperbarui tampilan UI secara otomatis
  }
}