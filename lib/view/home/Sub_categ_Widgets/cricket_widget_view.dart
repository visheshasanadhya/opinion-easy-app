//  cricket_view.dart
// ========================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../../controller/Cricket/cricket_controller.dart';
import '../../../core/admob/admob.dart';
import '../../../data/model/cricket_match_model.dart';

class CricketView extends StatefulWidget {
  const CricketView({super.key});

  @override
  State<CricketView> createState() => _CricketViewState();
}

class _CricketViewState extends State<CricketView>
    with SingleTickerProviderStateMixin {
  final CricketController controller = Get.put(CricketController());
  final AdsController adsController = Get.put(
    AdsController(),
    tag: 'cricket_ad',
  );

  late AnimationController blinkController;
  late Animation<double> blinkAnimation;

  int selectedTab = 0;
  bool adLoadedOnce = false;
  String? selectedSeries;

  @override
  void initState() {
    super.initState();
    blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    blinkAnimation = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(blinkController);
  }

  @override
  void dispose() {
    blinkController.dispose();
    super.dispose();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   if (!adLoadedOnce) {
  //     adLoadedOnce = true;
  //     adsController.loadAdaptiveBanner(
  //       context,
  //       "ca-app-pub-4639427395020302/9834697729",
  //     );
  //   }
  // }

  // ✅ IST FORMATTERS
  String _formatTime(DateTime? dt) =>
      dt == null ? '' : DateFormat('h:mm a').format(dt);

  String _formatDate(DateTime? dt) =>
      dt == null ? '' : DateFormat('MMM dd, yyyy').format(dt);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            _tabs(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.refreshCricketData,
                child: Obx(() {
                  if (controller.isLoading.value &&
                      controller.allMatches.isEmpty) {
                    return _shimmer();
                  }

                  if (controller.hasError.value) {
                    return _error(controller.errorMessage.value);
                  }

                  // Show league list or match details based on selection
                  return selectedSeries == null
                      ? _buildLeaguesList()
                      : _buildMatchList(_getMatchesForSelectedSeries());
                }),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _adBanner(),
    );
  }

  // ================= HEADER =================
  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (selectedSeries != null) {
                // Go back to leagues list
                setState(() => selectedSeries = null);
              } else {
                // Exit the screen
                //Get.back();
                Navigator.pop(context);
              }
            },
          ),
          Expanded(
            child: Text(
              selectedSeries ?? 'Cricket Matches',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  // ================= TABS =================
  Widget _tabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [_tab('Live', 0), _tab('Upcoming', 1), _tab('Results', 2)],
      ),
    );
  }

  Widget _tab(String title, int index) {
    final selected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = index;
            selectedSeries = null; // Reset selection when changing tabs
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected ? Colors.blue : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              color: selected ? Colors.blue : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }

  // ================= LEAGUES LIST =================
  Widget _buildLeaguesList() {
    final matches = _getCurrentTabMatches();
    if (matches.isEmpty) return _empty();

    // Group by series and get unique leagues
    final grouped = controller.groupMatchesBySeries(matches);
    final leagues = grouped.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: leagues.length,
      itemBuilder: (context, index) {
        final league = leagues[index];
        final matchCount = grouped[league]!.length;

        return _leagueCard(league, matchCount);
      },
    );
  }

  Widget _leagueCard(String league, int matchCount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          setState(() => selectedSeries = league);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.sports_cricket,
                  color: Colors.blue,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      league,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$matchCount ${matchCount == 1 ? 'match' : 'matches'}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= MATCH LIST =================
  List<CricketMatchModel> _getCurrentTabMatches() {
    switch (selectedTab) {
      case 0:
        return controller.liveMatches;
      case 1:
        return controller.upcomingMatches;
      case 2:
        return controller.resultMatches;
      default:
        return [];
    }
  }

  List<CricketMatchModel> _getMatchesForSelectedSeries() {
    final matches = _getCurrentTabMatches();
    return matches.where((m) => m.series == selectedSeries).toList();
  }

  Widget _buildMatchList(List<CricketMatchModel> matches) {
    if (matches.isEmpty) return _empty();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: matches.length,
      itemBuilder: (context, index) {
        return _matchCard(matches[index]);
      },
    );
  }

  // ================= MATCH CARD =================
  Widget _matchCard(CricketMatchModel match) {
    final bool isLive = match.isLive;
    final bool isResult = match.isResult;

    final Color statusColor = isLive
        ? Colors.red
        : isResult
        ? Colors.green
        : Colors.blue;

    final String statusText = isLive
        ? 'LIVE'
        : isResult
        ? 'RESULT'
        : 'UPCOMING';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _statusBar(match, statusText, statusColor),
          _matchBody(match, statusColor),
        ],
      ),
    );
  }

  Widget _statusBar(
    CricketMatchModel match,
    String statusText,
    Color statusColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        children: [
          if (match.isLive)
            FadeTransition(
              opacity: blinkAnimation,
              child: CircleAvatar(radius: 4, backgroundColor: statusColor),
            ),
          if (match.isLive) const SizedBox(width: 8),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: statusColor,
            ),
          ),
          const Spacer(),
          Text(
            match.formattedISTTime,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _matchBody(CricketMatchModel match, Color statusColor) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _teamRow(
            match.team1Short,
            match.team1ScoreClean,
            match.team1Overs,
            match.t1img,
          ),
          const SizedBox(height: 12),
          _teamRow(
            match.team2Short,
            match.team2ScoreClean,
            match.team2Overs,
            match.t2img,
          ),
          if (match.status.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                match.status,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
          if (match.isUpcoming && match.matchDateTimeIST != null) ...[
            const SizedBox(height: 8),
            Text(
              match.formattedISTDate,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ],
      ),
    );
  }

  Widget _teamRow(String team, String score, String overs, String? imageUrl) {
    return Row(
      children: [
        if (imageUrl != null && imageUrl.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              imageUrl,
              width: 32,
              height: 32,
              errorBuilder: (_, __, ___) => _teamPlaceholder(),
            ),
          )
        else
          _teamPlaceholder(),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            team,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ),
        if (overs.isNotEmpty)
          Text(
            '($overs)',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        const SizedBox(width: 8),
        if (score.isNotEmpty)
          Text(
            score,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
      ],
    );
  }

  Widget _teamPlaceholder() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(Icons.sports_cricket, size: 18, color: Colors.grey.shade600),
    );
  }

  // ================= STATES =================
  Widget _empty() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.sports_cricket, size: 64, color: Colors.grey.shade300),
        const SizedBox(height: 16),
        const Text('No matches available'),
      ],
    ),
  );

  Widget _error(String msg) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
        const SizedBox(height: 16),
        Text(msg, textAlign: TextAlign.center),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: controller.refreshCricketData,
          icon: const Icon(Icons.refresh),
          label: const Text('Retry'),
        ),
      ],
    ),
  );

  Widget _shimmer() => SingleChildScrollView(
    physics: const NeverScrollableScrollPhysics(),
    padding: const EdgeInsets.all(16),
    child: Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: Column(
        children: List.generate(
          5,
          (_) => Container(
            height: 160,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    ),
  );

  // ================= ADS =================
  Widget _adBanner() {
    return Obx(() {
      if (!adsController.isLoaded.value || adsController.bannerAd == null) {
        return const SizedBox.shrink();
      }
      final ad = adsController.bannerAd!;
      return Container(
        color: Colors.white,
        child: SizedBox(
          width: ad.size.width.toDouble(),
          height: ad.size.height.toDouble(),
          child: AdWidget(ad: ad),
        ),
      );
    });
  }
}
