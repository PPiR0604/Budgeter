import 'package:budgeter/Entitas/WishlistData.dart';
import 'package:budgeter/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'settingPage.dart';

class WishlistPage extends StatelessWidget {
  WishlistPage({super.key});

  List<WishlistEntity> WishlistList = [];
  WishlistEntity catcher = WishlistEntity("", 0);
  void getWishlist() {
    WishlistList = catcher.getList();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    getWishlist();
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
                const Padding(padding: EdgeInsets.only(right: 10)),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    size: 35,
                  ),
                )
              ],
            ),
            const Padding(padding: EdgeInsets.all(10)),
            const Row(
              children: [
                Padding(padding: EdgeInsets.only(left: 10)),
                Text(
                  "Daftar Wishlist",
                  style: TextStyle(fontSize: 25),
                )
              ],
            ),
            wishlistTable(size),
            const Padding(padding: EdgeInsets.only(top: 20)),
            const Row(
              children: [
                Padding(padding: EdgeInsets.only(left: 10)),
                Text(
                  "Input Wishlist",
                  style: TextStyle(fontSize: 25),
                )
              ],
            ),
            Container(
              height: 260,
              width: 400,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10)),
              child: (Column(
                children: [
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  const SizedBox(
                    width: 330,
                    height: 75,
                    child: CustomTextFormField(
                      keyboardType: TextInputType.number,
                      labelText: "Harga Barang",
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 15)),
                  const SizedBox(
                    width: 330,
                    height: 75,
                    child: CustomTextFormField(
                      keyboardType: TextInputType.number,
                      labelText: "Harga Barang",
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 20)),
                      ElevatedButton(
                        child: const Text('Simpan'),
                        onPressed: () {},
                      ),
                    ],
                  )
                ],
              )),
            )
          ],
        ),
      ),
    );
  }

  Container wishlistTable(double size) {
    return Container(
      margin: const EdgeInsets.only(right: 10, left: 10),
      padding: const EdgeInsets.only(top: 5),
      height: 400,
      decoration: BoxDecoration(
          color: Colors.black12, borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        height: 400,
        child: ListView(
            children: WishlistList.map((data) {
          return Card(
            color: const Color.fromRGBO(255, 248, 244, 1),
            margin: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Padding(padding: EdgeInsets.only(left: 10, top: 60)),
                SizedBox(
                  width: size * 0.26,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.name),
                      Text('Rp${data.amount}'),
                    ],
                  ),
                ),
                SizedBox(
                    width: size * 0.38,
                    child: const Text(
                      "Analysis",
                      softWrap: true,
                    )),
                SizedBox(
                  height: 20,
                  width: 85,
                  child: ElevatedButton(
                    child: const Text(
                      'Selesai',
                      style: TextStyle(fontSize: 10),
                    ),
                    onPressed: () {},
                  ),
                )
              ],
            ),
          );
        }).toList()),
      ),
    );
  }
}
