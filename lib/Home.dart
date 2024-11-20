import 'package:budgeter/Income.dart';
import 'package:budgeter/Report.dart';
import 'package:budgeter/Tabungan.dart';
import 'package:budgeter/WishlistPage.dart';
import 'package:budgeter/entities.dart';
import 'package:budgeter/logic.dart';
import 'package:budgeter/settingPage.dart';
import 'package:budgeter/Expenses.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  HomePage({required this.user, Key? key}) : super(key: key);
  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp.');
  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 240, 129, 65),
          title: const Text(
            "Home",
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingPage()));
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
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Padding(padding: EdgeInsets.only(top: 30)),
            Row(
              children: [
                const Padding(padding: EdgeInsets.only(right: 15)),
                Text(
                  "Selamat datang, ${user.username}!",
                  style: const TextStyle(fontSize: 20),
                )
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              height: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black12,
              ),
              child: summary_(context),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            const Row(
              children: [
                Padding(padding: EdgeInsets.only(right: 15)),
                Text(
                  "Fitur-Fitur",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            menuSection(context),
          ]),
        ));
  }

  Container menuSection(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        height: 200,
        decoration: BoxDecoration(
            color: Colors.black12, borderRadius: BorderRadius.circular(10)),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => IncomePage()));
                  },
                  child: const Column(
                    children: [
                      Icon(
                        Icons.add,
                        size: 40,
                        color: Color.fromRGBO(63, 63, 63, 1),
                      ),
                      Text("Pemasukan")
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  child: const Column(
                    children: [
                      Icon(
                        Icons.input,
                        size: 40,
                      ),
                      Text("Pengeluaran")
                    ],
                  ),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ExpensesPage())),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ReportPage()));
                  },
                  child: const Column(
                    children: [
                      Icon(
                        Icons.book,
                        size: 40,
                        color: Color.fromRGBO(63, 63, 63, 1),
                      ),
                      Text("Laporan")
                    ],
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TabunganPage()));
                  },
                  child: const Column(
                    children: [
                      Icon(
                        Icons.savings,
                        size: 40,
                        color: Color.fromRGBO(63, 63, 63, 1),
                      ),
                      Text("Tabungan")
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WishlistPage()));
                  },
                  child: const Column(
                    children: [
                      Icon(
                        Icons.shopping_basket,
                        size: 40,
                        color: Color.fromRGBO(63, 63, 63, 1),
                      ),
                      Text("Wishlist")
                    ],
                  ),
                ),
              ),
              const Expanded(
                child: Column(
                  children: [
                    Icon(
                      Icons.currency_exchange,
                      size: 40,
                      color: Color.fromRGBO(63, 63, 63, 1),
                    ),
                    Text("Edukasi")
                  ],
                ),
              )
            ],
          ),
        ]));
  }

  Column summary_(BuildContext context) {
    final value = context.watch<UserDatabase>();

    return Column(
      children: [
        const Padding(padding: EdgeInsets.only(bottom: 10)),
        const Row(
          children: [
            Padding(padding: EdgeInsets.only(left: 15)),
            Text(
              "Summary",
              style: TextStyle(fontSize: 20),
            )
          ],
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        Row(mainAxisSize: MainAxisSize.min, children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  border:
                      Border(right: BorderSide(color: Colors.black, width: 2))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Income"),
                  FutureBuilder<int>(
                      future: value.getsummary(1),
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
              child: Container(
            decoration: const BoxDecoration(
                border:
                    Border(right: BorderSide(color: Colors.black, width: 2))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Outcome"),
                FutureBuilder<int>(
                    future: value.getsummary(2),
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
          )),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Balance"),
                FutureBuilder<int>(
                    future: value.getsummary(0),
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
        ])
      ],
    );
  }
}
