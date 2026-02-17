class BookingDetailsModel {
  String referenceId;
  String serviceId;
  String bookDate;
  String slotTime;
  String slotEndTime;
  String quantity;
  String airline;
  String notes;
  String addressId;
  String basePrice;
  String homeServiceFee;
  String otherCharges;
  String totalPrice;
  String serviceName;
  String status;
  List<AddonItem> addons;

  BookingDetailsModel({
    required this.referenceId,
    required this.serviceId,
    required this.bookDate,
    required this.slotTime,
    required this.quantity,
    required this.addressId,
    required this.airline,
    required this.notes,
    required this.basePrice,
    required this.slotEndTime,
    required this.homeServiceFee,
    required this.otherCharges,
    required this.totalPrice,
    required this.serviceName,
    required this.status,
    required this.addons,
  });

  factory BookingDetailsModel.fromJson(Map<String, dynamic> json) {
    return BookingDetailsModel(
      referenceId: json["referenceId"] ?? "",
      serviceId: json["serviceId"] ?? "",
      addressId: json["addressId"] ?? "",
      bookDate: json["bookDate"] ?? "",
      slotTime: json["slotTime"] ?? "",
         slotEndTime: json["slotEndTime"] ?? "",
      quantity: json["quantity"] ?? "0",
      airline: json["airline"] ?? "",
      notes: json["notes"] ?? "",
      basePrice: json["basePrice"] ?? "0",
      homeServiceFee: json["homeServiceFee"] ?? "0",
      otherCharges: json["otherCharges"] ?? "0",
      totalPrice: json["totalPrice"] ?? "0",
      serviceName: json["serviceName"] ?? "",
      status: json["status"] ?? "0",
      addons: (json["addons"] as List? ?? [])
          .map((e) => AddonItem.fromJson(e))
          .toList(),
    );
  }
}

class AddonItem {
  String name;

  AddonItem({required this.name});

  factory AddonItem.fromJson(Map<String, dynamic> json) {
    return AddonItem(name: json["name"] ?? "");
  }
}

// class BookingDetailsModel {
//   String referenceId;
//   String bookDate;
//   String slotTime;
//   String slotEndTime;
//   String quantity;
//   String airline;
//   String notes;

//   String basePrice;
//   String homeServiceFee;
//   String otherCharges;
//   String totalPrice;

//   List<AddonItem> addons;

//   BookingDetailsModel({
//     required this.referenceId,
//     required this.bookDate,
//     required this.slotTime,
//     required this.slotEndTime,
//     required this.quantity,
//     required this.airline,
//     required this.notes,
//     required this.basePrice,
//     required this.homeServiceFee,
//     required this.otherCharges,
//     required this.totalPrice,
//     required this.addons,
//   });

//   factory BookingDetailsModel.fromJson(Map<String, dynamic> json) {
//     return BookingDetailsModel(
//       referenceId: json["referenceId"] ?? "",
//       bookDate: json["bookDate"] ?? "",
//       slotTime: json["slotTime"] ?? "",
//       slotEndTime: json["slotEndTime"] ?? "",
//       quantity: json["quantity"] ?? "1",
//       airline: json["airline"] ?? "",
//       notes: json["notes"] ?? "",
//       basePrice: json["basePrice"] ?? "0",
//       homeServiceFee: json["homeServiceFee"] ?? "0",
//       otherCharges: json["otherCharges"] ?? "0",
//       totalPrice: json["totalPrice"] ?? "0",
//       addons: (json["addons"] as List)
//           .map((e) => AddonItem.fromJson(e))
//           .toList(),
//     );
//   }
// }

// class AddonItem {
//   String name;

//   AddonItem({required this.name});

//   factory AddonItem.fromJson(Map<String, dynamic> json) {
//     return AddonItem(
//       name: json["name"] ?? "",
//     );
//   }
// }
