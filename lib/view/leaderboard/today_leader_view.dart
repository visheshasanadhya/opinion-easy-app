import 'package:opinion_easy/controller/today_leader_controller.dart';
import 'package:opinion_easy/controller/topper_controller.dart';
import 'package:opinion_easy/core/utils/app_constants.dart';
import 'package:opinion_easy/core/utils/widgets/loader_widget/topper_widget.dart';
import 'package:opinion_easy/core/utils/widgets/spacing_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum LeaderboardSource { bottomNav, profile }

enum LeaderboardType { today, yearly }

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
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: selectedType == LeaderboardType.today ? 0 : 1,
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
          : LeaderboardType.yearly;
      if (newType != selectedType) {
        setState(() => selectedType = newType);
        _fetchData();
      }
    }
  }

  void _fetchData() {
    if (selectedType == LeaderboardType.today)
      todayController.fetchTodayLeaderList("today");
    else
      topperController.fetchTopperList("year");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffold,
      appBar: AppBar(
        backgroundColor: AppColor.card,
        surfaceTintColor: Colors.transparent,
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
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                    dividerColor: Colors.transparent,
                    labelColor: AppColor.black,
                    unselectedLabelColor: AppColor.white,
                    labelStyle: AppText.labelSm,
                    unselectedLabelStyle: AppText.label,
                    tabs: const [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.today_outlined, size: 15),
                            HS(5),
                            Text("Today"),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calendar_month_outlined, size: 15),
                            HS(5),
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
        children: [_buildTodayTab(), _buildYearlyTab()],
      ),
    );
  }

  Widget _buildTodayTab() {
    return Obx(() {
      if (todayController.isLoading.value)
        return const Stack(
          children: [Positioned.fill(child: ShimmerTopPerformerView())],
        );
      final model = todayController.todayLeaderModel.value;
      if (model.data == null || model.data!.isEmpty)
        return _emptyState(
          "No leaders today",
          "Be the first to lead!",
          Icons.today_outlined,
        );
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
      if (topperController.isLoading.value)
        return const Stack(
          children: [Positioned.fill(child: ShimmerTopPerformerView())],
        );
      final model = topperController.topperModel.value;
      if (model.data == null || model.data!.isEmpty)
        return _emptyState(
          "No yearly leaders",
          "Be the first to lead!",
          Icons.leaderboard_outlined,
        );
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

  Widget _podiumSection(List<dynamic> top3) {
    return Container(
      color: AppColor.scaffold,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (top3.length > 1) _podiumAvatar(top3[1], 2),
          HS(18),
          if (top3.isNotEmpty) _podiumAvatar(top3[0], 1),
          HS(18),
          if (top3.length > 2) _podiumAvatar(top3[2], 3),
        ],
      ),
    );
  }

  Widget _podiumAvatar(dynamic user, int rank) {
    final double size = rank == 1 ? 88.0 : 70.0;
    return Column(
      children: [
        if (rank == 1) ...[
          const Icon(
            Icons.emoji_events_rounded,
            color: AppColor.white,
            size: 24,
          ),
          VS(6),
        ],
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: size,
              width: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColor.borderStrong,
                  width: rank == 1 ? 2.5 : 2,
                ),
              ),
              child: ClipOval(
                child: user.profilePic != null && user.profilePic!.isNotEmpty
                    ? Image.network(
                        user.profilePic!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _avatarPlaceholder(size),
                      )
                    : _avatarPlaceholder(size),
              ),
            ),
            Positioned(
              bottom: -7,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  height: 22,
                  width: 22,
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColor.scaffold, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      "$rank",
                      style: AppText.micro.copyWith(fontSize: 11),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        VS(14),
        SizedBox(
          width: size + 16,
          child: Text(
            user.name ?? 'User',
            textAlign: TextAlign.center,
            style: AppText.labelSm,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        VS(5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: AppDeco.borderOnly(r: 16),
          child: Text(
            "${user.points ?? 0} pts",
            style: AppText.captionSm.copyWith(color: AppColor.white),
          ),
        ),
      ],
    );
  }

  Widget _listSection(List<dynamic> rest) {
    return Container(
      margin: const EdgeInsets.only(top: 2),
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
