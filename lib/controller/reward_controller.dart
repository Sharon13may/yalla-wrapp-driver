import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:yalla_wrapp_supervisor/model/reward_history_model.dart';
import 'package:yalla_wrapp_supervisor/model/reward_model.dart';
import 'package:yalla_wrapp_supervisor/utils/app_constants.dart';
import 'package:yalla_wrapp_supervisor/utils/prefs.dart';

class RewardController extends GetxController {
  var isLoading = false.obs;
  var reward = Rxn<RewardModel>();
  var rewardHistory = <RewardHistoryModel>[].obs;
  static const int maxReward = 10;

 @override
  void onInit() {
    fetchTotalRewards();
    fetchRewardHistory();
    super.onInit();
  }

  Future<Map<String, String>> _headers() async {
    String userId = await Prefs.getUserId() ?? "";
    return {
      "Token": AppConstants.token,
      "UserId": userId,
      "Content-Type": "application/json",
    };
  }

  Future<void> fetchTotalRewards() async {
    try {
      isLoading.value = true;

      String userId = await Prefs.getUserId() ?? "";
      String token = AppConstants.token;

      final headers = {
        "Token": token,
        "UserId": userId,
        "Content-Type": "application/json",
      };

      final response = await http.get(
        Uri.parse(
          "${AppConstants.baseUrl}Yuser_api/fetchtotalRewards",
        ),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        reward.value = RewardModel.fromJson(data);
      }
    } catch (e) {
      print("TOTAL REWARD ERROR → $e");
    } finally {
      isLoading.value = false;
    }
  }


    Future<void> fetchRewardHistory() async {
    try {
      final response = await http.get(
        Uri.parse(
          "${AppConstants.baseUrl}Yuser_api/rewardHistory",
        ),
        headers: await _headers(),
      );
print("REWARD HISTORY STATUS → ${response.statusCode}");
print("REWARD HISTORY BODY → ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        rewardHistory.value = List.from(data['data'])
            .map((e) => RewardHistoryModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      
      print("REWARD HISTORY ERROR → $e");
    }
  }

  double get progressValue {
    int points = reward.value?.totalRewards ?? 0;
    if (points >= maxReward) return 1.0;
    return points / maxReward;
  }


}
