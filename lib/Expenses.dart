import 'package:budgeter/components.dart';
import 'package:budgeter/logic.dart';
import 'package:budgeter/entities.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'settingPage.dart';

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 240, 129, 65),
        title: const Text(
          "Pengeluaran",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.account_box_rounded, color: Colors.white),
          iconSize: 40,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingPage()));
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            iconSize: 40,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: ListView(
          children: [
            const Padding(padding: EdgeInsets.only(top: 10)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    size: 35,
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            Row(
              children: [
                const Padding(padding: EdgeInsets.only(left: 10)),
                Text(
                  'Input Pengeluaran',
                  textAlign: TextAlign.left,
                  style: theme.textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            const TransactionInputSection(),
            const SizedBox(height: 16),
            Text(
              'Riwayat pengeluaran',
              textAlign: TextAlign.left,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const TransactionList(),
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
      margin: const EdgeInsets.only(left: 10, right: 10),
      color: Colors.white60,
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
                    return 'Please input some value';
                  }
                  return null;
                },
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
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
              const SizedBox(height: 8),
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
              const SizedBox(height: 8),
              // form seleksi tanggal dan waktu
              CustomDateTimeFormFields(
                onSaved: (date) => _updateDate(date!),
              ),
              const SizedBox(width: 8),
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
    'Kebutuhan pokok',
    'Makanan',
    'Alat tulis',
    'Kebutuhan kuliah',
    'Uang kas'
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
      return Container(
        margin: const EdgeInsets.all(5),
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
              backgroundColor: selectedIndex == entry.key
                  ? const Color.fromARGB(169, 243, 163, 33)
                  : Colors.white),
          onPressed: () {
            selectedIndex = entry.key;
            widget.onChange(entry.value);
          },
          child: Text(
            entry.value,
            style: TextStyle(
                color: selectedIndex == entry.key
                    ? Colors.white
                    : const Color.fromARGB(169, 243, 163, 33)),
          ),
        ),
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
        const SizedBox(
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
          return const CircularProgressIndicator();
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
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                Expanded(
                  child: Text(
                    timeFormatter.format(tsc.date),
                    textAlign: TextAlign.end,
                    style: const TextStyle(fontSize: 12),
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
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        tsc.category ?? 'No Category',
                        textAlign: TextAlign.start,
                        style: const TextStyle(fontSize: 12),
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
