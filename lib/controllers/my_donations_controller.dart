import 'package:get/get.dart';
import 'package:suarafe/models/donation_model.dart';
import 'package:suarafe/models/campaign_model.dart';
import 'package:suarafe/services/donation_service.dart';
import 'package:suarafe/services/campaign_service.dart';

class MyDonationsController extends GetxController {
  final _donationService = DonationService();
  final _campaignService = CampaignService();

  final donations = <DonationModel>[].obs;
  final isLoading = false.obs;
  final error = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    fetchMyDonations();
  }

  Future<void> fetchMyDonations() async {
    try {
      isLoading.value = true;
      error.value = null;

      final fetchedDonations = await _donationService.getMyDonations();
      donations.value = fetchedDonations;
    } catch (e) {
      error.value = 'Gagal memuat donasi: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  // Group donations by campaign
  Map<int, List<DonationModel>> get donationsByCampaign {
    final grouped = <int, List<DonationModel>>{};
    for (final donation in donations) {
      if (!grouped.containsKey(donation.campaignId)) {
        grouped[donation.campaignId] = [];
      }
      grouped[donation.campaignId]!.add(donation);
    }
    return grouped;
  }

  // Get total donation amount for a campaign
  double getTotalDonationForCampaign(int campaignId) {
    final campaignDonations = donationsByCampaign[campaignId] ?? [];
    return campaignDonations.fold<double>(
      0.0,
      (sum, donation) => sum + donation.amount,
    );
  }

  // Get campaign details
  Future<CampaignModel?> getCampaignDetails(int campaignId) async {
    return await _campaignService.getCampaignDetail(campaignId);
  }

  // Get campaign updates
  Future<List<CampaignUpdate>> getCampaignUpdates(int campaignId) async {
    return await _campaignService.getCampaignUpdates(campaignId);
  }
}

