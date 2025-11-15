import 'package:suarafe/core/api_client.dart';
import 'package:suarafe/core/constants.dart';
import 'package:suarafe/models/withdrawal_model.dart';

class WithdrawalService {
  final _api = ApiClient();

  Future<Map<String, dynamic>> createWithdrawal({
    required int campaignId,
    required double amount,
    required String bankName,
    required String accountNumber,
    required String accountName,
  }) async {
    try {
      final response = await _api.post(
        ApiConstants.withdrawals,
        body: {
          'campaign_id': campaignId,
          'amount': amount,
          'bank_name': bankName,
          'account_number': accountNumber,
          'account_name': accountName,
        },
        requireAuth: true,
      );

      final data = _api.parseResponse(response);
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'success': true,
          'message': data?['message'] ?? 'Withdrawal request created',
          'withdrawal': data != null
              ? WithdrawalModel.fromJson(data)
              : null,
        };
      } else {
        return {
          'success': false,
          'message': data?['message'] ?? 'Failed to create withdrawal request',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }

  Future<List<WithdrawalModel>> getMyWithdrawals() async {
    try {
      final response = await _api.get(
        ApiConstants.myWithdrawals,
        requireAuth: true,
      );

      if (response.statusCode == 200) {
        final data = _api.parseListResponse(response) ?? 
                     _api.parseResponse(response)?['data'] as List?;
        if (data != null) {
          return data
              .map((e) => WithdrawalModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<WithdrawalModel?> getWithdrawalDetail(int id) async {
    try {
      final response = await _api.get(
        ApiConstants.withdrawalDetail(id.toString()),
        requireAuth: true,
      );

      if (response.statusCode == 200) {
        final data = _api.parseResponse(response);
        if (data != null) {
          return WithdrawalModel.fromJson(data);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

