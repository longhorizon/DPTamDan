import 'category.dart';

class Product {
  final String id;
  final String name;
  final String slug;
  final String link;
  final String intro;
  final String des;
  final int price;
  final int priceSaleOff;
  final String image;
  final String updatedAt;
  // final Category category;

  Product({
    required this.id,
    required this.name,
    required this.slug,
    required this.link,
    required this.intro,
    required this.des,
    required this.price,
    required this.priceSaleOff,
    required this.image,
    required this.updatedAt,
    // required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      slug: json['slug'] ?? "",
      link: json['link'] ?? "",
      intro: json['intro'] ?? "",
      des: json['des'] ?? "",
      price: json['price'] ?? 0,
      priceSaleOff: json['price_sale_off'] ?? 0,
      image: json['image'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      // category: Category.fromJson(json['category']),
    );
  }
}
