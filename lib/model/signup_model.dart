class SignupResponse {
  bool success;
  String code;
  dynamic data;
  String message;

  SignupResponse({
    required this.success,
    required this.code,
    required this.data,
    required this.message,
  });

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      success: json["success"] ?? false,
      code: json["code"]?.toString() ?? '',
      data: json["data"],
      message: json["message"]?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "code": code,
      "data": data,
      "message": message,
    };
  }

  @override
  String toString() {
    return 'SignupResponse(success: $success, code: $code, message: $message, data: $data)';
  }
}
