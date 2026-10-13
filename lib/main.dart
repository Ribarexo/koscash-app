import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:koscash_app/providers/transaction_provider.dart';
import 'package:koscash_app/models/transaction.dart';
import 'package:koscash_app/widgets/add_transaction_modal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
      ],
      child: const KosCashApp(),
    ),
  );
}

class KosCashApp extends StatelessWidget {
  const KosCashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KosCash',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00A86B)),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final txProvider = Provider.of<TransactionProvider>(context);
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'KosCash Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF00A86B),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: const Color(0xFF00A86B),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sisa Anggaran Harian/Bulanan',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currencyFormatter.format(txProvider.remainingBudget),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(color: Colors.white24, height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pemasukan: ${currencyFormatter.format(txProvider.totalIncome)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Pengeluaran: ${currencyFormatter.format(txProvider.totalExpense)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Riwayat Transaksi Terakhir',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: txProvider.transactions.length,
              itemBuilder: (ctx, index) {
                final tx = txProvider.transactions[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                      tx.isExpense
                          ? Colors.red.shade100
                          : Colors.green.shade100,
                      child: Icon(
                        tx.isExpense
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        color: tx.isExpense ? Colors.red : Colors.green,
                      ),
                    ),
                    title: Text(
                      tx.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${tx.category} • ${DateFormat('dd MMM yyyy', 'id_ID').format(tx.date)}',
                    ),
                    trailing: Text(
                      '${tx.isExpense ? "-" : "+"}${currencyFormatter.format(tx.amount)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: tx.isExpense ? Colors.red : Colors.green,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => const AddTransactionModal(),
          );
        },
        backgroundColor: const Color(0xFF00A86B),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}