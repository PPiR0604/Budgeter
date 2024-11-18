import 'package:budgeter/Report.dart';
import 'package:budgeter/Tabungan.dart';
import 'package:budgeter/Wishlist.dart';
import 'package:budgeter/settingPage.dart';
import 'package:budgeter/Expenses.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
        body: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Padding(padding: EdgeInsets.only(top: 30)),
            const Row(
              children: [
                Padding(padding: EdgeInsets.only(right: 15)),
                Text(
                  "Selamat datang, User!",
                  style: TextStyle(fontSize: 20),
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
              child: summary_(),
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
                  onTap: () {},
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
                    MaterialPageRoute(builder: (context) => ExpensesPage())
                  ),
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

  Column summary_() {
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
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Income"),
                  Text(
                    "Rp100.000",
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              child: Container(
            decoration: const BoxDecoration(
                border:
                    Border(right: BorderSide(color: Colors.black, width: 2))),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Outcome"),
                Text(
                  "Ro50.000",
                  style: TextStyle(fontSize: 17),
                ),
              ],
            ),
          )),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Balance"),
                Text(
                  "Rp50.000",
                  style: TextStyle(fontSize: 17),
                ),
              ],
            ),
          )
        ])
      ],
    );
  }
}
