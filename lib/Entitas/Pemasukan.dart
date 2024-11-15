class PemasukanData {
  String nama;
  int amount;
  String tanggal;
  String category;
  PemasukanData(this.nama, this.amount, this.tanggal, this.category);

  List<PemasukanData> getData() {
    List<PemasukanData> data = [];
    data.add(PemasukanData("Gaji", 1200000, "Mei", "Gaji"));
    data.add(PemasukanData("Warisan", 412321, "Juni", "Warisan"));
    data.add(PemasukanData("Jualan", 12321341, "Agustus", "Jualan"));
    data.add(PemasukanData("Bonus", 120000, "Juni", "Bonus"));
    data.add(PemasukanData("Tunjangan", 1200000, "Mei", "Gaji"));
    data.add(PemasukanData("Gaji 13", 400000, "September", "Gaji"));

    return data;
  }

  double countPemasukan(List<PemasukanData> pemasukan) {
    double temp = 0;
    for (var element in pemasukan) {
      temp += element.amount.toDouble();
    }
    return temp;
  }
}
