class ApiEndpoints {
  // static String baseUrl = "https://opinioneasy.com/api/customer";
  //static String baseUrl = "https://3.26.41.94/api/customer";
  static String baseUrl = "http://3.26.41.94/api/customer";
  static String signUp = "$baseUrl/signup";
  static String login = "$baseUrl/login";
  static String forgotMPIN = "$baseUrl/forgot-mpin";
  static String googleLogin = "$baseUrl/google-login";
  static String profile = "$baseUrl/profile";
  static String updateProfile = "$baseUrl/profile";
  static String categories = "$baseUrl/categories";
  static String banners = "$baseUrl/banners";
  static String faqs = "$baseUrl/faqs";
  static String subCategory = "$baseUrl/subcategories";
  static String questions = "$baseUrl/questions";
  static String answer = "$baseUrl/answers";
  static String rewards = "$baseUrl/rewards";
  static String history = "$baseUrl/customer-answers";
  static String topper = "$baseUrl/top-customers";
  static String todayLeader = "$baseUrl/today-leaders";
  static String redeem = "$baseUrl/redeem-request";
  static String fcm = "$baseUrl/fcm-token";
  static String notification = "$baseUrl/notifications";
  static String markReadNotification = "$baseUrl/notifications/mark-read";
  static String unreadNotification = "$baseUrl/notifications/unread-count";
  static String bankDetails = "$baseUrl/customer-bank-details";
  static String terms = "$baseUrl/terms";
  static String privacy = "$baseUrl/privacy";

  // ==================== PAGINATION CONSTANTS ==================== //
  static const int startPagination = 1;
  static const int limitPagination = 20;

  // ==================== POSTAL PINCODE ==================== //
  static const postalPincode = "https://api.postalpincode.in/pincode/";

  // ==================== RAZORPAY IFSC ==================== //
  static const razorpayIfsc = "https://ifsc.razorpay.com/";
}
