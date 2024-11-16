class WishlistEntity {
  String name;
  int amount;

  WishlistEntity(this.name, this.amount);

  List<WishlistEntity> getList() {
    List<WishlistEntity> data = [];
    data.add(WishlistEntity("Sepeda", 800000));
    data.add(WishlistEntity("Motor", 20000000));
    data.add(WishlistEntity("Handphone", 3000000));
    return data;
  }
}
