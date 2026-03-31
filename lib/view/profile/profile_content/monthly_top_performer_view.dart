// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:opinion_easy/controller/topper_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:opinion_easy/core/utils/colors.dart';
// import 'package:opinion_easy/core/utils/widgets/spacing_widget.dart';
// import 'package:get/get.dart';
//
// class MonthlyTopPerformerView extends StatefulWidget {
//   const MonthlyTopPerformerView({super.key});
//
//   @override
//   State<MonthlyTopPerformerView> createState() =>
//       _YearlyTopPerformerViewState();
// }
//
// class _YearlyTopPerformerViewState extends State<MonthlyTopPerformerView> {
//   final TopperController topperController = Get.put(TopperController());
//
//   @override
//   void initState() {
//     super.initState();
//     topperController.fetchTopperList("month");
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
//       body: SafeArea(
//         child: Obx(() {
//           final model = topperController.topperModel.value;
//
//           if (model.data == null || model.data!.isEmpty) {
//             return const Center(child: Text("Yearly topper list is empty"));
//           }
//
//           final topperList = model.data!;
//           final currentUser = model.currentUser;
//
//           return SingleChildScrollView(
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: size.height * 0.4,
//                   width: double.infinity,
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       Positioned(
//                         bottom: 0,
//                         child: Image.asset(
//                           "assets/images/rank.png",
//                           height: size.height * 0.24,
//                           fit: BoxFit.contain,
//                         ),
//                       ),
//                       if (topperList.isNotEmpty)
//                         Positioned(
//                           top: 0,
//                           child: TopPerformerWidget(
//                             imageUrl: topperList[0].profilePic ?? '',
//                             points: topperList[0].points?.toString() ?? '0',
//                             name: topperList[0].name ?? 'N/A',
//                           ),
//                         ),
//                       if (topperList.length > 1)
//                         Positioned(
//                           left: size.width * 0.12,
//                           top: 80,
//                           child: TopPerformerWidget(
//                             imageUrl: topperList[1].profilePic ?? '',
//                             points: topperList[1].points?.toString() ?? '0',
//                             name: topperList[1].name ?? 'N/A',
//                             sizeFactor: 0.8,
//                           ),
//                         ),
//                       if (topperList.length > 2)
//                         Positioned(
//                           right: size.width * 0.12,
//                           top: 80,
//                           child: TopPerformerWidget(
//                             imageUrl: topperList[2].profilePic ?? '',
//                             points: topperList[2].points?.toString() ?? '0',
//                             name: topperList[2].name ?? 'N/A',
//                             sizeFactor: 0.8,
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   width: double.infinity,
//                   decoration: const BoxDecoration(
//                     color: Color(0xffD9D9D9),
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(20),
//                       topRight: Radius.circular(20),
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 4,
//                         spreadRadius: 1,
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       VS(height: 10),
//                       const Text(
//                         "This Month's Top Earners",
//                         style: TextStyle(
//                           fontSize: 17,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.black,
//                         ),
//                       ),
//                       VS(height: 10),
//                       Container(
//                         decoration: const BoxDecoration(
//                           color: Color(0xff6F63FF),
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(40),
//                             topRight: Radius.circular(40),
//                           ),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                             vertical: 20,
//                             horizontal: 16,
//                           ),
//                           child: Column(
//                             children: [
//                               Container(
//                                 decoration: BoxDecoration(
//                                   color: AppColor.whileColor,
//                                   borderRadius: BorderRadius.circular(30),
//                                 ),
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 8,
//                                   horizontal: 12,
//                                 ),
//                                 child: const Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       "Position",
//                                       style: TextStyle(
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.w500,
//                                         color: Color(0xff6F63FF),
//                                       ),
//                                     ),
//                                     Text(
//                                       "User",
//                                       style: TextStyle(
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.w500,
//                                         color: Color(0xff6F63FF),
//                                       ),
//                                     ),
//                                     Text(
//                                       "Points",
//                                       style: TextStyle(
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.w500,
//                                         color: Color(0xff6F63FF),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               VS(height: 20),
//                               ListView.builder(
//                                 itemCount: topperList.length,
//                                 shrinkWrap: true,
//                                 physics: const NeverScrollableScrollPhysics(),
//                                 itemBuilder: (context, index) {
//                                   final topper = topperList[index];
//
//                                   return Padding(
//                                     padding: const EdgeInsets.only(
//                                       left: 20,
//                                       right: 20,
//                                       top: 10,
//                                       bottom: 10,
//                                     ),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         SizedBox(
//                                           width: 40,
//                                           child: Text(
//                                             "${index + 1}",
//                                             style: const TextStyle(
//                                               fontSize: 17,
//                                               fontWeight: FontWeight.w500,
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                         ),
//                                         Expanded(
//                                           child: Text(
//                                             topper.name ?? 'N/A',
//                                             textAlign: TextAlign.center,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: const TextStyle(
//                                               fontSize: 17,
//                                               fontWeight: FontWeight.w500,
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                         ),
//                                         Container(
//                                           decoration: BoxDecoration(
//                                             color: const Color(0xffF2D8FF),
//                                             borderRadius: BorderRadius.circular(
//                                               10,
//                                             ),
//                                           ),
//                                           padding: const EdgeInsets.symmetric(
//                                             horizontal: 10,
//                                             vertical: 6,
//                                           ),
//                                           child: Text(
//                                             "${topper.points ?? 0} pts",
//                                             style: const TextStyle(
//                                               color: Color(0xffC44FFF),
//                                               fontSize: 12,
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 if (currentUser != null)
//                   Padding(
//                     padding: const EdgeInsets.all(12),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color: AppColor.primaryColor1,
//                           width: 1.2,
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black12,
//                             blurRadius: 4,
//                             spreadRadius: 1,
//                           ),
//                         ],
//                       ),
//                       child: ListTile(
//                         leading: const CircleAvatar(
//                           radius: 25,
//                           backgroundColor: AppColor.primaryColor1,
//                           child: Icon(Icons.person, color: Colors.white),
//                         ),
//                         title: Text(
//                           "Your Rank: ${currentUser.rank}",
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                         subtitle: Text(
//                           "Your Points: ${currentUser.points}",
//                           style: const TextStyle(
//                             color: Colors.black87,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         trailing: const Text(
//                           "YOU",
//                           style: TextStyle(
//                             color: Colors.green,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           );
//         }),
//       ),
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
import 'package:opinion_easy/controller/topper_controller.dart';
import 'package:opinion_easy/core/utils/widgets/loader_widget/topper_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_constants.dart';

class MonthlyTopPerformerView extends StatefulWidget {
  const MonthlyTopPerformerView({super.key});

  @override
  State<MonthlyTopPerformerView> createState() =>
      _MonthlyTopPerformerViewState();
}

class _MonthlyTopPerformerViewState extends State<MonthlyTopPerformerView> {
  final TopperController topperController = Get.put(TopperController());

  @override
  void initState() {
    super.initState();

    topperController.fetchTopperList("month");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        title: Text("Monthly Leaders"),
        backgroundColor: AppColor.whileColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: AppColor.blackColor),
        ),
      ),
      body: Obx(() {
        if (topperController.isLoading.value) {
          return const Stack(
            children: [Positioned.fill(child: ShimmerTopPerformerView())],
          );
        }

        final model = topperController.topperModel.value;
        if (model.data == null || model.data!.isEmpty) {
          return _buildEmptyState();
        }

        final topperList = model.data!;
        final currentUser = model.currentUser;
        final top3 = topperList.take(3).toList();
        final rest = topperList.length > 3 ? topperList.sublist(3) : [];

        return Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  _buildHeroSection(top3),
                  Expanded(child: _buildListSection(rest)),
                ],
              ),
            ),
            if (currentUser != null)
              Positioned(
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).padding.bottom + 16,
                child: _buildCurrentUserTile(currentUser),
              ),
          ],
        );
      }),
    );
  }

  // --- EMPTY STATE (Updated for Month) ---
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColor.whiteColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColor.blackColor.withOpacity(0.05),
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Icon(
              Icons.leaderboard_outlined,
              size: 72,
              color: AppColor.primaryColor1.withOpacity(0.3),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "No leaders yet",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black26,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Be the first to lead this month!",
            style: TextStyle(fontSize: 16, color: AppColor.greyColor),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => topperController.fetchTopperList("month"),
            icon: const Icon(Icons.refresh, size: 20),
            label: const Text("Refresh"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryColor1,
              foregroundColor: AppColor.whiteColor,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  // --- HERO SECTION (PODIUM) ---
  Widget _buildHeroSection(List<dynamic> top3) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 16, bottom: 0),
      color: AppColor.whiteColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (top3.length > 1)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: _buildPodiumItem(top3[1], 2),
            ),
          if (top3.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _buildPodiumItem(top3[0], 1),
            ),
          if (top3.length > 2)
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: _buildPodiumItem(top3[2], 3),
            ),
        ],
      ),
    );
  }

  // --- LIST SECTION ---
  Widget _buildListSection(List<dynamic> rest) {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      decoration: const BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(
          20,
          32,
          20,
          100 + MediaQuery.of(context).padding.bottom,
        ),
        itemCount: rest.length,
        separatorBuilder: (context, index) => const Divider(
          color: Colors.grey,
          height: 1,
          thickness: 1,
          indent: 20,
          endIndent: 20,
        ),
        itemBuilder: (context, index) {
          final item = rest[index];
          return _buildListItem(item, index + 4);
        },
      ),
    );
  }

  // --- PODIUM ITEM ---
  Widget _buildPodiumItem(dynamic user, int rank) {
    final podiumConfig = {
      1: {
        'size': 100.0,
        'borderColor': AppColor.gold,
        'shadowColor': AppColor.gold,
        'heightFactor': 1.0,
      },
      2: {
        'size': 80.0,
        'borderColor': AppColor.silver,
        'shadowColor': AppColor.silver,
        'heightFactor': 0.85,
      },
      3: {
        'size': 75.0,
        'borderColor': AppColor.bronze,
        'shadowColor': AppColor.bronze,
        'heightFactor': 0.85,
      },
    };

    final config = podiumConfig[rank]!;
    final size = config['size'] as double;
    final borderColor = config['borderColor'] as Color;
    final shadowColor = config['shadowColor'] as Color;
    final heightFactor = config['heightFactor'] as double;

    double verticalOffset = rank == 1 ? 0 : 100 * (1 - heightFactor) + 20;

    return Transform.translate(
      offset: Offset(0, verticalOffset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (rank == 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Image.asset(
                "assets/icons/crown.png",
                height: 40,
                width: 40,
                color: AppColor.gold,
              ),
            ),
          Hero(
            tag: 'podium_monthly_$rank', // Unique tag for monthly
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: size,
                  width: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: borderColor, width: 3.5),
                    boxShadow: [
                      BoxShadow(
                        color: shadowColor.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 1,
                        offset: const Offset(0, 4),
                      ),
                      const BoxShadow(
                        color: AppColor.whiteColor,
                        spreadRadius: -2,
                        blurRadius: 10,
                      ),
                    ],
                    color: AppColor.whiteColor,
                  ),
                  child: ClipOval(
                    child: user.profilePic != null &&
                            user.profilePic!.isNotEmpty
                        ? Image.network(
                            user.profilePic!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _buildPlaceholderAvatar(
                              size,
                              AppColor.purpleDark,
                            ),
                          )
                        : _buildPlaceholderAvatar(size, AppColor.purpleDark),
                  ),
                ),
                Positioned(
                  bottom: -10,
                  child: Container(
                    height: 26,
                    width: 26,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: borderColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColor.whiteColor,
                        width: 2.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.blackColor.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      "$rank",
                      style: const TextStyle(
                        color: AppColor.whiteColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: rank == 1 ? 24 : 18),
          SizedBox(
            width: size + 30,
            child: Text(
              user.name ?? "User",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColor.blackColor,
                height: 1.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: borderColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor.withOpacity(0.3), width: 1),
            ),
            child: Text(
              "${user.points ?? 0} pts",
              style: TextStyle(
                color: borderColor,
                fontWeight: FontWeight.w800,
                fontSize: 13,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderAvatar(double size, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.greyColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person,
        color: color.withOpacity(0.7),
        size: size * 0.5,
      ),
    );
  }

  // --- LIST ITEM ---
  Widget _buildListItem(dynamic user, int rank) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 32,
              alignment: Alignment.center,
              child: Text(
                "$rank",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColor.blackColor,
                ),
              ),
            ),
            const SizedBox(width: 16),
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColor.greyColor,
              backgroundImage:
                  user.profilePic != null && user.profilePic!.isNotEmpty
                      ? NetworkImage(user.profilePic!)
                      : null,
              child: user.profilePic == null || user.profilePic!.isEmpty
                  ? _buildPlaceholderAvatar(
                      48,
                      AppColor.primaryColor1.withOpacity(0.7),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name ?? "User",
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "ID: ${user.id ?? 'N/A'}",
                    style: TextStyle(fontSize: 14, color: AppColor.greyColor),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: AppColor.primaryColor1.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                "${user.points ?? 0}",
                style: TextStyle(
                  color: AppColor.primaryColor1,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- CURRENT USER TILE ---
  Widget _buildCurrentUserTile(dynamic user) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColor.primaryColor1, AppColor.purpleDark],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryColor1.withOpacity(0.5),
            blurRadius: 30,
            spreadRadius: -5,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.whiteColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "#${user.rank ?? '-'}",
                    style: const TextStyle(
                      color: AppColor.whiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    "You",
                    style: TextStyle(
                      color: AppColor.whiteColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  "${user.points ?? 0} pts",
                  style: const TextStyle(
                    color: AppColor.whiteColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
