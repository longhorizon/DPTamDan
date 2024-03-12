class Category {
  final String name;
  final String title;
  final List<CategoryItem> data;

  Category({required this.name, required this.title, required this.data});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'],
      title: json['title'],
      data: (json['data'] as List)
          .map((itemJson) => CategoryItem.fromJson(itemJson))
          .toList(),
    );
  }
}

class CategoryItem {
  final String id;
  final String name;
  final String link;
  final String type;
  final String iconUrl;
  final String imageUrl;

  CategoryItem({
    required this.id,
    required this.name,
    required this.link,
    required this.type,
    required this.iconUrl,
    required this.imageUrl,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      link: json['link'] ?? "",
      type: json['type'] ?? "",
      iconUrl: json['icon_url'] ?? "",
      imageUrl: json['image_url'] ?? "",
    );
  }
}
