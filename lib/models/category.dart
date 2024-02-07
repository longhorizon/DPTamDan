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
  final String name;
  final String link;
  final int type;
  final String iconUrl;
  final String imageUrl;
  final List<dynamic> sub;

  CategoryItem({
    required this.name,
    required this.link,
    required this.type,
    required this.iconUrl,
    required this.imageUrl,
    required this.sub,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      name: json['name'],
      link: json['link'],
      type: json['type'],
      iconUrl: json['icon_url'],
      imageUrl: json['image_url'],
      sub: json['sub'],
    );
  }
}