class CouponModel {
  final String couponImage;

  CouponModel({required this.couponImage});

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      couponImage: json['couponImage'] ?? '',
    );
  }
}
