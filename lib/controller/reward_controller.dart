import 'package:opinion_easy/core/utils/app_constants.dart';

import 'package:opinion_easy/data/model/reward_model.dart';
import 'package:opinion_easy/data/service/reward_service.dart';
import 'package:get/get.dart';

class RewardController extends GetxController {
  var isLoading = false.obs;
  var isRedeeming = (-1).obs;
  var rewards = Rxn<RewardModel>();
  var remainingRedemption = 0.obs;

  final RewardService rewardService = RewardService();

  @override
  onInit() {
    super.onInit();
    fetchRewards();
  }

  Future<void> fetchRewards() async {
    try {
      isLoading.value = true;

      RewardModel result = await rewardService.fetchRewards();
      rewards.value = result;
      print("valur ${result.remainingRedemptions}");
      remainingRedemption.value = result.remainingRedemptions;
    } catch (e) {
      isLoading.value = false;
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> redeem(int rewardId) async {
    try {
      isRedeeming.value = rewardId;
      var result = await rewardService.redeem(rewardId);
      if (result['success'] == true) {
        Get.snackbar('Success', result['message']);
        return true;
      } else {
        Get.snackbar(
          'Oops',
          result['message'],
          backgroundColor: AppColor.red.withValues(alpha: 0.5),
          colorText: AppColor.white,
        );
        return false;
      }
    } catch (e) {
      isRedeeming.value = (-1);
      print(e);
      return false;
    } finally {
      isRedeeming.value = (-1);
    }
  }
}
