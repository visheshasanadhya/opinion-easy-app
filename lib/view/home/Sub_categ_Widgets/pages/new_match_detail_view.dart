// new_match_detail_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../controller/Cricket/match_detail_controller.dart';
import '../../../../data/model/scorecard_model.dart';

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

        return Column(
          children: [
            _buildMatchHeader(controller),
            _buildTabBar(controller),
            Expanded(
              child: TabBarView(
                //controller: controller.tabController,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMatchInfo(controller),
                        _buildWeatherCard(controller),
                        _buildTeamTabs(controller),
                        _buildPlayersList(controller),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  _buildScorecardView(controller),
                ],
              ),
            ),
          ],
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

  Widget _buildTabBar(NewMatchDetailController controller) {
    return Container(
      color: Colors.white,
      child: TabBar(
        //controller: controller.tabController,
        labelColor: const Color(0xFF5DADE2),
        unselectedLabelColor: Colors.grey,
        indicatorColor: const Color(0xFF5DADE2),
        tabs: const [
          Tab(text: "Scorecard"),
          Tab(text: "Info"),
        ],
        onTap: (index) {
          if (index == 1 && controller.scorecard.value == null) {
            controller.fetchScorecard();
          }
        },
      ),
    );
  }

  Widget _buildScorecardView(NewMatchDetailController controller) {
    return Obx(() {
      if (controller.isScorecardLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final scorecard = controller.scorecard.value;
      if (scorecard == null) {
        return const Center(child: Text("Scorecard not available"));
      }

      // Convert the map to a list to iterate
      final inningsList = scorecard.scorecard.entries.toList();

      return ListView.builder(
        itemCount: inningsList.length,
        itemBuilder: (context, index) {
          final entry = inningsList[index];
          final inningsData = entry.value;
          final teamName = inningsData.team.name;
          final score = inningsData.team.score;
          final wickets = inningsData.team.wicket;
          final overs = inningsData.team.over;

          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ExpansionTile(
              title: Text(
                "$teamName - $score/$wickets ($overs)",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              children: [
                _buildBattingTable(inningsData.batsman),
                _buildBowlingTable(inningsData.bowler),
                _buildFallOfWickets(inningsData.fallWicket),
                _buildPartnerships(inningsData.partnership),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _buildBattingTable(List<BatsmanScore> batsmanList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          color: Colors.grey.shade200,
          child: const Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  "Batter",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Text(
                  "R",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  "B",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  "4s",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  "6s",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  "SR",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        ...batsmanList.map((batsman) {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 12.0,
            ),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        batsman.name,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        batsman.outBy,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Text("${batsman.run}", textAlign: TextAlign.center),
                ),
                Expanded(
                  child: Text("${batsman.ball}", textAlign: TextAlign.center),
                ),
                Expanded(
                  child: Text("${batsman.fours}", textAlign: TextAlign.center),
                ),
                Expanded(
                  child: Text("${batsman.sixes}", textAlign: TextAlign.center),
                ),
                Expanded(
                  child: Text(batsman.strikeRate, textAlign: TextAlign.center),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildBowlingTable(List<BowlerScore> bowlerList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(8.0),
          color: Colors.grey.shade200,
          child: const Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  "Bowler",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Text(
                  "O",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  "M",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  "R",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  "W",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  "Eco",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        ...bowlerList.map((bowler) {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 12.0,
            ),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    bowler.name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Expanded(child: Text(bowler.over, textAlign: TextAlign.center)),
                Expanded(
                  child: Text("${bowler.maiden}", textAlign: TextAlign.center),
                ),
                Expanded(
                  child: Text("${bowler.run}", textAlign: TextAlign.center),
                ),
                Expanded(
                  child: Text("${bowler.wicket}", textAlign: TextAlign.center),
                ),
                Expanded(
                  child: Text(bowler.economy, textAlign: TextAlign.center),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildFallOfWickets(List<FallOfWicket> fallWicketList) {
    if (fallWicketList.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "Fall of Wickets",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Wrap(
            spacing: 8.0,
            children: fallWicketList.map((fow) {
              return Chip(
                label: Text(
                  "${fow.score}-${fow.wicket} (${fow.player}, ${fow.over})",
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPartnerships(List<Partnership> partnershipList) {
    if (partnershipList.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "Partnerships",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ...partnershipList.map((partnership) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${partnership.playerAName} & ${partnership.playerBName}",
                  ),
                  Text("${partnership.run} (${partnership.ball})"),
                ],
              ),
            );
          }),
        ],
      ),
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
                // Team A
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

                // VS
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

                // Team B
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
