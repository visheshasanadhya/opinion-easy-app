import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opinion_easy/controller/today_leader_controller.dart';
import 'package:opinion_easy/controller/topper_controller.dart';
import 'package:opinion_easy/core/utils/app_constants.dart';
import 'package:opinion_easy/core/utils/widgets/loader_widget/topper_widget.dart';
import 'package:opinion_easy/core/utils/widgets/spacing_widget.dart';

enum LeaderboardSource { bottomNav, profile }

enum LeaderboardType { today, monthly, yearly }

class LeaderboardView extends StatefulWidget {
  final LeaderboardSource source;
  final LeaderboardType initialType;

  const LeaderboardView({
    super.key,
    this.source = LeaderboardSource.bottomNav,
    this.initialType = LeaderboardType.today,
  });

  @override
  State<LeaderboardView> createState() => _LeaderboardViewState();
}

class _LeaderboardViewState extends State<LeaderboardView>
    with SingleTickerProviderStateMixin {
  final TodayLeaderController todayController = Get.put(
    TodayLeaderController(),
  );
  final TopperController topperController = Get.put(TopperController());

  late LeaderboardType selectedType;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    selectedType = widget.initialType;
    final initialIndex = selectedType == LeaderboardType.today
        ? 0
        : selectedType == LeaderboardType.monthly
            ? 1
            : 2;
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: initialIndex,
    );
    _tabController.addListener(_handleTabChange);
    _fetchData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      final newType = _tabController.index == 0
          ? LeaderboardType.today
          : _tabController.index == 1
              ? LeaderboardType.monthly
              : LeaderboardType.yearly;
      if (newType != selectedType) {
        setState(() => selectedType = newType);
        _fetchData();
      }
    }
  }

  void _fetchData() {
    switch (selectedType) {
      case LeaderboardType.today:
        todayController.fetchTodayLeaderList("today");
        break;
      case LeaderboardType.monthly:
        topperController.fetchMonthlyList();
        break;
      case LeaderboardType.yearly:
        topperController.fetchYearlyList();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffold,
      appBar: AppBar(
        backgroundColor: AppColor.card,
        surfaceTintColor: AppColor.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: widget.source == LeaderboardSource.profile
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColor.white,
                  size: 18,
                ),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        title: Text("Leaderboard", style: AppText.h3),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(57),
          child: Column(
            children: [
              Container(height: 1, color: AppColor.borderFaint),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColor.borderLight),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: AppColor.transparent,
                    labelColor: AppColor.black,
                    unselectedLabelColor: AppColor.white,
                    labelStyle: AppText.labelSm,
                    unselectedLabelStyle: AppText.label,
                    tabs: const [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.today_outlined, size: 14),
                            HS(4),
                            Text("Today"),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.date_range_outlined, size: 14),
                            HS(4),
                            Text("Monthly"),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calendar_month_outlined, size: 14),
                            HS(4),
                            Text("Yearly"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTodayTab(),
          _buildMonthlyTab(),
          _buildYearlyTab(),
        ],
      ),
    );
  }

  Widget _buildTodayTab() {
    return Obx(() {
      if (todayController.isLoading.value) {
        return const Stack(
          children: [Positioned.fill(child: ShimmerTopPerformerView())],
        );
      }
      final model = todayController.todayLeaderModel.value;
      if (model.data == null || model.data!.isEmpty) {
        return _emptyState(
          "No leaders today",
          "Be the first to lead today!",
          Icons.today_outlined,
        );
      }
      final list = model.data!;
      return _leaderboardContent(
        list.take(3).toList(),
        list.length > 3 ? list.sublist(3) : [],
        model.currentUser,
      );
    });
  }

  Widget _buildMonthlyTab() {
    return Obx(() {
      if (topperController.isMonthlyLoading.value) {
        return const Stack(
          children: [Positioned.fill(child: ShimmerTopPerformerView())],
        );
      }
      final model = topperController.monthlyModel.value;
      if (model.data == null || model.data!.isEmpty) {
        return _emptyState(
          "No monthly leaders",
          "Be the first to lead this month!",
          Icons.date_range_outlined,
        );
      }
      final list = model.data!;
      return _leaderboardContent(
        list.take(3).toList(),
        list.length > 3 ? list.sublist(3) : [],
        model.currentUser,
      );
    });
  }

  Widget _buildYearlyTab() {
    return Obx(() {
      if (topperController.isYearlyLoading.value) {
        return const Stack(
          children: [Positioned.fill(child: ShimmerTopPerformerView())],
        );
      }
      final model = topperController.yearlyModel.value;
      if (model.data == null || model.data!.isEmpty) {
        return _emptyState(
          "No yearly leaders",
          "Be the first to lead this year!",
          Icons.leaderboard_outlined,
        );
      }
      final list = model.data!;
      return _leaderboardContent(
        list.take(3).toList(),
        list.length > 3 ? list.sublist(3) : [],
        model.currentUser,
      );
    });
  }

  Widget _leaderboardContent(
    List<dynamic> top3,
    List<dynamic> rest,
    dynamic currentUser,
  ) {
    return Stack(
      children: [
        Positioned.fill(
          child: Column(
            children: [
              _podiumSection(top3),
              Expanded(child: _listSection(rest)),
            ],
          ),
        ),
        if (currentUser != null)
          Positioned(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).padding.bottom + 14,
            child: _currentUserTile(currentUser),
          ),
      ],
    );
  }

  // --- HERO SECTION (PODIUM) ---
  Widget _podiumSection(List<dynamic> top3) {
    return Container(
      width: double.infinity,
      color: AppColor.scaffold,
      padding: const EdgeInsets.only(top: 16, bottom: 20),
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

  // --- PODIUM ITEM ---
  Widget _buildPodiumItem(dynamic user, int rank) {
    final podiumConfig = {
      1: {
        'size': 96.0,
        'borderColor': AppColor.gold,
        'shadowColor': AppColor.gold,
        'heightFactor': 1.0,
      },
      2: {
        'size': 78.0,
        'borderColor': AppColor.silver,
        'shadowColor': AppColor.silver,
        'heightFactor': 0.85,
      },
      3: {
        'size': 72.0,
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

    final double verticalOffset =
        rank == 1 ? 0 : 96.0 * (1 - heightFactor) + 20;

    return Transform.translate(
      offset: Offset(0, verticalOffset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (rank == 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Image.asset(
                AppAsset.crown,
                height: 38,
                width: 38,
                color: AppColor.gold,
              ),
            ),
          Hero(
            tag: 'podium_${selectedType.name}_$rank',
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
                        color: shadowColor.withOpacity(0.4),
                        blurRadius: 18,
                        spreadRadius: 1,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    color: AppColor.cardAlt,
                  ),
                  child: ClipOval(
                    child:
                        user.profilePic != null && user.profilePic!.isNotEmpty
                            ? Image.network(
                                user.profilePic!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _avatarPlaceholder(size),
                              )
                            : _avatarPlaceholder(size),
                  ),
                ),
                Positioned(
                  bottom: -10,
                  child: Container(
                    height: 24,
                    width: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: borderColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColor.scaffold,
                        width: 2.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.blackOp(0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      "$rank",
                      style: TextStyle(
                        color: rank == 3 ? AppColor.white : AppColor.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: rank == 1 ? 22 : 16),
          SizedBox(
            width: size + 24,
            child: Text(
              user.name ?? "User",
              textAlign: TextAlign.center,
              style: AppText.labelSm.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColor.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: borderColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor.withOpacity(0.4), width: 1),
            ),
            child: Text(
              "${user.points ?? 0} pts",
              style: TextStyle(
                color: borderColor,
                fontWeight: FontWeight.w800,
                fontSize: 12,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listSection(List<dynamic> rest) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: AppColor.card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: AppColor.borderFaint),
      ),
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(
          20,
          24,
          20,
          80 + MediaQuery.of(context).padding.bottom,
        ),
        itemCount: rest.length,
        separatorBuilder: (_, __) => Divider(
          color: AppColor.borderFaint,
          height: 1,
          thickness: 1,
          indent: 60,
        ),
        itemBuilder: (_, index) => _listItem(rest[index], index + 4),
      ),
    );
  }

  Widget _listItem(dynamic user, int rank) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColor.borderLight),
            ),
            child: Center(child: Text("$rank", style: AppText.labelSm)),
          ),
          HS(12),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColor.borderLight, width: 1.5),
            ),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: AppColor.cardAlt,
              backgroundImage:
                  user.profilePic != null && user.profilePic!.isNotEmpty
                      ? NetworkImage(user.profilePic!)
                      : null,
              child: user.profilePic == null || user.profilePic!.isEmpty
                  ? const Icon(Icons.person, color: AppColor.textGrey, size: 20)
                  : null,
            ),
          ),
          HS(12),
          Expanded(
            child: Text(
              user.name ?? "User",
              style: AppText.bodyMd,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: AppDeco.borderOnly(r: 14),
            child: Text("${user.points ?? 0} pts", style: AppText.labelSm),
          ),
        ],
      ),
    );
  }

  Widget _currentUserTile(dynamic user) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.whiteOp(0.15),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColor.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "#${user.rank ?? '-'}",
              style: AppText.labelSm.copyWith(color: AppColor.white),
            ),
          ),
          HS(12),
          const Icon(
            Icons.account_circle_outlined,
            color: AppColor.black,
            size: 22,
          ),
          HS(8),
          Expanded(
            child: Text(
              "Your Position",
              style: AppText.body.copyWith(color: AppColor.black),
            ),
          ),
          Text(
            "${user.points ?? 0}",
            style: AppText.points.copyWith(color: AppColor.black),
          ),
          HS(4),
          Text("pts", style: AppText.caption.copyWith(color: AppColor.black)),
          HS(6),
          const Icon(Icons.arrow_forward_ios, size: 13, color: AppColor.black),
        ],
      ),
    );
  }

  Widget _emptyState(String title, String subtitle, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: AppDeco.circleBorder,
            child: Icon(icon, size: 48, color: AppColor.white),
          ),
          VS(24),
          Text(title, style: AppText.h2),
          VS(8),
          Text(subtitle, style: AppText.caption),
          VS(32),
          ElevatedButton.icon(
            onPressed: _fetchData,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text("Refresh"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.white,
              foregroundColor: AppColor.black,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDeco.radius),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatarPlaceholder(double size) {
    return Container(
      color: AppColor.cardAlt,
      child: Icon(Icons.person, color: AppColor.textGrey, size: size * 0.45),
    );
  }
}
