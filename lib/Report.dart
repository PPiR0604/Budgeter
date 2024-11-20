import 'package:budgeter/Entitas/Pemasukan.dart';
import 'package:budgeter/entities.dart';
import 'package:budgeter/logic.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'settingPage.dart';

class ReportPage extends StatefulWidget {
  ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  List<PemasukanData> pemasukan = [];

  double TotalPemasukan = 0;

  String? selectedItem;
  String? selectedCategoryIn;
  String? selectedCategoryOut;
  int? selectedIndexIn;
  int? selectedIndexout;

  void UpdateDropdown(String newValue) {
    setState(() {
      selectedItem = newValue;
    });
  }

  void UpdateCategoryIn(String newValue) {
    setState(() {
      selectedCategoryIn = newValue;
    });
  }

  void UpdateIndexOut(int newValue) {
    setState(() {
      selectedIndexout = newValue;
    });
  }

  void UpdateIndexIn(int newValue) {
    setState(() {
      selectedIndexIn = newValue;
    });
  }

  void UpdateCategoryOut(String newValue) {
    setState(() {
      selectedCategoryOut = newValue;
    });
  }

  final List incategory = [
    'All',
    'Gaji',
    'Uang Saku',
    'Warisan',
    'Profit',
    'Bonus'
  ];

