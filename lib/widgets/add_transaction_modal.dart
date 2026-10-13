import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:koscash_app/providers/transaction_provider.dart';
import 'package:koscash_app/models/transaction.dart';

class AddTransactionModal extends StatefulWidget {
  const AddTransactionModal({super.key});

  @override
  State<AddTransactionModal> createState() => _AddTransactionModalState();
}

class _AddTransactionModalState extends State<AddTransactionModal> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCategory = 'Makan';
  bool _isExpense = true;

  final List<String> _categories = [
    'Makan',
    'Transport',
    'Kos & Tagihan',
    'Kuliah',
    'Hiburan',
    'Pemasukan'
  ];

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.tryParse(_amountController.text) ?? 0;

    if (enteredTitle.isEmpty || enteredAmount <= 0) {
      return;
    }

    Provider.of<TransactionProvider>(context, listen: false).addTransaction(
      TransactionModel(
        id: DateTime.now().toString(),
        title: enteredTitle,
        amount: enteredAmount,
        category: _selectedCategory,
        isExpense: _isExpense,
        date: DateTime.now(),
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Tambah Transaksi Baru',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Judul Transaksi'),
          ),
          TextField(
            controller: _amountController,
            decoration: const InputDecoration(labelText: 'Jumlah (Rp)'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('Tipe Transaksi: '),
              ChoiceChip(
                label: const Text('Pengeluaran'),
                selected: _isExpense,
                onSelected: (selected) {
                  setState(() => _isExpense = true);
                },
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Pemasukan'),
                selected: !_isExpense,
                onSelected: (selected) {
                  setState(() => _isExpense = false);
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            items: _categories.map((cat) {
              return DropdownMenuItem(value: cat, child: Text(cat));
            }).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedCategory = val);
            },
            decoration: const InputDecoration(labelText: 'Kategori'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitData,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00A86B),
              foregroundColor: Colors.white,
            ),
            child: const Text('Simpan Transaksi'),
          ),
        ],
      ),
    );
  }
}