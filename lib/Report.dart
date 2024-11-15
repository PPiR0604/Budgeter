import 'package:budgeter/Entitas/Pemasukan.dart';
import 'package:flutter/material.dart';

class ReportPage extends StatelessWidget {
  ReportPage({super.key});
  PemasukanData pemasukanEntity = PemasukanData("", 123, "", "");

  List<PemasukanData> pemasukan = [];

  double TotalPemasukan = 0;
  String _TotalPemasukan = "";

  void getPemasukan() {
    PemasukanData tes = PemasukanData("", 0, "", "");
    pemasukan = tes.getData();
  }

  void getTotalPemasukan() {
    PemasukanData tes = PemasukanData("", 0, "", "");
    TotalPemasukan = tes.countPemasukan(pemasukan);
    _TotalPemasukan = TotalPemasukan.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    getPemasukan();
    getTotalPemasukan();

    final List incategory = [
      "All",
      "Gaji",
      "Bonus",
      "Warisan",
      "Jualan",
      "Investasi"
    ];

    final List Outcategory = [
      "All",
      "Transportasi",
      "Kebutuhan",
      "Pendidikan",
      "Hiburan",
      "Makanan"
    ];

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
            onPressed: () {},
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
                  child: const Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: Colors.black45,
                      ),
                      Padding(padding: EdgeInsets.only(right: 5)),
                      Text("November 2024"),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            summaryReport(context),
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
                  width: 90,
                  margin: const EdgeInsets.only(left: 20),
                  child: const Text(
                    "Bulan/\nKategori",
                    style: TextStyle(fontSize: 10),
                  ),
                ),
                const SizedBox(
                  width: 150,
                  child: Text("Title", style: TextStyle(fontSize: 10)),
                ),
                const Text("pemasukan", style: TextStyle(fontSize: 10))
              ],
            ),
            incomeTable(),
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
                  width: 90,
                  margin: const EdgeInsets.only(left: 20),
                  child: const Text(
                    "Bulan/\nKategori",
                    style: TextStyle(fontSize: 10),
                  ),
                ),
                const SizedBox(
                  width: 150,
                  child: Text("Title", style: TextStyle(fontSize: 10)),
                ),
                const Text("Pengeluaran", style: TextStyle(fontSize: 10))
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            outcomeTable()
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
            children: category.map((text) {
              return Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.only(right: 10, left: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 1)),
                child: Text("$text"),
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
            children: category.map((text) {
              return Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.only(right: 10, left: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 1)),
                child: Text("$text"),
              );
            }).toList()),
      ),
    );
  }

  Container outcomeTable() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      height: 400,
      decoration: BoxDecoration(
          // color: Colors.black12,
          borderRadius: BorderRadius.circular(10)),
      child: ListView(
        children: pemasukan.map((data) {
          return Container(
            padding: const EdgeInsets.only(top: 15, bottom: 15),
            margin: const EdgeInsets.only(top: 2, left: 5, right: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.black12),
            child: Row(
              children: [
                const Padding(padding: EdgeInsets.only(left: 15)),
                SizedBox(
                    width: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.tanggal,
                          style: const TextStyle(fontSize: 10),
                        ),
                        Text(
                          data.category,
                          style: const TextStyle(fontSize: 13),
                        )
                      ],
                    )),
                SizedBox(
                    width: 120,
                    child: Text(
                      data.nama,
                      style: const TextStyle(fontSize: 13),
                    )),
                const Icon(
                  Icons.arrow_downward_rounded,
                  color: Colors.red,
                ),
                Text(
                  'Rp${data.amount}',
                  style: const TextStyle(fontSize: 13),
                )
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Container incomeTable() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      height: 400,
      decoration: BoxDecoration(
          // color: Colors.black12,
          borderRadius: BorderRadius.circular(10)),
      child: ListView(
        children: pemasukan.map((data) {
          return Container(
            padding: const EdgeInsets.only(top: 15, bottom: 15),
            margin: const EdgeInsets.only(top: 2, left: 5, right: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.black12),
            child: Row(
              children: [
                const Padding(padding: EdgeInsets.only(left: 15)),
                SizedBox(
                    width: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.tanggal,
                          style: const TextStyle(fontSize: 10),
                        ),
                        Text(
                          data.category,
                          style: const TextStyle(fontSize: 13),
                        )
                      ],
                    )),
                SizedBox(
                    width: 120,
                    child: Text(
                      data.nama,
                      style: const TextStyle(fontSize: 13),
                    )),
                const Icon(
                  Icons.arrow_upward_rounded,
                  color: Colors.green,
                ),
                Text(
                  'Rp${data.amount}',
                  style: const TextStyle(fontSize: 13),
                )
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Container summaryReport(BuildContext context) {
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
                    "pemasukan",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text("Rp$_TotalPemasukan")
                ],
              ),
            ),
          ),
          const Expanded(
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
                Text("Rp 1.000.000")
              ],
            ),
          )
        ],
      ),
    );
  }
}
