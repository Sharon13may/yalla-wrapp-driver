class OTPResponse {
  bool success;
  String code;
  dynamic data;
  String message;

  OTPResponse({
    required this.success,
    required this.code,
    required this.data,
    required this.message,
  });

  factory OTPResponse.fromJson(Map<String, dynamic> json) {
    return OTPResponse(
      success: json["success"],
      code: json["code"],
      data: json["data"],
      message: json["message"],
    );
  }
}
