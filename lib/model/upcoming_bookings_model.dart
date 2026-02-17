class UpcomingBookingModel {
  final String bookingId;
  final String referenceId;
  final String bookDate;
  final String slotTime;
  final String totalPrice;
  final String status;

  UpcomingBookingModel({
    required this.bookingId,
    required this.referenceId,
    required this.bookDate,
    required this.slotTime,
    required this.totalPrice,
    required this.status,
  });

  factory UpcomingBookingModel.fromJson(Map<String, dynamic> json) {
    return UpcomingBookingModel(
      bookingId: json["bookingId"],
      referenceId: json["referenceId"],
      bookDate: json["bookDate"],
      slotTime: json["slotTime"],
      totalPrice: json["totalPrice"],
      status: json["status"],
    );
  }
}
