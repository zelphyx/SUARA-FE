class ApiConstants {
  static const String baseUrl = 'http://103.150.116.34:8000';
  static const String apiBaseUrl = '$baseUrl/api';
  
  // Auth endpoints
  static const String register = '/api/auth/register';
  static const String login = '/api/auth/login';
  static const String logout = '/api/auth/logout';
  static const String profile = '/api/auth/profile';
  static const String profileWallet = '/api/auth/wallet';
  
  // Categories
  static const String categories = '/api/categories';
  
  // Campaigns
  static const String campaigns = '/api/campaigns';
  static String campaignDetail(String id) => '/api/campaigns/$id';
  static String campaignUpdates(String id) => '/api/campaigns/$id/updates';
  static String campaignDonations(String id) => '/api/campaigns/$id/donations';
  static const String myCampaigns = '/api/campaigns/mine';
  static const String featuredCampaigns = '/api/campaigns/featured';
  static const String urgentCampaigns = '/api/campaigns/urgent';
  
  // Donations
  static const String donations = '/api/donations';
  static String donationDetail(String id) => '/api/donations/$id';
  static const String myDonations = '/api/donations/mine';
  static const String midtransCallback = '/api/midtrans/callback';
  
  // Wallet
  static const String wallet = '/api/wallet';
  
  // Withdrawals
  static const String withdrawals = '/api/withdrawals';
  static String withdrawalDetail(String id) => '/api/withdrawals/$id';
  static const String myWithdrawals = '/api/withdrawals/mine';
  
  // Notifications
  static const String notifications = '/api/notifications';
  static String notificationRead(String id) => '/api/notifications/$id/read';
  static const String notificationsReadAll = '/api/notifications/read-all';
  static const String notificationsUnreadCount = '/api/notifications/unread-count';
  
  // Public
  static const String stats = '/api/stats';
  static const String masterAccounts = '/api/accounts/master';

  // Helper methods
  static String getImageUrl(String imagePath) {
    if (imagePath.isEmpty || imagePath == 'default.jpg') {
      return ''; // Return empty string for default images
    }
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    }
    return '$baseUrl/storage/$imagePath';
  }
}

class StorageKeys {
  static const String token = 'auth_token';
  static const String user = 'user_data';
}

