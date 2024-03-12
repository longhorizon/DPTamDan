class Branch {
  final String name;
  final String description;
  final String address;
  final String link;
  final String businessHours;

  Branch({
    required this.name,
    required this.description,
    required this.address,
    required this.link,
    required this.businessHours,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      name: json['name'],
      description: json['description'],
      address: json['address'],
      link: json['link'],
      businessHours: json['business_hours'],
    );
  }
}