import 'package:suarafe/core/api_client.dart';
import 'package:suarafe/core/constants.dart';
import 'package:suarafe/models/donation_model.dart';

class DonationService {
  final _api = ApiClient();

  Future<Map<String, dynamic>> createDonation({
    required int campaignId,
    required double amount,
    String? message,
    bool isAnonymous = false,
  }) async {
    try {
      final response = await _api.post(
        ApiConstants.donations,
        body: {
          'campaign_id': campaignId,
          'amount': amount,
          if (message != null) 'message': message,
          'is_anonymous': isAnonymous,
        },
        requireAuth: true,
      );

      final data = _api.parseResponse(response);
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'success': true,
          'message': data?['message'] ?? 'Donation created',
          'snap_token': data?['snap_token'] as String?,
          'donation': data != null
              ? DonationModel.fromJson(data)
              : null,
        };
      } else {
        return {
          'success': false,
          'message': data?['message'] ?? 'Failed to create donation',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }

  Future<List<DonationModel>> getMyDonations() async {
    try {
      final response = await _api.get(
        ApiConstants.myDonations,
        requireAuth: true,
      );

      if (response.statusCode == 200) {
        final data = _api.parseListResponse(response) ?? 
                     _api.parseResponse(response)?['data'] as List?;
        if (data != null) {
          return data
              .map((e) => DonationModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<DonationModel?> getDonationDetail(int id) async {
    try {
      final response = await _api.get(
        ApiConstants.donationDetail(id.toString()),
        requireAuth: true,
      );

      if (response.statusCode == 200) {
        final data = _api.parseResponse(response);
        if (data != null) {
          return DonationModel.fromJson(data);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<DonationModel>> getCampaignDonations(int campaignId) async {
    try {
      final response = await _api.get(
        ApiConstants.campaignDonations(campaignId.toString()),
      );

      if (response.statusCode == 200) {
        final data = _api.parseListResponse(response) ?? 
                     _api.parseResponse(response)?['data'] as List?;
        if (data != null) {
          return data
              .map((e) => DonationModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}

