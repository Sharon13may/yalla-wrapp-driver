class RewardModel {
  final int totalRewards;

  RewardModel({required this.totalRewards});

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    return RewardModel(
      totalRewards: json['data']['totalRewards'] ?? 0,
    );
  }
}
