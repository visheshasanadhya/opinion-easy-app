// import 'dart:convert';
//
// import 'package:http/http.dart' as http;
//
// import '../../core/api_contstant/api_constant.dart';
//
// class NotificationService1 {
//   Future<Map<String, dynamic>> fetchNotifications(String token) async {
//     final url = Uri.parse(ApiEndpoints.notification);
//     final response = await http.get(
//       url,
//       headers: {
//         "Content-Type": "application/json",
//         "Accept": "application/json",
//         "Authorization": "Bearer $token",
//       },
//     );
//     return jsonDecode(response.body);
//   }
// }
