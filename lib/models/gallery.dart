class Gallery {
  final String name;
  final String title;
  final List<GalleryItem> data;

  Gallery({required this.name, required this.title, required this.data});

  factory Gallery.fromJson(Map<String, dynamic> json) {
    return Gallery(
      name: json['name'],
      title: json['title'],
      data: (json['data'] as List)
          .map((itemJson) => GalleryItem.fromJson(itemJson))
          .toList(),
    );
  }
}

class GalleryItem {
  final String image;
  final String imageUrl;
  final List<dynamic> data;

  GalleryItem({required this.image, required this.imageUrl, required this.data});

  factory GalleryItem.fromJson(Map<String, dynamic> json) {
    return GalleryItem(
      image: json['image'],
      imageUrl: json['image_url'],
      data: json['data'],
    );
  }
}
