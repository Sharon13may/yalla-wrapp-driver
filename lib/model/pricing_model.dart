class PricingModel {
  final String basePrice;
  final int serviceFee;
  final String otherCharges;
  final num totalPrice;

  PricingModel({
    required this.basePrice,
    required this.serviceFee,
    required this.otherCharges,
    required this.totalPrice,
  });

  factory PricingModel.fromJson(Map<String, dynamic> json) {
    return PricingModel(
      basePrice: json['basePrice'].toString(),
      serviceFee: json["addons"],
      otherCharges: json['otherCharges'].toString(),
      totalPrice: json['totalPrice'],
    );
  }
}
