//import 'package:opinion_easy/controller/topper_controller.dart';
// import 'package:opinion_easy/core/utils/widgets/loader_widget/topper_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:opinion_easy/core/utils/colors.dart';
// import 'package:opinion_easy/core/utils/widgets/spacing_widget.dart';
// import 'package:get/get.dart';
//
// class YearlyTopPerformerView extends StatefulWidget {
//   const YearlyTopPerformerView({super.key});
//
//   @override
//   State<YearlyTopPerformerView> createState() => _YearlyTopPerformerViewState();
// }
//
// class _YearlyTopPerformerViewState extends State<YearlyTopPerformerView> {
//   final TopperController topperController = Get.put(TopperController());
//
//   @override
//   void initState() {
//     super.initState();
//     topperController.fetchTopperList("year");
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//
//     return Scaffold(
//       backgroundColor: AppColor.whileColor,
//       appBar: AppBar(
//         backgroundColor: AppColor.whileColor,
//         centerTitle: true,
//         title: const Text(
//           "Top Earners",
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//         ),
//       ),
//       body: Obx(() {
//         if (topperController.isLoading.value) {
//           return const ShimmerTopPerformerView();
//         }
//
//         final model = topperController.topperModel.value;
//
//         if (model.data == null || model.data!.isEmpty) {
//           return const Center(child: Text("Yearly topper list is empty"));
//         }
//
//         final topperList = model.data!;
//         final currentUser = model.currentUser;
//
//         return SingleChildScrollView(
//           child: Column(
//             children: [
//               // ------------------ TOP 3 USERS ------------------
//               SizedBox(
//                 height: size.height * 0.4,
//                 width: double.infinity,
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     Positioned(
//                       bottom: 0,
//                       child: Image.asset(
//                         "assets/images/rank.png",
//                         height: size.height * 0.24,
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//
//                     // Top 1
//                     Positioned(
//                       top: 0,
//                       child: TopPerformerWidget(
//                         imageUrl: topperList[0].profilePic ?? '',
//                         points: "${topperList[0].points ?? 0}",
//                         name: topperList[0].name ?? 'N/A',
//                       ),
//                     ),
//
//                     // Top 2
//                     if (topperList.length > 1)
//                       Positioned(
//                         left: size.width * 0.12,
//                         top: 80,
//                         child: TopPerformerWidget(
//                           imageUrl: topperList[1].profilePic ?? '',
//                           points: "${topperList[1].points ?? 0}",
//                           name: topperList[1].name ?? 'N/A',
//                           sizeFactor: 0.8,
//                         ),
//                       ),
//
//                     // Top 3
//                     if (topperList.length > 2)
//                       Positioned(
//                         right: size.width * 0.12,
//                         top: 80,
//                         child: TopPerformerWidget(
//                           imageUrl: topperList[2].profilePic ?? '',
//                           points: "${topperList[2].points ?? 0}",
//                           name: topperList[2].name ?? 'N/A',
//                           sizeFactor: 0.8,
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//
//               // ------------------ LIST BELOW ------------------
//               Container(
//                 width: double.infinity,
//                 decoration: const BoxDecoration(
//                   color: Color(0xffD9D9D9),
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(20),
//                     topRight: Radius.circular(20),
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     VS(height: 10),
//                     const Text(
//                       "This Year's Top Earners",
//                       style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black,
//                       ),
//                     ),
//                     VS(height: 10),
//
//                     Container(
//                       decoration: const BoxDecoration(
//                         color: Color(0xff6F63FF),
//                         borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(40),
//                           topRight: Radius.circular(40),
//                         ),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 20,
//                           horizontal: 16,
//                         ),
//                         child: Column(
//                           children: [
//                             // ------- TABLE HEADER -------
//                             Container(
//                               decoration: BoxDecoration(
//                                 color: AppColor.whileColor,
//                                 borderRadius: BorderRadius.circular(30),
//                               ),
//                               padding: const EdgeInsets.symmetric(
//                                 vertical: 8,
//                                 horizontal: 12,
//                               ),
//                               child: const Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     "Position",
//                                     style: TextStyle(
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.w500,
//                                       color: Color(0xff6F63FF),
//                                     ),
//                                   ),
//                                   Text(
//                                     "User",
//                                     style: TextStyle(
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.w500,
//                                       color: Color(0xff6F63FF),
//                                     ),
//                                   ),
//                                   Text(
//                                     "Points",
//                                     style: TextStyle(
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.w500,
//                                       color: Color(0xff6F63FF),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             VS(height: 20),
//
//                             // -------- LIST VIEW --------
//                             ListView.builder(
//                               itemCount: topperList.length,
//                               shrinkWrap: true,
//                               physics: const NeverScrollableScrollPhysics(),
//                               itemBuilder: (context, index) {
//                                 final topper = topperList[index];
//
//                                 return Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 20,
//                                     vertical: 10,
//                                   ),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       // POSITION
//                                       SizedBox(
//                                         width: 40,
//                                         child: Text(
//                                           "${index + 1}",
//                                           style: const TextStyle(
//                                             fontSize: 17,
//                                             fontWeight: FontWeight.w500,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       ),
//
//                                       // NAME
//                                       Expanded(
//                                         child: Text(
//                                           topper.name ?? "N/A",
//                                           textAlign: TextAlign.center,
//                                           overflow: TextOverflow.ellipsis,
//                                           style: const TextStyle(
//                                             fontSize: 17,
//                                             fontWeight: FontWeight.w500,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       ),
//
//                                       // POINTS
//                                       Container(
//                                         decoration: BoxDecoration(
//                                           color: const Color(0xffF2D8FF),
//                                           borderRadius: BorderRadius.circular(
//                                             10,
//                                           ),
//                                         ),
//                                         padding: const EdgeInsets.symmetric(
//                                           horizontal: 10,
//                                           vertical: 6,
//                                         ),
//                                         child: Text(
//                                           "${topper.points ?? 0} pts",
//                                           style: const TextStyle(
//                                             color: Color(0xffC44FFF),
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               if (currentUser != null)
//                 Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(
//                         color: AppColor.primaryColor1,
//                         width: 1.2,
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 4,
//                           spreadRadius: 1,
//                         ),
//                       ],
//                     ),
//                     child: ListTile(
//                       leading: const CircleAvatar(
//                         radius: 25,
//                         backgroundColor: AppColor.primaryColor1,
//                         child: Icon(Icons.person, color: Colors.white),
//                       ),
//                       title: Text(
//                         "Your Rank: ${currentUser.rank}",
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       subtitle: Text(
//                         "Your Points: ${currentUser.points}",
//                         style: const TextStyle(
//                           color: Colors.black87,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       trailing: const Text(
//                         "YOU",
//                         style: TextStyle(
//                           color: Colors.green,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }
//
// class TopPerformerWidget extends StatelessWidget {
//   final String imageUrl;
//   final String points;
//   final String name;
//   final double sizeFactor;
//
//   const TopPerformerWidget({
//     super.key,
//     required this.imageUrl,
//     required this.points,
//     required this.name,
//     this.sizeFactor = 1.0,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final size = 90.0 * sizeFactor;
//
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           height: size,
//           width: size,
//           decoration: BoxDecoration(
//             border: Border.all(color: AppColor.primaryColor1, width: 1.5),
//             shape: BoxShape.circle,
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(2),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(size),
//               child: imageUrl.isNotEmpty
//                   ? Image.network(
//                       imageUrl,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) {
//                         return Container(
//                           color: Colors.grey[300],
//                           child: const Icon(Icons.person, size: 40),
//                         );
//                       },
//                     )
//                   : Container(
//                       color: Colors.grey[300],
//                       child: const Icon(Icons.person, size: 40),
//                     ),
//             ),
//           ),
//         ),
//         VS(height: 4),
//         Container(
//           decoration: BoxDecoration(
//             color: const Color(0xffF2D8FF),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//           child: Text(
//             "$points pts",
//             style: const TextStyle(
//               color: Color(0xffC44FFF),
//               fontSize: 12,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//         VS(height: 2),
//         Text(
//           name,
//           style: TextStyle(
//             color: AppColor.blackColor,
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }
// }
// import 'package:opinion_easy/controller/topper_controller.dart';
// import 'package:opinion_easy/core/utils/widgets/loader_widget/topper_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:opinion_easy/core/utils/colors.dart';
// import 'package:get/get.dart';
//
// class YearlyTopPerformerView extends StatefulWidget {
//   const YearlyTopPerformerView({super.key});
//
//   @override
//   State<YearlyTopPerformerView> createState() => _YearlyTopPerformerViewState();
// }
//
// class _YearlyTopPerformerViewState extends State<YearlyTopPerformerView> {
//   final TopperController topperController = Get.put(TopperController());
//
//   @override
//   void initState() {
//     super.initState();
//     topperController.fetchTopperList("year");
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA), // Clean light background
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFF8F9FA),
//         surfaceTintColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: true,
//         title: const Text(
//           "Yearly Leaders",
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//       ),
//       body: Obx(() {
//         if (topperController.isLoading.value) {
//           return const ShimmerTopPerformerView();
//         }
//
//         final model = topperController.topperModel.value;
//
//         // Check if data is null or empty
//         if (model.data == null || model.data!.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.emoji_events_outlined,
//                   size: 64,
//                   color: Colors.grey[300],
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   "No leaders found",
//                   style: TextStyle(color: Colors.grey[600], fontSize: 16),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         final topperList = model.data!;
//         final currentUser = model.currentUser;
//
//         // Separate top 3 and the rest
//         final top3 = topperList.take(3).toList();
//         final rest = topperList.length > 3 ? topperList.sublist(3) : [];
//
//         return Stack(
//           children: [
//             Column(
//               children: [
//                 // Podiums area
//                 Padding(
//                   padding: const EdgeInsets.only(top: 10, bottom: 24),
//                   child: _buildPodiumSection(top3),
//                 ),
//
//                 // List area
//                 Expanded(
//                   child: Container(
//                     decoration: const BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(30),
//                         topRight: Radius.circular(30),
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 15,
//                           offset: Offset(0, -5),
//                         ),
//                       ],
//                     ),
//                     child: ClipRRect(
//                       borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(30),
//                         topRight: Radius.circular(30),
//                       ),
//                       child: ListView.separated(
//                         padding: const EdgeInsets.fromLTRB(
//                           20,
//                           20,
//                           20,
//                           100,
//                         ), // padding for bottom fixed widget
//                         itemCount: rest.length,
//                         separatorBuilder: (context, index) =>
//                             const Divider(height: 1, color: Color(0xFFEEEEEE)),
//                         itemBuilder: (context, index) {
//                           final item = rest[index];
//                           // Rank is index + 4 because top 3 are handled separately
//                           return _buildListItem(item, index + 4);
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//
//             // Current User Rank at bottom
//             if (currentUser != null)
//               Positioned(
//                 left: 20,
//                 right: 20,
//                 bottom: 24,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 12,
//                   ),
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(
//                       colors: [AppColor.primaryColor1, Color(0xFF6F63FF)],
//                     ),
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: AppColor.primaryColor1.withOpacity(0.4),
//                         blurRadius: 12,
//                         offset: const Offset(0, 6),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           "#${currentUser.rank ?? '-'}",
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       const Expanded(
//                         child: Text(
//                           "You",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       Text(
//                         "${currentUser.points ?? 0} pts",
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 15,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//           ],
//         );
//       }),
//     );
//   }
//
//   Widget _buildPodiumSection(List<dynamic> top3) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         // Rank 2
//         if (top3.length > 1)
//           Padding(
//             padding: const EdgeInsets.only(right: 12),
//             child: _buildPodiumItem(top3[1], 2),
//           ),
//
//         // Rank 1 (Middle)
//         if (top3.isNotEmpty)
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 4),
//             child: _buildPodiumItem(top3[0], 1),
//           ),
//
//         // Rank 3
//         if (top3.length > 2)
//           Padding(
//             padding: const EdgeInsets.only(left: 12),
//             child: _buildPodiumItem(top3[2], 3),
//           ),
//       ],
//     );
//   }
//
//   Widget _buildPodiumItem(dynamic user, int rank) {
//     double size = rank == 1 ? 110 : 80;
//     Color borderColor = rank == 1
//         ? const Color(0xFFFFD700) // Gold
//         : rank == 2
//         ? const Color(0xFFC0C0C0) // Silver
//         : const Color(0xFFCD7F32); // Bronze
//
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         // Crown for rank 1
//         if (rank == 1)
//           const Padding(
//             padding: EdgeInsets.only(bottom: 8),
//             child: Icon(Icons.emoji_events, color: Color(0xFFFFD700), size: 36),
//           ),
//
//         Stack(
//           alignment: Alignment.center,
//           clipBehavior: Clip.none,
//           children: [
//             Container(
//               height: size,
//               width: size,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(color: borderColor, width: 3),
//                 boxShadow: [
//                   BoxShadow(
//                     color: borderColor.withOpacity(0.3),
//                     blurRadius: 15,
//                     spreadRadius: 2,
//                   ),
//                 ],
//               ),
//               child: ClipOval(
//                 child: (user.profilePic != null && user.profilePic!.isNotEmpty)
//                     ? Image.network(
//                         user.profilePic!,
//                         fit: BoxFit.cover,
//                         errorBuilder: (_, __, ___) =>
//                             const Icon(Icons.person, size: 40),
//                       )
//                     : const Icon(Icons.person, size: 40, color: Colors.grey),
//               ),
//             ),
//             Positioned(
//               bottom: -10,
//               child: Container(
//                 height: 24,
//                 width: 24,
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   color: borderColor,
//                   shape: BoxShape.circle,
//                   border: Border.all(color: Colors.white, width: 2),
//                   boxShadow: const [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 4,
//                       offset: Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Text(
//                   "$rank",
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 12,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: rank == 1 ? 20 : 16),
//         SizedBox(
//           width: size + 20,
//           child: Text(
//             user.name ?? "User",
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 14,
//               color: Colors.black87,
//             ),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//         const SizedBox(height: 2),
//         Text(
//           "${user.points ?? 0}",
//           style: const TextStyle(
//             color: AppColor.primaryColor1,
//             fontWeight: FontWeight.w800,
//             fontSize: 13,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildListItem(dynamic user, int rank) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
//       child: Row(
//         children: [
//           SizedBox(
//             width: 30,
//             child: Text(
//               "$rank",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w800,
//                 color: Colors.grey[400],
//               ),
//             ),
//           ),
//           const SizedBox(width: 16),
//           CircleAvatar(
//             radius: 24,
//             backgroundColor: Colors.grey[100],
//             backgroundImage:
//                 (user.profilePic != null && user.profilePic!.isNotEmpty)
//                 ? NetworkImage(user.profilePic!)
//                 : null,
//             child: (user.profilePic == null || user.profilePic!.isEmpty)
//                 ? Icon(Icons.person, color: Colors.grey[400])
//                 : null,
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   user.name ?? "User",
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black87,
//                   ),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: AppColor.primaryColor1.withOpacity(0.08),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Text(
//               "${user.points ?? 0} pts",
//               style: const TextStyle(
//                 color: AppColor.primaryColor1,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 13,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
