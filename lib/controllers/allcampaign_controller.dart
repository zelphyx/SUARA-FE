import 'package:get/get.dart';
import 'package:suarafe/models/campaign_model.dart';
import 'package:suarafe/services/campaign_service.dart';
import 'package:suarafe/services/category_service.dart';

class AllCampaignController extends GetxController {
  final _campaignService = CampaignService();
  final _categoryService = CategoryService();

  final allCampaigns = <CampaignModel>[].obs; // Store all campaigns
  final campaigns = <CampaignModel>[].obs; // Displayed campaigns (filtered)
  final urgentCampaigns = <CampaignModel>[].obs;
  final categories = <CategoryModel>[].obs;
  final selectedCategoryId = Rxn<int>();
  final searchQuery = ''.obs;
  final isLoading = false.obs;
  final isLoadingUrgent = false.obs;
  final isLoadingCategories = false.obs;
  final error = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchUrgentCampaigns();
    fetchCampaigns();
  }

  Future<void> fetchCategories() async {
    try {
      isLoadingCategories.value = true;
      final fetchedCategories = await _categoryService.getCategories();
      categories.value = fetchedCategories;
    } catch (e) {
      error.value = 'Gagal memuat kategori: ${e.toString()}';
    } finally {
      isLoadingCategories.value = false;
    }
  }

  Future<void> fetchCampaigns({int? categoryId}) async {
    try {
      isLoading.value = true;
      error.value = null;
      selectedCategoryId.value = categoryId;

      print('Fetching campaigns from API...');
      final fetchedCampaigns = await _campaignService.getCampaigns();
      print('Fetched ${fetchedCampaigns.length} campaigns from service');

      if (fetchedCampaigns.isNotEmpty) {
        print('First campaign: ${fetchedCampaigns[0].title}');
        print('Image URL: ${fetchedCampaigns[0].imageUrl}');
      }

      allCampaigns.value = fetchedCampaigns;
      print('allCampaigns.value set to ${allCampaigns.length} items');

      // Apply filters
      _applyFilters();
      print('After filter: campaigns.value has ${campaigns.length} items');
    } catch (e) {
      print('Error fetching campaigns: ${e.toString()}');
      error.value = 'Gagal memuat campaigns: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUrgentCampaigns() async {
    try {
      isLoadingUrgent.value = true;
      final fetched = await _campaignService.getUrgentCampaigns();
      urgentCampaigns.value = fetched;
    } catch (e) {
      // Silent error for urgent campaigns
    } finally {
      isLoadingUrgent.value = false;
    }
  }

  void _applyFilters() {
    var filtered = allCampaigns.toList();
    
    // Filter by category
    if (selectedCategoryId.value != null) {
      filtered = filtered
          .where((c) => c.categoryId == selectedCategoryId.value)
          .toList();
    }
    
    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered.where((campaign) {
        return campaign.title.toLowerCase().contains(query) ||
            campaign.description.toLowerCase().contains(query);
      }).toList();
    }
    
    campaigns.value = filtered;
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void selectCategory(int? categoryId) {
    selectedCategoryId.value = categoryId;
    _applyFilters();
  }
}

