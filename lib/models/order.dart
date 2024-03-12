class Order {
  String id;
  String uid;
  String code;
  int feeShipping;
  int totalPrice;
  int discountPrice;
  int total;
  int paymentPrice;
  String discountCode;
  String note;
  String createdAt;
  String confirmedAt;
  String warehouseAt;
  String deliveryAt;
  String refuseAt;
  String completeAt;
  String paymentStatusLabel;
  String statusLabel;
  String userName;
  int userType;
  int userRole;
  String userPhone;
  String userEmail;
  String infoName;
  String infoPhone;
  String infoEmail;
  String infoAddress;
  bool cancel;

  Order({
    required this.id,
    required this.uid,
    required this.code,
    required this.feeShipping,
    required this.totalPrice,
    required this.discountPrice,
    required this.total,
    required this.paymentPrice,
    required this.discountCode,
    required this.note,
    required this.createdAt,
    required this.confirmedAt,
    required this.warehouseAt,
    required this.deliveryAt,
    required this.refuseAt,
    required this.completeAt,
    required this.paymentStatusLabel,
    required this.statusLabel,
    required this.userName,
    required this.userType,
    required this.userRole,
    required this.userPhone,
    required this.userEmail,
    required this.infoName,
    required this.infoPhone,
    required this.infoEmail,
    required this.infoAddress,
    required this.cancel,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? "",
      uid: json['uid'] ?? "",
      code: json['code'] ?? "",
      feeShipping: json['fee_shipping'] ?? 0,
      totalPrice: json['total_price'] ?? 0,
      discountPrice: json['discount_price'] ?? 0,
      total: json['total'] ?? 0,
      paymentPrice: json['payment_price'] ?? 0,
      discountCode: json['discount_code'] ?? "",
      note: json['note'] ?? "",
      createdAt: json['created_at'] ?? "",
      confirmedAt: json['confirmed_at'] ?? "",
      warehouseAt: json['warehouse_at'] ?? "",
      deliveryAt: json['delivery_at'] ?? "",
      refuseAt: json['refuse_at'] ?? "",
      completeAt: json['complete_at'] ?? "",
      paymentStatusLabel: json['payment_status_label'] ?? "",
      statusLabel: json['status_label'] ?? "",
      userName: json['user_name'] ?? "",
      userType: json['user_type'] ?? 0,
      userRole: json['user_role'] ?? 0,
      userPhone: json['user_phone'] ?? "",
      userEmail: json['user_email'] ?? "",
      infoName: json['info_name'] ?? "",
      infoPhone: json['info_phone'] ?? "",
      infoEmail: json['info_email'] ?? "",
      infoAddress: json['info_address'] ?? "",
      cancel: json['cancel'] ?? false,
    );
  }
}
