import 'package:get/get.dart';
import 'package:suarafe/models/campaign_model.dart';
import 'package:suarafe/models/user_model.dart';
import 'package:suarafe/services/campaign_service.dart';
import 'package:suarafe/services/auth_service.dart';
import 'package:suarafe/services/category_service.dart';

class HomeController extends GetxController {
  final _campaignService = CampaignService();
  final _authService = AuthService();
  final _categoryService = CategoryService();

  final campaigns = <CampaignModel>[].obs;
  final categories = <CategoryModel>[].obs;
  final user = Rxn<UserModel>();
  final isLoading = false.obs;
  final isLoadingCategories = false.obs;
  final error = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    fetchCampaigns();
    fetchUserProfile();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoadingCategories.value = true;
      final fetchedCategories = await _categoryService.getCategories();
      categories.value = fetchedCategories;
    } catch (e) {
      // Silent error for categories
    } finally {
      isLoadingCategories.value = false;
    }
  }

  Future<void> fetchCampaigns() async {
    try {
      isLoading.value = true;
      error.value = null;

      final fetchedCampaigns = await _campaignService.getCampaigns(limit: 2);
      campaigns.value = fetchedCampaigns;
    } catch (e) {
      error.value = 'Gagal memuat campaigns: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> fetchUserProfile() async {
    try {
      final profile = await _authService.getProfile();
      if (profile != null) {
        user.value = profile;
      }
    } catch (e) {
      // Silent error for profile
    }
  }
}

