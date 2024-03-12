import 'category.dart';

class Product {
  final String id;
  final String name;
  final String slug;
  final String link;
  final String intro;
  final String unit;
  final String des;
  final int price;
  final int priceSaleOff;
  final String image;
  final String updatedAt;
  List<String> gallery;
  List<Attribute> attributes;

  Product({
    required this.id,
    required this.name,
    required this.slug,
    required this.link,
    required this.intro,
    required this.unit,
    required this.des,
    required this.price,
    required this.priceSaleOff,
    required this.image,
    required this.updatedAt,
    required this.gallery,
    required this.attributes,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    List<String> galleryList = [];
    // if (json['gallery'] != null && json['gallery'] is List<String>) {
    if (json['gallery'] != null) {
      galleryList = List<String>.from(json['gallery']);
    }

    List<Attribute> attributesList = [];
    if (json['attributes'] != null) {
      attributesList = List<Attribute>.from(
        json['attributes'].map((attribute) => Attribute.fromJson(attribute)),
      );
    }

    return Product(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      slug: json['slug'] ?? "",
      link: json['link'] ?? "",
      intro: json['intro'] ?? "",
      unit: json['unit'] ?? "",
      des: json['description'] ?? "",
      price: json['price'] ?? 0,
      priceSaleOff: json['price_sale_off'] ?? 0,
      image: json['image'] ?? json['image_url'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      gallery: galleryList,
      attributes: attributesList,
    );
  }
}

class Attribute {
  String name;
  String value;

  Attribute({
    required this.name,
    required this.value,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) {
    return Attribute(
      name: json['name'],
      value: json['value'],
    );
  }
}
