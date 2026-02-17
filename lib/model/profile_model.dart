class ProfileModel {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  ProfileModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}
