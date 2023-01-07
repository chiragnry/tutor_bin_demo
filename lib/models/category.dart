class Category {
  String? name;
  int? price;
  bool? instock;

  Category({this.name, this.price, this.instock});

  Category.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    instock = json['instock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['price'] = this.price;
    data['instock'] = this.instock;
    return data;
  }

  @override
  String toString() {
    return 'Category{name: $name, price: $price, instock: $instock}';
  }
}
