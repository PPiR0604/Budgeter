import 'package:budgeter/entities.dart';
import 'package:budgeter/logic.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'settingPage.dart';

class TabunganPage extends StatefulWidget {
  TabunganPage({super.key});

  @override
  State<TabunganPage> createState() => _TabunganPageState();
}

class _TabunganPageState extends State<TabunganPage> {
  List<Chart> income = [];
  List<Chart> expense = [];

  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp.');

  @override
  Widget build(BuildContext context) {
    final value = context.watch<UserDatabase>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 240, 129, 65),
        title: const Text(
          "Tabungan",
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
            const Padding(padding: EdgeInsets.only(top: 20)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(padding: EdgeInsets.only(left: 20)),
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
            const Padding(padding: EdgeInsets.only(top: 20)),
            const Row(
              children: [
                Padding(padding: EdgeInsets.only(left: 20)),
                Text(
                  "Tabungan",
                  style: TextStyle(fontSize: 25),
                )
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Container(
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
                              right:
                                  BorderSide(width: 2, color: Colors.black38))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.arrow_downward,
                            color: Colors.green,
                          ),
                          const Icon(
                            Icons.savings,
                            size: 40,
                            color: Colors.green,
                          ),
                          FutureBuilder<int>(
                              future: value.getSavings(0),
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
                              }),
                          const Text(
                            "Tabungan selama ini",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.arrow_upward,
                          color: Colors.red,
                        ),
                        const Icon(
                          Icons.savings,
                          size: 40,
                          color: Colors.red,
                        ),
                        FutureBuilder<int>(
                            future: value.getSavings(2),
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
                            }),
                        const Text(
                          "Pengeluaran selama ini",
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            SizedBox(
              child: Row(
                children: [
                  const Padding(padding: EdgeInsets.only(left: 70)),
                  Container(
                    height: 10,
                    width: 18,
                    color: Colors.red,
                  ),
                  const Padding(padding: EdgeInsets.only(left: 5)),
                  const Text("Pengeluaran"),
                  const Padding(padding: EdgeInsets.only(left: 30)),
                  Container(
                    height: 10,
                    width: 18,
                    color: Colors.green,
                  ),
                  const Padding(padding: EdgeInsets.only(left: 5)),
                  const Text("Pengeluaran"),
                ],
              ),
            ),
            FutureBuilder(
                future: value.getCharts(1),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Loading indicator
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}'); // Tampilkan error
                  } else if (snapshot.hasData) {
                    income = snapshot.data as List<Chart>;
                    return Container();
                  } else {
                    return const Text('No data found'); // Jika data kosong
                  }
                }),
            FutureBuilder(
                future: value.getCharts(2),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Loading indicator
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}'); // Tampilkan error
                  } else if (snapshot.hasData) {
                    expense = snapshot.data as List<Chart>;
                    print(expense);
                    return SfCartesianChart(
                      primaryXAxis: const CategoryAxis(),
                      series: [
                        LineSeries<Chart, String>(
                          dataSource: income,
                          color: Colors.green,
                          xValueMapper: (Chart tes, _) => tes.time,
                          yValueMapper: (Chart tes, _) => tes.amount,
                        ),
                        LineSeries<Chart, String>(
                          dataSource: expense,
                          color: Colors.red,
                          xValueMapper: (Chart tes, _) => tes.time,
                          yValueMapper: (Chart tes, _) => tes.amount,
                        )
                      ],
                    );
                  } else {
                    return const Text('No data found'); // Jika data kosong
                  }
                }),
            SfCartesianChart(
              primaryXAxis: const CategoryAxis(),
              series: [
                LineSeries<Chart, String>(
                  dataSource: income,
                  color: Colors.green,
                  xValueMapper: (Chart tes, _) => tes.time,
                  yValueMapper: (Chart tes, _) => tes.amount,
                ),
                LineSeries<Chart, String>(
                  dataSource: expense,
                  color: Colors.red,
                  xValueMapper: (Chart tes, _) => tes.time,
                  yValueMapper: (Chart tes, _) => tes.amount,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
