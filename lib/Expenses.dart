import 'package:budgeter/components.dart';
import 'package:budgeter/logic.dart';
import 'package:budgeter/entities.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Pengeluaran')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Text(
              'Input pengeluaran',
              textAlign: TextAlign.left,
              style: theme.textTheme.headlineSmall,
            ),
            SizedBox(height: 8),
            const TransactionInputSection(),
            SizedBox(height: 16),
            Text(
              'Riwayat pengeluaran',
              textAlign: TextAlign.left,
              style: theme.textTheme.headlineSmall,
            ),
            SizedBox(height: 8),
            TransactionList(),
          ],
        ),
      ),
    );
  }
}

class TransactionInputSection extends StatefulWidget {
  const TransactionInputSection({super.key});

  @override
  State<TransactionInputSection> createState() =>
      _TransactionInputSectionState();
}

class _TransactionInputSectionState extends State<TransactionInputSection> {
  final _formKey = GlobalKey<FormState>();
  String? txnName;
  String? txnCategory;
  int? txnAmount;
  DateTime? txnDate;

  void _updateCategory(String category) {
    setState(() {
      txnCategory = category;
    });
  }

  void _updateName(String name) {
    setState(() {
      txnName = name;
    });
  }

  void _updateAmount(int amount) {
    setState(() {
      txnAmount = amount;
    });
  }

  void _updateDate(DateTime date) {
    setState(() {
      txnDate = date;
    });
  }

  void clearInput() {
    txnName = null;
    txnCategory = null;
    txnAmount = null;
    txnDate = DateTime.now();
    _formKey.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    final value = context.watch<UserDatabase>();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // form nama pengeluaran
              CustomTextFormField(
                labelText: 'Nama pengeluaran',
                onSaved: (name) => _updateName(name!),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please input some value';
                  }
                  return null;
                },
              ),
              SizedBox(height: 8),
              // seleksi kategori pengeluaran
              Row(
                children: [
                  Expanded(
                    child: CategorySelector(
                      onChange: (str) => _updateCategory(str),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              // form jumlah pengeluaran
              CustomTextFormField(
                labelText: 'Jumlah pengeluaran',
                keyboardType: TextInputType.number,
                onSaved: (numString) => _updateAmount(int.parse(numString!)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please input some value';
                  }
                  return null;
                },
              ),
              SizedBox(height: 8),
              // form seleksi tanggal dan waktu
              CustomDateTimeFormFields(
                onSaved: (date) => _updateDate(date!),
              ),
              SizedBox(width: 8),
              // tombol simpan pengeluaran
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: ElevatedButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                    _formKey.currentState!.save();

                    final transaction = Transaction(
                      name: txnName!,
                      amount: txnAmount! * -1,
                      category: txnCategory,
                      date: txnDate!,
                      type: TransactionType.expense,
                    );

                    value.pushTransaction(transaction);
                    clearInput();
                  },
                  child: const Text('Simpan pengeluaran'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CategorySelector extends StatefulWidget {
  final Function(String) onChange;

  const CategorySelector({
    super.key,
    required this.onChange,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  var categoryList = [
    'kebutuhan pokok',
    'makanan',
    'alat tulis',
    'kebutuhan kuliah',
    'uang kas'
  ];
  int? selectedIndex;

  void resetSelection() {
    setState(() {
      selectedIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    var gridEntries = categoryList.asMap().entries.map((entry) {
      if (selectedIndex == entry.key) {}
      return OutlinedButton(
        style: OutlinedButton.styleFrom(
            backgroundColor:
                selectedIndex == entry.key ? Colors.blue : Colors.white),
        onPressed: () {
          selectedIndex = entry.key;
          widget.onChange(entry.value);
        },
        child: Text(entry.value),
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pilih kategori',
          textAlign: TextAlign.left,
          style: theme.textTheme.labelLarge,
        ),
        SizedBox(
          height: 4,
        ),
        Wrap(
          spacing: 8,
          runSpacing: 0,
          children: gridEntries,
        )
      ],
    );
  }
}

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    final currDate = DateTime.now();
    final value = context.watch<UserDatabase>();

    return FutureBuilder(
      future: value.fetchTransactions(currDate.month, currDate.year),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children:
                snapshot.data!.map((txn) => TransactionCard(tsc: txn)).toList(),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

/// Card yang merepresentasikan transaksi
class TransactionCard extends StatelessWidget {
  TransactionCard({super.key, required this.tsc});

  final Transaction tsc;
  final dateFormatter = DateFormat('dd MMMM');
  final timeFormatter = DateFormat('HH:mm');
  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp.');

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    dateFormatter.format(tsc.date),
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                Expanded(
                  child: Text(
                    timeFormatter.format(tsc.date),
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tsc.name,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        tsc.category ?? 'No Category',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Text(
                  currencyFormatter.format(tsc.amount),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    color: tsc.type == TransactionType.expense
                        ? Colors.red
                        : Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
