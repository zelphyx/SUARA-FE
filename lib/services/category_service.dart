import 'package:suarafe/core/api_client.dart';
import 'package:suarafe/core/constants.dart';
import 'package:suarafe/models/campaign_model.dart';

class CategoryService {
  final _api = ApiClient();

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _api.get(ApiConstants.categories);

      if (response.statusCode == 200) {
        final data = _api.parseListResponse(response) ?? 
                     _api.parseResponse(response)?['data'] as List?;
        if (data != null) {
          return data
              .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}

