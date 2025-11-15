import 'dart:convert';
import 'package:http/http.dart' as http;
import 'lib/models/campaign_model.dart';
import 'lib/core/constants.dart';

void main() async {
  print('Testing API fetch...');

  try {
    final response = await http.get(
      Uri.parse('http://103.150.116.34:8000/api/campaigns'),
    );

    print('Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print('Response type: ${jsonData.runtimeType}');
      print('Keys: ${jsonData.keys.join(", ")}');

      if (jsonData['data'] != null) {
        final dataList = jsonData['data'] as List;
        print('Data count: ${dataList.length}');

        if (dataList.isNotEmpty) {
          print('\nParsing first campaign...');
          final firstItem = dataList[0];
          print('Raw data keys: ${firstItem.keys.join(", ")}');

          try {
            print('Creating CampaignModel from JSON...');
            final campaign = CampaignModel.fromJson(firstItem);
            print('✓ Campaign created!');

            print('\nTrying to access fields...');
            print('Title: ${campaign.title}');
            print('Target: ${campaign.targetAmount}');
            print('Collected: ${campaign.collectedAmount}');
            print('Progress: ${campaign.progress * 100}%');
            print('Cover Image: ${campaign.coverImage}');

            print('Getting imageUrl...');
            final imgUrl = campaign.imageUrl;
            print('Image URL: $imgUrl');

            print('Category: ${campaign.category?.name}');
            print('User: ${campaign.user?.name}');

            print('\n✓ ALL FIELDS ACCESSED SUCCESS!');
          } catch (e, stackTrace) {
            print('\n✗ PARSE ERROR: $e');
            print('Stack trace:\n$stackTrace');
          }
        }
      }
    }
  } catch (e) {
    print('✗ ERROR: $e');
  }
}