  final List Outcategory = [
    'All',
    'Kebutuhan pokok',
    'Makanan',
    'Alat tulis',
    'Kebutuhan kuliah',
    'Uang kas',
    'Barang'
  ];
  @override
  Widget build(BuildContext context) {
    final value = context.watch<UserDatabase>();
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 240, 129, 65),
        title: const Text(
          "Laporan Keuangan",
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
                  MaterialPageRoute(builder: (context) => const SettingPage()));
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            iconSize: 40,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.all(10)),
            Row(
              children: [
                const Padding(padding: EdgeInsets.only(left: 10)),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: const Text(
                      "Summary",
                      style: TextStyle(fontSize: 25),
                    )),
                Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(10)),
                    child: FutureBuilder<List<String>>(
                      future: value.getTime(), // Memanggil metode getTime()
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.connectionState ==
                            ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            List<String> items = snapshot.data!;

                            return StatefulBuilder(
                              builder:
                                  (BuildContext context, StateSetter setState) {
                                return DropdownButton<String>(
                                  value: selectedItem, // Nilai saat ini
                                  hint: Text(selectedItem ??
                                      'Pilih waktu'), // Teks placeholder
                                  items: items.map((String item) {
                                    return DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(item),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    UpdateDropdown(newValue!);
                                  },
                                );
                              },
                            );
                          } else {
                            // Tampilkan pesan jika data kosong
                            return const Center(child: Text('Tidak ada data.'));
                          }
                        } else {
                          // Tampilkan widget default jika kondisi lain
                          return const Center(child: Text('Loading...'));
                        }
                      },
                    )),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            validateSummary(),
            const Padding(padding: EdgeInsets.only(top: 20)),
            const Row(
              children: [
                Padding(padding: EdgeInsets.only(right: 10)),
                Text(
                  "Pemasukan",
                  style: TextStyle(fontSize: 25),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            filterIncome(incategory),
            const Padding(padding: EdgeInsets.only(bottom: 10)),
            Row(
              children: [
                Container(
                  width: size * 0.23,
                  margin: const EdgeInsets.only(left: 20),
                  child: const Text(
                    "Bulan/\nKategori",
                    style: TextStyle(fontSize: 10),
                  ),
                ),
                SizedBox(
                  width: size * 0.43,
                  child: const Text("Title", style: TextStyle(fontSize: 10)),
                ),
                const Text("Pemasukan", style: TextStyle(fontSize: 10))
              ],
            ),
            incomeTable(size),
            const Padding(padding: EdgeInsets.all(20)),
            const Row(children: [
              Padding(padding: EdgeInsets.only(left: 10)),
              Text(
                "Pengeluaran",
                style: TextStyle(fontSize: 25),
              ),
            ]),
            filterOutcome(Outcategory),
            const Padding(padding: EdgeInsets.only(bottom: 10)),
            Row(
              children: [
                Container(
                  width: size * 0.23,
                  margin: const EdgeInsets.only(left: 20),
                  child: const Text(
                    "Bulan/\nKategori",
                    style: TextStyle(fontSize: 10),
                  ),
                ),
                SizedBox(
                  width: size * 0.43,
                  child: const Text(
                    "Title",
                    style: TextStyle(fontSize: 10),
                    softWrap: true,
                  ),
                ),
                const Text("Pengeluaran", style: TextStyle(fontSize: 10))
              ],
            ),
            outcomeTable(size)
          ],
        ),
      ),
    );
  }

  Container filterOutcome(List<dynamic> category) {
    return Container(
      alignment: AlignmentDirectional.bottomStart,
      height: 30,
      padding: const EdgeInsets.only(left: 10),
      child: SizedBox(
        height: 25,
        child: ListView(
            scrollDirection: Axis.horizontal,
            children: category.asMap().entries.map((text) {
              return Padding(
                padding: const EdgeInsets.only(left: 5),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: selectedIndexout == text.key
                          ? const Color.fromARGB(169, 243, 163, 33)
                          : Colors.white),
                  onPressed: () {
                    UpdateIndexOut(text.key);
                    UpdateCategoryOut(category[text.key]);
                  },
                  child: Text("${text.value}"),
                ),
              );
            }).toList()),
      ),
    );
  }

  Container filterIncome(List<dynamic> category) {
    return Container(
      alignment: AlignmentDirectional.bottomStart,
      height: 30,
      padding: const EdgeInsets.only(left: 10),
      child: SizedBox(
        height: 25,
        child: ListView(
            scrollDirection: Axis.horizontal,
            children: category.asMap().entries.map((text) {
              return Padding(
                padding: const EdgeInsets.only(left: 5),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: selectedIndexIn == text.key
                          ? const Color.fromARGB(169, 243, 163, 33)
                          : Colors.white),
                  onPressed: () {
                    UpdateIndexIn(text.key);
                    UpdateCategoryIn(category[selectedIndexIn as int]);
                  },
                  child: Text("${text.value}"),
                ),
              );
            }).toList()),
      ),
    );
  }

  Container validateSummary() {
    if (selectedItem != null) {
      List? temp = selectedItem?.split(" ");
      return Container(
        child: SummaryReportDetail(
          context: context,
          month: int.tryParse(temp?[0]),
          year: int.tryParse(temp?[1]),
        ),
      );
    }

    return Container(
      child: SummaryReportDetail(
        context: context,
        month: 0,
        year: 0,
      ),
    );
  }

  Container validateExp(double size) {
    String? flag = "";
    if (selectedItem != null) {
      List? temp = selectedItem?.split(" ");
      if (selectedCategoryOut != null) {
        flag = selectedCategoryOut;
      }
      if (selectedCategoryOut == "All") {
        flag = "";
      }
      return Container(
        child: OutcomeTabelReport(
            size: size,
            month: int.tryParse(temp?[0]),
            year: int.tryParse(temp?[1]),
            forinput: flag!),
      );
    }
    return Container();
  }

  Container validateIn(double size) {
    String? flag = "";
    if (selectedItem != null) {
      List? temp = selectedItem?.split(" ");
      if (selectedCategoryIn != null) {
        flag = selectedCategoryIn;
      }
      if (selectedCategoryIn == "All") {
        flag = "";
      }
      return Container(
        child: IncomeTableReport(
            size: size,
            month: int.tryParse(temp?[0]),
            year: int.tryParse(temp?[1]),
            forinput: flag!),
      );
    }
    return Container();
  }

  Container outcomeTable(double size) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      padding: const EdgeInsets.only(top: 5),
      height: 400,
      decoration: BoxDecoration(
          color: Colors.black12, borderRadius: BorderRadius.circular(10)),
      child: ListView(children: [validateExp(size)]),
    );
  }

  Container incomeTable(double size) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      padding: const EdgeInsets.only(top: 5),
      height: 400,
      decoration: BoxDecoration(
          color: Colors.black12, borderRadius: BorderRadius.circular(10)),
      child: ListView(
        children: [validateIn(size)],
      ),
    );
  }
}

class SummaryReportDetail extends StatelessWidget {
  SummaryReportDetail(
      {super.key,
      required this.context,
      required this.month,
      required this.year});

  int? month;
  int? year;
  final BuildContext context;
  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp.');

