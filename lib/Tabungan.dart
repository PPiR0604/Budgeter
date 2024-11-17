import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'settingPage.dart';

class TabunganPage extends StatelessWidget {
  TabunganPage({super.key});
  int _TotalPemasukan = 800000;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 240, 129, 65),
        title: const Text(
          "Wishlist",
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
                          Icon(
                            Icons.arrow_downward,
                            color: Colors.green,
                          ),
                          const Icon(
                            Icons.savings,
                            size: 40,
                            color: Colors.green,
                          ),
                          Text(
                            "Rp$_TotalPemasukan",
                            style: TextStyle(fontSize: 18),
                          ),
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
                  const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_upward,
                          color: Colors.red,
                        ),
                        Icon(
                          Icons.savings,
                          size: 40,
                          color: Colors.red,
                        ),
                        Text(
                          "Rp 1000000",
                          style: TextStyle(fontSize: 18),
                        ),
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
            Padding(padding: EdgeInsets.only(top: 20)),
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
            SfCartesianChart(
              primaryXAxis: const CategoryAxis(),
              series: [
                LineSeries<dummy, String>(
                  dataSource: data,
                  color: Colors.green,
                  xValueMapper: (dummy Tesdata, _) => Tesdata.x,
                  yValueMapper: (dummy Tesdata, _) => Tesdata.y,
                ),
                LineSeries<dummy, String>(
                  dataSource: data,
                  color: Colors.red,
                  xValueMapper: (dummy Tesdata, _) => Tesdata.x,
                  yValueMapper: (dummy Tesdata, _) => Tesdata.y1,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  final List<dummy> data = <dummy>[
    dummy("April", 301000, 199239),
    dummy("Mei", 36000, 124334),
    dummy("Juni", 123312, 112234)
  ];
}

class dummy {
  dummy(this.x, this.y, this.y1);
  final String x;
  final double y;
  final double y1;
}
