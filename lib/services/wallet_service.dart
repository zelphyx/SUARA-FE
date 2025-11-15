import 'package:suarafe/core/api_client.dart';
import 'package:suarafe/core/constants.dart';
import 'package:suarafe/models/user_model.dart';

class WalletService {
  final _api = ApiClient();

  Future<WalletInfo?> getWallet() async {
    try {
      final response = await _api.get(
        ApiConstants.wallet,
        requireAuth: true,
      );

      if (response.statusCode == 200) {
        final data = _api.parseResponse(response);
        if (data != null) {
          return WalletInfo.fromJson(data);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

