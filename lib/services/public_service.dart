import 'package:suarafe/core/api_client.dart';
import 'package:suarafe/core/constants.dart';
import 'package:suarafe/models/stats_model.dart';

class PublicService {
  final _api = ApiClient();

  Future<StatsModel?> getStats() async {
    try {
      final response = await _api.get(ApiConstants.stats);

      if (response.statusCode == 200) {
        final data = _api.parseResponse(response);
        if (data != null) {
          return StatsModel.fromJson(data);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<MasterAccountModel>> getMasterAccounts() async {
    try {
      final response = await _api.get(ApiConstants.masterAccounts);

      if (response.statusCode == 200) {
        final data = _api.parseListResponse(response) ?? 
                     _api.parseResponse(response)?['data'] as List?;
        if (data != null) {
          return data
              .map((e) => MasterAccountModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}

