import 'package:suarafe/core/api_client.dart';
import 'package:suarafe/core/constants.dart';
import 'package:suarafe/models/campaign_model.dart';

class CampaignService {
  final _api = ApiClient();

  Future<List<CampaignModel>> getCampaigns({
    int? page,
    int? limit,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (page != null) queryParams['page'] = page.toString();
      if (limit != null) queryParams['limit'] = limit.toString();

      print('Calling API: ${ApiConstants.campaigns}');
      final response = await _api.get(
        ApiConstants.campaigns,
        queryParams: queryParams,
      );

      print('Response status: ${response.statusCode}');
      print('Response body length: ${response.body.length}');

      if (response.statusCode == 200) {
        // Try different response formats
        final responseData = _api.parseResponse(response);
        print('Parsed response data type: ${responseData.runtimeType}');

        if (responseData != null) {
          // Check if data is directly a list
          if (responseData is List<dynamic>) {
            print('✓ Response is direct list with ${responseData.length} items');
            return (responseData as List<dynamic>)
                .map((e) => CampaignModel.fromJson(e as Map<String, dynamic>))
                .toList();
          }
          // Check if data is wrapped in 'data' key
          if (responseData is Map<String, dynamic>) {
            print('Response is Map. Keys: ${responseData.keys.join(", ")}');
            if (responseData['data'] != null) {
              final dataList = responseData['data'];
              print('Data field type: ${dataList.runtimeType}');
              if (dataList is List<dynamic>) {
                print('✓ Response has data key with ${dataList.length} items');
                if (dataList.isEmpty) {
                  print('⚠ Data array is empty - no campaigns in database');
                } else {
                  print('✓ Parsing ${dataList.length} campaigns...');
                  try {
                    final campaigns = (dataList as List<dynamic>)
                        .map((e) {
                          try {
                            return CampaignModel.fromJson(e as Map<String, dynamic>);
                          } catch (parseError) {
                            print('✗ Error parsing campaign: $parseError');
                            print('  Data: ${e.toString().substring(0, 100)}...');
                            return null;
                          }
                        })
                        .whereType<CampaignModel>()
                        .toList();
                    print('✓ Successfully parsed ${campaigns.length} campaigns');
                    return campaigns;
                  } catch (e) {
                    print('✗ Error during parsing: ${e.toString()}');
                  }
                }
                return [];
              }
            }
          }
        }
        
        // Try as list response
        final listData = _api.parseListResponse(response);
        if (listData != null) {
          print('✓ Parsed as list response with ${listData.length} items');
          return (listData as List<dynamic>)
              .map((e) => CampaignModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      } else {
        print('✗ API returned status code: ${response.statusCode}');
      }
      print('⚠ No data found in response');
      return [];
    } catch (e) {
      print('Error in getCampaigns: ${e.toString()}');
      return [];
    }
  }

  Future<CampaignModel?> getCampaignDetail(int id) async {
    try {
      print('Calling API detail for campaign id=$id');
      final response = await _api.get(ApiConstants.campaignDetail(id.toString()));
      print('Detail status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final raw = _api.parseResponse(response);
        if (raw == null) {
          print('Detail parse returned null');
          return null;
        }
        // If wrapped inside data
        final data = raw is Map<String, dynamic> && raw['data'] is Map<String, dynamic>
            ? raw['data'] as Map<String, dynamic>
            : (raw as Map<String, dynamic>);
        try {
          final campaign = CampaignModel.fromJson(data);
          print('Parsed detail campaign title: ${campaign.title}');
          return campaign;
        } catch (e) {
          print('Error parsing campaign detail: $e');
          return null;
        }
      }
      print('Failed to load detail status=${response.statusCode} bodyLen=${response.body.length}');
      return null;
    } catch (e) {
      print('Exception getCampaignDetail: $e');
      return null;
    }
  }

  Future<List<CampaignModel>> getMyCampaigns() async {
    try {
      final response = await _api.get(
        ApiConstants.myCampaigns,
        requireAuth: true,
      );

      if (response.statusCode == 200) {
        final listData = _api.parseListResponse(response);
        if (listData != null && listData is List<dynamic>) {
          return (listData as List<dynamic>)
              .map((e) => CampaignModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        
        final responseData = _api.parseResponse(response);
        if (responseData != null && responseData is Map<String, dynamic>) {
          final data = responseData['data'];
          if (data != null && data is List<dynamic>) {
            return (data as List<dynamic>)
                .map((e) => CampaignModel.fromJson(e as Map<String, dynamic>))
                .toList();
          }
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> createCampaign({
    required String title,
    required String description,
    required String coverImage,
    required double targetAmount,
    required int categoryId,
    required DateTime deadline,
    String? slug,
    List<String>? extraImages,
  }) async {
    try {
      final response = await _api.post(
        ApiConstants.campaigns,
        body: {
          'title': title,
          'description': description,
          'cover_image': coverImage,
          'target_amount': targetAmount,
          'category_id': categoryId,
          'deadline': deadline.toIso8601String(),
          if (slug != null) 'slug': slug,
          if (extraImages != null) 'extra_images': extraImages,
        },
        requireAuth: true,
      );

      final data = _api.parseResponse(response);
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'success': true,
          'message': data?['message'] ?? 'Campaign created',
          'campaign': data != null
              ? CampaignModel.fromJson(data)
              : null,
        };
      } else {
        return {
          'success': false,
          'message': data?['message'] ?? 'Failed to create campaign',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> updateCampaign({
    required int id,
    String? title,
    String? description,
    String? coverImage,
    double? targetAmount,
    int? categoryId,
    DateTime? deadline,
    String? slug,
    List<String>? extraImages,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (title != null) body['title'] = title;
      if (description != null) body['description'] = description;
      if (coverImage != null) body['cover_image'] = coverImage;
      if (targetAmount != null) body['target_amount'] = targetAmount;
      if (categoryId != null) body['category_id'] = categoryId;
      if (deadline != null) body['deadline'] = deadline.toIso8601String();
      if (slug != null) body['slug'] = slug;
      if (extraImages != null) body['extra_images'] = extraImages;

      final response = await _api.put(
        ApiConstants.campaignDetail(id.toString()),
        body: body,
        requireAuth: true,
      );

      final data = _api.parseResponse(response);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data?['message'] ?? 'Campaign updated',
          'campaign': data != null
              ? CampaignModel.fromJson(data)
              : null,
        };
      } else {
        return {
          'success': false,
          'message': data?['message'] ?? 'Failed to update campaign',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> deleteCampaign(int id) async {
    try {
      final response = await _api.delete(
        ApiConstants.campaignDetail(id.toString()),
        requireAuth: true,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return {
          'success': true,
          'message': 'Campaign deleted',
        };
      } else {
        final data = _api.parseResponse(response);
        return {
          'success': false,
          'message': data?['message'] ?? 'Failed to delete campaign',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }

  Future<List<CampaignUpdate>> getCampaignUpdates(int campaignId) async {
    try {
      final response = await _api.get(
        ApiConstants.campaignUpdates(campaignId.toString()),
      );

      if (response.statusCode == 200) {
        final listData = _api.parseListResponse(response);
        if (listData != null && listData is List<dynamic>) {
          return (listData as List<dynamic>)
              .map((e) => CampaignUpdate.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        
        final responseData = _api.parseResponse(response);
        if (responseData != null && responseData is Map<String, dynamic>) {
          final data = responseData['data'];
          if (data != null && data is List<dynamic>) {
            return (data as List<dynamic>)
                .map((e) => CampaignUpdate.fromJson(e as Map<String, dynamic>))
                .toList();
          }
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> createCampaignUpdate({
    required int campaignId,
    required String title,
    required String description,
    bool isCompleted = false,
  }) async {
    try {
      final response = await _api.post(
        ApiConstants.campaignUpdates(campaignId.toString()),
        body: {
          'title': title,
          'description': description,
          'is_completed': isCompleted,
        },
        requireAuth: true,
      );

      final data = _api.parseResponse(response);
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'success': true,
          'message': data?['message'] ?? 'Update created',
          'update': data != null
              ? CampaignUpdate.fromJson(data)
              : null,
        };
      } else {
        return {
          'success': false,
          'message': data?['message'] ?? 'Failed to create update',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }

  Future<List<CampaignModel>> getFeaturedCampaigns() async {
    try {
      final response = await _api.get(ApiConstants.featuredCampaigns);

      if (response.statusCode == 200) {
        final listData = _api.parseListResponse(response);
        if (listData != null && listData is List<dynamic>) {
          return (listData as List<dynamic>)
              .map((e) => CampaignModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        
        final responseData = _api.parseResponse(response);
        if (responseData != null && responseData is Map<String, dynamic>) {
          final data = responseData['data'];
          if (data != null && data is List<dynamic>) {
            return (data as List<dynamic>)
                .map((e) => CampaignModel.fromJson(e as Map<String, dynamic>))
                .toList();
          }
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<CampaignModel>> getUrgentCampaigns() async {
    try {
      final response = await _api.get(ApiConstants.urgentCampaigns);

      if (response.statusCode == 200) {
        final listData = _api.parseListResponse(response);
        if (listData != null && listData is List<dynamic>) {
          return (listData as List<dynamic>)
              .map((e) => CampaignModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        
        final responseData = _api.parseResponse(response);
        if (responseData != null && responseData is Map<String, dynamic>) {
          final data = responseData['data'];
          if (data != null && data is List<dynamic>) {
            return (data as List<dynamic>)
                .map((e) => CampaignModel.fromJson(e as Map<String, dynamic>))
                .toList();
          }
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
