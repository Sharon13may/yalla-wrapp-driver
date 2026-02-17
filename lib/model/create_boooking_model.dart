class BookingResponseModel {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  BookingResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory BookingResponseModel.fromJson(Map<String, dynamic> json) {
    return BookingResponseModel(
      success: json["success"],
      message: json["message"] ?? "",
      data: json["data"],
    );
  }
}
