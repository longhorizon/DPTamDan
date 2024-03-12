import 'dart:convert';

class UserProfile {
  final String id;
  final String username;
  final String phone;
  final String email;
  final String name;
  final String avatar;
  final String cover;
  final String avatarUrl;
  final String coverUrl;
  final String role;
  final String status;
  final String infoEmail;
  final String infoName;
  final String infoPhone;
  final String gpdkkd;
  final String gpdkkdUrl;
  final String mst;
  final String mstImage;
  final String mstImageUrl;
  final String gdpGpp;
  final String gdpGppDurationUrl;
  final String gdpGppDuration;
  final String contractDuration;
  final String diploma;
  final String diplomaUrl;
  final String onlineDelivery;
  final String address;

  UserProfile({
    required this.id,
    required this.username,
    required this.phone,
    required this.email,
    required this.name,
    required this.avatar,
    required this.cover,
    required this.avatarUrl,
    required this.coverUrl,
    required this.role,
    required this.status,
    required this.infoEmail,
    required this.infoName,
    required this.infoPhone,
    required this.gpdkkd,
    required this.gpdkkdUrl,
    required this.mst,
    required this.mstImage,
    required this.mstImageUrl,
    required this.gdpGpp,
    required this.gdpGppDurationUrl,
    required this.gdpGppDuration,
    required this.contractDuration,
    required this.diploma,
    required this.diplomaUrl,
    required this.onlineDelivery,
    required this.address,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? "",
      username: json['username'] ?? "",
      phone: json['phone'] ?? "",
      email: json['email'] ?? "",
      name: json['name'] ?? "",
      avatar: json['avatar'] ?? "",
      cover: json['cover'] ?? "",
      avatarUrl: json['avatar_url'] ?? "",
      coverUrl: json['cover_url'] ?? "",
      role: json['role'] ?? "",
      status: json['status'] ?? "",
      infoEmail: json['info_email'] ?? "",
      infoName: json['info_name'] ?? "",
      infoPhone: json['info_phone'] ?? "",
      gpdkkd: json['gpdkkd'] ?? "",
      gpdkkdUrl: json['gpdkkd_url'] ?? "",
      mst: json['mst'] ?? "",
      mstImage: json['mst_image'] ?? "",
      mstImageUrl: json['mst_image_url'] ?? "",
      gdpGpp: json['gdp_gpp'] ?? "",
      gdpGppDurationUrl: json['gdp_gpp_duration_url'] ?? "",
      gdpGppDuration: json['gdp_gpp_duration'] ?? "",
      contractDuration: json['contract_duration'] ?? "",
      diploma: json['diploma'] ?? "",
      diplomaUrl: json['diploma_url'] ?? "",
      onlineDelivery: json['online_delivery'] ?? "",
      address: json['address'] ?? "",
    );
  }

  UserProfile parseUserProfile(String responseBody) {
    final parsed = jsonDecode(responseBody);
    final user = parsed['result'];
    return UserProfile.fromJson(user);
  }
}
