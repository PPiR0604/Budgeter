import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  // TODO: implement key
  Key? get key => super.key;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 240, 129, 65),
          title: Text(
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
              onPressed: () {},
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              iconSize: 40,
            )
          ],
        ),
        body: Column(mainAxisSize: MainAxisSize.min, children: [
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
            margin: EdgeInsets.only(left: 10, right: 10),
            height: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
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
          menuBar()
        ]));
  }

  Container menuBar() {
    return Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        height: 200,
        decoration: BoxDecoration(
            color: Colors.black12, borderRadius: BorderRadius.circular(25)),
        child: const Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Icon(
                        Icons.add,
                        size: 40,
                      ),
                      Text("Pemasukan")
                    ],
                  ),
                  Column(
                    children: [
                      Icon(
                        Icons.input,
                        size: 40,
                      ),
                      Text("Pengeluaran")
                    ],
                  ),
                  Column(
                    children: [
                      Icon(
                        Icons.book,
                        size: 40,
                      ),
                      Text("Laporan")
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Icon(
                        Icons.savings,
                        size: 40,
                      ),
                      Text("Tabungan")
                    ],
                  ),
                  Column(
                    children: [
                      Icon(
                        Icons.shopping_basket,
                        size: 40,
                      ),
                      Text("Wishlist")
                    ],
                  ),
                  Column(
                    children: [
                      Icon(
                        Icons.currency_exchange,
                        size: 40,
                      ),
                      Text("Edukasi")
                    ],
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
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            decoration: BoxDecoration(
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
          Container(
            decoration: BoxDecoration(
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
          ),
          Container(
            child: const Column(
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
