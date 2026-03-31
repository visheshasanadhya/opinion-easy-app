// new_match_detail_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../controller/Cricket/match_detail_controller.dart';
import '../../../../controller/scorecard_model.dart';

class NewMatchDetailView extends StatelessWidget {
  final String matchId;

  const NewMatchDetailView({super.key, required this.matchId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      NewMatchDetailController(matchId: matchId),
      tag: matchId,
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(controller),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasError.value) {
          return _buildErrorState(controller);
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMatchHeader(controller),
              _buildMatchInfo(controller),
              _buildWeatherCard(controller),
              _buildTabSelector(controller),
              _buildTabContent(controller),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar(NewMatchDetailController controller) {
    return AppBar(
      backgroundColor: const Color(0xFF5DADE2),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      title: Obx(() {
        final match = controller.matchDetail.value;
        return Text(
          match?.series ?? 'Match Details',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        );
      }),
    );
  }

  Widget _buildMatchHeader(NewMatchDetailController controller) {
    return Obx(() {
      final match = controller.matchDetail.value;
      if (match == null) return const SizedBox.shrink();

      return Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      CachedNetworkImage(
                        imageUrl: match.teamAImg,
                        width: 60,
                        height: 60,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              match.teamAShort,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        match.teamAShort,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        match.teamA,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Text(
                        'VS',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      CachedNetworkImage(
                        imageUrl: match.teamBImg,
                        width: 60,
                        height: 60,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              match.teamBShort,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        match.teamBShort,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        match.teamB,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMatchInfo(NewMatchDetailController controller) {
    return Obx(() {
      final match = controller.matchDetail.value;
      if (match == null) return const SizedBox.shrink();

      return Container(
        margin: const EdgeInsets.only(top: 12),
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
              Icons.sports_cricket,
              '${match.matchs} • ${match.matchType}',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.calendar_today,
              '${match.matchDate} • ${match.matchTime}',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.location_on, '${match.venue}, ${match.place}'),
            if (match.toss.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildInfoRow(Icons.sports, match.toss),
            ],
            if (match.result.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        match.result,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.green.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        controller.getMatchStatusText(),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherCard(NewMatchDetailController controller) {
    return Obx(() {
      final weather = controller.matchDetail.value?.venueWeather;
      if (weather == null) return const SizedBox.shrink();

      return Container(
        margin: const EdgeInsets.only(top: 12),
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weather Conditions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                CachedNetworkImage(
                  imageUrl: weather.weatherIcon,
                  width: 50,
                  height: 50,
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.wb_sunny, size: 50),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${weather.tempC}°C / ${weather.tempF}°F',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        weather.weather,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _buildWeatherInfo(
                  '💨 Wind',
                  '${weather.windKph} km/h ${weather.windDir}',
                ),
                _buildWeatherInfo('💧 Humidity', '${weather.humidity}%'),
                _buildWeatherInfo('☁️ Cloud', '${weather.cloud}%'),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildWeatherInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  // Tab Selector - Squad vs Scorecard
  Widget _buildTabSelector(NewMatchDetailController controller) {
    return Obx(() {
      return Container(
        margin: const EdgeInsets.only(top: 12),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => controller.switchTab(0),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: controller.selectedTab.value == 0
                            ? const Color(0xFF6B7FFF)
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                  child: Text(
                    'Squad',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: controller.selectedTab.value == 0
                          ? const Color(0xFF6B7FFF)
                          : Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => controller.switchTab(1),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: controller.selectedTab.value == 1
                            ? const Color(0xFF6B7FFF)
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                  child: Text(
                    'Scorecard',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: controller.selectedTab.value == 1
                          ? const Color(0xFF6B7FFF)
                          : Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // Tab Content - Shows either Squad or Scorecard
  Widget _buildTabContent(NewMatchDetailController controller) {
    return Obx(() {
      if (controller.selectedTab.value == 0) {
        return Column(
          children: [_buildTeamTabs(controller), _buildPlayersList(controller)],
        );
      } else {
        return _buildScorecardContent(controller);
      }
    });
  }

  // Scorecard Content
  Widget _buildScorecardContent(NewMatchDetailController controller) {
    return Obx(() {
      if (controller.isScorecardLoading.value) {
        return const Padding(
          padding: EdgeInsets.all(40),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      final scorecard = controller.scorecard.value;
      if (scorecard == null || scorecard.scorecard.isEmpty) {
        return Padding(
          padding: const EdgeInsets.all(40),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.sports_cricket,
                  size: 60,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  'Scorecard not available',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        );
      }

      return Column(
        children: scorecard.scorecard.entries.map((entry) {
          return _buildInningsCard(entry.key, entry.value as InningsData);
        }).toList(),
      );
    });
  }

  // Innings Card - Shows complete innings data
  Widget _buildInningsCard(String inningsKey, InningsData innings) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Team Score Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF6B7FFF).withOpacity(0.1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        innings.team.shortName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Innings ${innings.team.inning}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${innings.team.score}/${innings.team.wicket}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Overs: ${innings.team.over}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Batting Section
          _buildBattingSection(innings),

          // Bowling Section
          _buildBowlingSection(innings),

          // Fall of Wickets
          if (innings.fallWicket.isNotEmpty) _buildFallOfWickets(innings),

          // Partnerships
          if (innings.partnership.isNotEmpty) _buildPartnerships(innings),

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // Batting Section
  Widget _buildBattingSection(InningsData innings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: const Text(
            'Batting',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(color: Colors.grey.shade100),
          child: const Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Batsman',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: Text(
                  'R',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  'B',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  '4s',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  '6s',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  'SR',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        ...innings.batsman.map((batsman) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            batsman.name,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (batsman.outBy.isNotEmpty)
                            Text(
                              batsman.outBy,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${batsman.run}',
                        style: const TextStyle(fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${batsman.ball}',
                        style: const TextStyle(fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${batsman.fours}',
                        style: const TextStyle(fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${batsman.sixes}',
                        style: const TextStyle(fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        batsman.strikeRate,
                        style: const TextStyle(fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
        Container(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Extras: ${innings.team.extras}',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
        ),
      ],
    );
  }

  // Bowling Section
  Widget _buildBowlingSection(InningsData innings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: const Text(
            'Bowling',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(color: Colors.grey.shade100),
          child: const Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Bowler',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: Text(
                  'O',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  'M',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  'R',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  'W',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  'Econ',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        ...innings.bowler.map((bowler) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    bowler.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    bowler.over,
                    style: const TextStyle(fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    '${bowler.maiden}',
                    style: const TextStyle(fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    '${bowler.run}',
                    style: const TextStyle(fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    '${bowler.wicket}',
                    style: const TextStyle(fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    bowler.economy,
                    style: const TextStyle(fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  // Fall of Wickets Section
  Widget _buildFallOfWickets(InningsData innings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: const Text(
            'Fall of Wickets',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 12,
            runSpacing: 8,
            children: innings.fallWicket.map((fow) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${fow.score}-${fow.wicket} (${fow.player}, ${fow.over})',
                  style: TextStyle(fontSize: 12, color: Colors.red.shade900),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  // Partnerships Section
  Widget _buildPartnerships(InningsData innings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: const Text(
            'Partnerships',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        ...innings.partnership.map((partnership) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        partnership.playersName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      '${partnership.run} (${partnership.ball})',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.green.shade900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${partnership.playerAName}: ${partnership.playerARun} (${partnership.playerABall})',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${partnership.playerBName}: ${partnership.playerBRun} (${partnership.playerBBall})',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade700,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildTeamTabs(NewMatchDetailController controller) {
    return Obx(() {
      final match = controller.matchDetail.value;
      if (match == null) return const SizedBox.shrink();

      return Container(
        margin: const EdgeInsets.only(top: 12),
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => controller.switchTeam('team_a'),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: controller.selectedTeam.value == 'team_a'
                        ? const Color(0xFF6B7FFF)
                        : Colors.transparent,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                    border: Border.all(
                      color: controller.selectedTeam.value == 'team_a'
                          ? const Color(0xFF6B7FFF)
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      match.teamAShort,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: controller.selectedTeam.value == 'team_a'
                            ? Colors.white
                            : Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => controller.switchTeam('team_b'),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: controller.selectedTeam.value == 'team_b'
                        ? const Color(0xFF6B7FFF)
                        : Colors.transparent,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    border: Border.all(
                      color: controller.selectedTeam.value == 'team_b'
                          ? const Color(0xFF6B7FFF)
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      match.teamBShort,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: controller.selectedTeam.value == 'team_b'
                            ? Colors.white
                            : Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPlayersList(NewMatchDetailController controller) {
    return Obx(() {
      final players = controller.currentTeamPlayers;

      return Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '${controller.currentTeamName} Squad',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade200),
                  bottom: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: const Row(
                children: [
                  Expanded(
                    child: Text(
                      'Player',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    'Role',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            if (players.isEmpty)
              Padding(
                padding: const EdgeInsets.all(40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 60,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No players available',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...players
                  .map(
                    (player) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade100),
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: CachedNetworkImageProvider(
                              player.image,
                            ),
                            onBackgroundImageError: (exception, stackTrace) {},
                            child: player.image.contains('ui-avatars.com')
                                ? null
                                : const CircleAvatar(),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              player.name,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              player.playRole,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
          ],
        ),
      );
    });
  }

  Widget _buildErrorState(NewMatchDetailController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Failed to load match details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage.value,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: controller.retry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
