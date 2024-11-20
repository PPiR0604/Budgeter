import 'package:budgeter/Entitas/WishlistData.dart';
import 'package:budgeter/components.dart';
import 'package:budgeter/entities.dart';
import 'package:budgeter/logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'settingPage.dart';

class WishlistPage extends StatefulWidget {
  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp.');
  WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  List<WishlistEntity> WishlistList = [];

  WishlistEntity catcher = WishlistEntity("", 0);

  TextEditingController nameInput = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  int? price;

  void clearInput() {
    nameInput.clear();
    price = null;
    _formKey.currentState!.reset();
  }

  void updatePrice(int price) {
    setState(() {
      this.price = price;
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    final database = context.read<UserDatabase>();

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
            Container(
                padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                height: 400,
                width: size * 0.95,
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10)),
                child: SizedBox(
                    height: 400,
                    child: ListView(children: [Wish_List(size: size)]))),
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
            Form(
              key: _formKey,
              child: Container(
                height: 300,
                width: 400,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10)),
                child: (Column(
                  children: [
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    SizedBox(
                      width: 330,
                      height: 92,
                      child: CustomTextFormField(
                        controller: nameInput,
                        labelText: "Nama Barang",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Input Some Value";
                          }
                          return null;
                        },
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 15)),
                    SizedBox(
                      width: 330,
                      height: 92,
                      child: CustomTextFormField(
                        onSaved: (newValue) =>
                            updatePrice(int.parse(newValue!)),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Input Some Value";
                          }
                          return null;
                        },
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
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) return;
                            _formKey.currentState!.save();
                            final wishlist = Wishlist(
                                name: nameInput.text,
                                price: price!,
                                estimatedDate: DateTime.now());

                            database.pushWishlist(wishlist);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Input Berhasil')),
                            );
                            clearInput();
                          },
                        ),
                      ],
                    )
                  ],
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Wish_List extends StatelessWidget {
  Wish_List({super.key, required this.size});

  double size;

  @override
  Widget build(BuildContext context) {
    final value = context.watch<UserDatabase>();

    return FutureBuilder(
      future: value.fetchWishlist(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return Column(
            children: snapshot.data!
                .map((txn) => WishlistTable(
                      wishlist: txn,
                      size: size,
                    ))
                .toList(),
          );
        } else {
          return Center(child: Text("Wishlist Kosong"));
        }
      },
    );
  }
}

class WishlistTable extends StatelessWidget {
  WishlistTable({super.key, required this.wishlist, required this.size});
  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp.');
  final Wishlist wishlist;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: const Color.fromRGBO(255, 248, 244, 1),
        child: Row(

            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Padding(padding: EdgeInsets.only(left: 10, top: 60)),
              SizedBox(
                width: size * 0.32,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(wishlist.name),
                    Text(currencyFormatter.format(wishlist.price)),
                  ],
                ),
              ),
              SizedBox(
                  width: size * 0.33,
                  child: const Text(
                    "Analysis",
                    softWrap: true,
                  )),
              ElevatedButton(
                  onPressed: () {
                    final database = context.read<UserDatabase>();
                    database.deleteWishlist(wishlist.id!);
                  },
                  child: Text(
                    "Selesai",
                    style: TextStyle(fontSize: 10),
                  ))
            ]));
  }
}
