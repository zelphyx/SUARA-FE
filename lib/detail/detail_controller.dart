import 'package:get/get.dart';
import 'detail_model.dart';
import '../services/campaign_service.dart';
import '../core/constants.dart';

class DetailController extends GetxController {
  final _campaignService = CampaignService();
  
  final detail = Rxn<DetailModel>();
  final isLoading = false.obs;
  final error = Rxn<String>();

  Future<void> fetchDetail(String id) async {
    try {
      isLoading.value = true;
      error.value = null;

      final campaign = await _campaignService.getCampaignDetail(int.tryParse(id) ?? 0);
      
      if (campaign == null) {
        error.value = 'Campaign tidak ditemukan';
        return;
      }

      final updates = await _campaignService.getCampaignUpdates(campaign.id);
      
      detail.value = DetailModel(
        id: id,
        title: campaign.title,
        description: campaign.description,
        image: campaign.imageUrl,
        currentAmount: campaign.currentAmount,
        targetAmount: campaign.targetAmount,
        progress: campaign.progressValue,
        progressPercentage: campaign.progressPercentage,
        deadline: campaign.deadline,
        userName: campaign.user?.name,
        categoryName: campaign.category?.name,
        updates: updates.map((update) => UpdateItem(
          id: update.id.toString(),
          title: update.title,
          description: update.description,
          isCompleted: update.isCompleted,
        )).toList(),
        extraImages: (campaign.extraImages ?? []).map((img) => ApiConstants.getImageUrl(img)).toList(),
      );
    } catch (e) {
      error.value = 'Gagal memuat detail: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }
}
