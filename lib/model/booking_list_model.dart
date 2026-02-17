class BookingModel {
  final String bookingid;
  final String referenceId;
  final String bookDate;
  final String slotTime;
  final String status;
  final String totalPrice;

  BookingModel({
    required this.bookingid,
    required this.referenceId,
    required this.bookDate,
    required this.slotTime,
    required this.status,
    required this.totalPrice,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      bookingid: json["bookingId"]?.toString() ?? "",
      referenceId: json["referenceId"] ?? "",
      bookDate: json["bookDate"] ?? "",
      slotTime: json["slotTime"] ?? "",
      status: json["status"] ?? "",
      totalPrice: json["totalPrice"] ?? "0",
    );
  }
}
