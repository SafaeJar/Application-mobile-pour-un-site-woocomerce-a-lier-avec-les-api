import 'package:woocommerce/models/product.dart';
import 'package:woocommerce/models/variable_product.dart';

class Product {
  int id;
  String name;
  String desctiption;
  String shortDescription;
  String sku;
  String price;
  String regularPrice;
  String salePrice;
  String stockStatus;
  List<Images> images;
  List<Categories> categories;
  List<Attributes> attributes;
  List<int> relatedIds;
  String type;
  VariableProduct variableProduct;

  Product({
    this.id,
    this.name,
    this.desctiption,
    this.shortDescription,
    this.sku,
    this.price,
    this.regularPrice,
    this.salePrice,
    this.stockStatus,
    this.relatedIds,
    this.variableProduct,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    desctiption = json['description'];
    shortDescription = json['short_description'];
    sku = json['sku'];
    price = json['price'];
    regularPrice = json['regular_price'];
    salePrice =
        json['sale_price'] != "" ? json['sale_price'] : json['regular_price'];
    stockStatus = json['stock_status'];
    relatedIds = json['cross_sell_ids'].cast<int>();
    type = json["type"];
    if (json['categories'] != null) {
      categories = List<Categories>();
      json['categories'].forEach((v) {
        categories.add(Categories.fromJson(v));
      });
    }
    if (json['images'] != null) {
      images = List<Images>();
      json['images'].forEach((v) {
        images.add(Images.fromJson(v));
      });
    }
    if (json["attributes"] != null) {
      attributes = new List<Attributes>();
      json["attributes"].forEach((v) {
        attributes.add(new Attributes.fromJson(v));
      });
    }
  }

  calculateDiscount() {
    double disPercent = 0;
    if (this.regularPrice != "") {
      double regularPrice = double.parse(this.regularPrice);
      double salePrice =
          this.salePrice != "" ? double.parse(this.salePrice) : regularPrice;
      double discount = regularPrice - salePrice;
      disPercent = (discount / regularPrice) * 100;
    }
    return disPercent.round();
  }
}

class Attributes {
  int id;
  String name;
  List<String> options;

  Attributes({this.id, this.name, this.options});

  Attributes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
  Map<String, dynamic> ToJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Images {
  String src;

  Images({
    this.src,
  });

  Images.fromJson(Map<String, dynamic> json) {
    src = json['src'];
  }
}

class Categories {
  int id;
  String name;

  Categories({this.id, this.name});
  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
