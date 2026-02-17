class RewardHistoryModel {
  final String bookingId;
  final int rewardPoints;
  final String createdTime;

  RewardHistoryModel({
    required this.bookingId,
    required this.rewardPoints,
    required this.createdTime,
  });

  factory RewardHistoryModel.fromJson(Map<String, dynamic> json) {
    return RewardHistoryModel(
      bookingId: json['bookingId'] ?? '',
      rewardPoints: json['rewardPoints'] ?? 0,
      createdTime: json['createdTime'] ?? '',
    );
  }
}