  @override
  Widget build(BuildContext context) {
    final value = context.read<UserDatabase>();
    return Container(
      margin: const EdgeInsets.only(
        right: 10,
        left: 10,
      ),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const []),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  border: Border(
                      right: BorderSide(width: 2, color: Colors.black38))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.arrow_upward,
                    size: 60,
                    color: Colors.green,
                  ),
                  const Text(
                    "Pemasukan",
                    style: TextStyle(fontSize: 20),
                  ),
                  FutureBuilder<int>(
                      future: value.getSummaryReport(1, month!, year!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // Loading indicator
                        } else if (snapshot.hasError) {
                          return Text(
                              'Error: ${snapshot.error}'); // Tampilkan error
                        } else if (snapshot.hasData) {
                          return Text(
                            "${currencyFormatter.format(snapshot.data)}",
                            textAlign: TextAlign.center,
                          ); // Tampilkan data
                        } else {
                          return const Text(
                              'No data found'); // Jika data kosong
                        }
                      })
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_downward,
                  size: 60,
                  color: Colors.red,
                ),
                Text(
                  "Pengeluaran",
                  style: TextStyle(fontSize: 20),
                ),
                FutureBuilder<int>(
                    future: value.getSummaryReport(2, month!, year!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(); // Loading indicator
                      } else if (snapshot.hasError) {
                        return Text(
                            'Error: ${snapshot.error}'); // Tampilkan error
                      } else if (snapshot.hasData) {
                        return Text(
                          "${currencyFormatter.format(snapshot.data)}",
                          textAlign: TextAlign.center,
                        ); // Tampilkan data
                      } else {
                        return const Text('No data found'); // Jika data kosong
                      }
                    })
              ],
            ),
          )
        ],
      ),
    );
  }
}

class OutcomeTabelReport extends StatelessWidget {
  OutcomeTabelReport(
      {super.key,
      required this.size,
      required this.month,
      required this.year,
      required this.forinput});

  DateFormat formatter = DateFormat("dd-MM-yyyy");
  String forinput;
  String category = "";
  int? month;
  int? year;
  double size;

  @override
  Widget build(BuildContext context) {
    final database = context.read<UserDatabase>();
    return FutureBuilder(
      future: database.fetchTransactions(month!, year!, forinput),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return Column(
            children: snapshot.data!.map((txn) {
              if (txn.type == TransactionType.income) {
                return const SizedBox();
              }
              if (txn.category != null) {
                category = txn.category.toString();
              }
              return Card(
                margin: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
                color: const Color.fromRGBO(255, 248, 244, 1),
                child: Row(
                  children: [
                    const Padding(padding: EdgeInsets.only(left: 15, top: 60)),
                    SizedBox(
                        width: size * 0.2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              formatter.format(txn.date),
                              style: const TextStyle(fontSize: 10),
                            ),
                            Text(
                              category,
                              style: const TextStyle(fontSize: 13),
                            )
                          ],
                        )),
                    SizedBox(
                        width: size * 0.35,
                        child: Text(
                          txn.name,
                          softWrap: true,
                          style: const TextStyle(fontSize: 13),
                        )),
                    const Icon(
                      Icons.arrow_downward_rounded,
                      color: Colors.red,
                    ),
                    Text(
                      'Rp${txn.amount}',
                      style: const TextStyle(fontSize: 13),
                    )
                  ],
                ),
              );
            }).toList(),
          );
        } else {
          return Center(child: Text("Wishlist Kosong"));
        }
      },
    );
  }
}

class IncomeTableReport extends StatelessWidget {
  IncomeTableReport(
      {super.key,
      required this.size,
      required this.month,
      required this.year,
      required this.forinput});

  DateFormat formatter = DateFormat("dd-MM-yyyy");
  String forinput;
  String category = "";
  int? month;
  int? year;
  double size;
  @override
  Widget build(BuildContext context) {
    final database = context.read<UserDatabase>();
    return FutureBuilder(
      future: database.fetchTransactions(month!, year!, forinput),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return Column(
            children: snapshot.data!.map((txn) {
              if (txn.type == TransactionType.expense) {
                return const SizedBox();
              }
              if (txn.category != null) {
                category = txn.category.toString();
              }
              return Card(
                margin: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
                color: const Color.fromRGBO(255, 248, 244, 1),
                child: Row(
                  children: [
                    const Padding(padding: EdgeInsets.only(left: 15, top: 60)),
                    SizedBox(
                        width: size * 0.2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              formatter.format(txn.date),
                              style: const TextStyle(fontSize: 10),
                            ),
                            Text(
                              category,
                              style: const TextStyle(fontSize: 13),
                            )
                          ],
                        )),
                    SizedBox(
                        width: size * 0.35,
                        child: Text(
                          txn.name,
                          softWrap: true,
                          style: const TextStyle(fontSize: 13),
                        )),
                    const Icon(
                      Icons.arrow_upward_rounded,
                      color: Colors.green,
                    ),
                    Text(
                      'Rp${txn.amount}',
                      style: const TextStyle(fontSize: 13),
                    )
                  ],
                ),
              );
            }).toList(),
          );
        } else {
          return Center(child: Text("Wishlist Kosong"));
        }
      },
    );
  }
}
