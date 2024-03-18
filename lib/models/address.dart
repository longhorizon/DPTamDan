class Address {
  final String id;
  final String address;
  final int isPrimary;

  Address({
    required this.id,
    required this.address,
    required this.isPrimary,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      address: json['address'],
      isPrimary: json['is_primary'],
    );
  }
}