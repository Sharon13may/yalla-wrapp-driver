class ResendOtpModel {
  bool success;
  String code;
  String message;

  ResendOtpModel({
    required this.success,
    required this.code,
    required this.message,
  });

  factory ResendOtpModel.fromJson(Map<String, dynamic> json) {
    return ResendOtpModel(
      success: json["success"],
      code: json["code"],
      message: json["message"],
    );
  }
}
