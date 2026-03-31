// new_schedule_detail_view.dart - Complete Schedule Detail View

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../controller/Cricket/schedule_detail_controller.dart';

class NewScheduleDetailView extends StatelessWidget {
  final String matchId;

  const NewScheduleDetailView({super.key, required this.matchId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      NewScheduleDetailController(matchId: matchId),
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
              if (controller.matchDetail.value?.venueWeather != null)
                _buildWeatherCard(controller),
              _buildTeamTabs(controller),
              _buildPlayersList(controller),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar(NewScheduleDetailController controller) {
    return AppBar(
      backgroundColor: const Color(0xFF5DADE2),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      title: Obx(() {
        final match = controller.matchDetail.value;
        if (match == null) {
          return const Text(
            'Loading...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          );
        }
        return Text(
          '${match.teamAShort} vs ${match.teamBShort}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        );
      }),
    );
  }

  Widget _buildMatchHeader(NewScheduleDetailController controller) {
    return Obx(() {
      final match = controller.matchDetail.value;
      if (match == null) return const SizedBox.shrink();

      return Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              match.series,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const Text(
                        'VS',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          match.matchTime,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade700,
                          ),
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

  Widget _buildMatchInfo(NewScheduleDetailController controller) {
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
            if (match.umpire.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildInfoRow(Icons.person, 'Umpires: ${match.umpire}'),
            ],
            if (match.thirdUmpire.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.person_outline,
                'Third Umpire: ${match.thirdUmpire}',
              ),
            ],
            if (match.referee.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildInfoRow(Icons.account_circle, 'Referee: ${match.referee}'),
            ],
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
        ),
      );
    });
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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

  Widget _buildWeatherCard(NewScheduleDetailController controller) {
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

  Widget _buildTeamTabs(NewScheduleDetailController controller) {
    // Removed tabs - showing both teams now
    return const SizedBox.shrink();
  }

  Widget _buildPlayersList(NewScheduleDetailController controller) {
    return Obx(() {
      final match = controller.matchDetail.value;
      final teamAPlayers = controller.teamAPlayers;
      final teamBPlayers = controller.teamBPlayers;

      return Column(
        children: [
          // Team A Squad
          Container(
            margin: const EdgeInsets.only(top: 12),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (match != null)
                        CachedNetworkImage(
                          imageUrl: match.teamAImg,
                          width: 30,
                          height: 30,
                          errorWidget: (context, url, error) => Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          match?.teamA ?? 'Team A',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${teamAPlayers.length} Players',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Player',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Text(
                        'Role',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                if (teamAPlayers.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Text(
                        'No players available',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  )
                else
                  ...teamAPlayers
                      .map(
                        (player) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey.shade100),
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundImage: CachedNetworkImageProvider(
                                  player.image,
                                ),
                                onBackgroundImageError:
                                    (exception, stackTrace) {},
                                backgroundColor: Colors.grey.shade200,
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
          ),

          // Team B Squad
          Container(
            margin: const EdgeInsets.only(top: 16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (match != null)
                        CachedNetworkImage(
                          imageUrl: match.teamBImg,
                          width: 30,
                          height: 30,
                          errorWidget: (context, url, error) => Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          match?.teamB ?? 'Team B',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${teamBPlayers.length} Players',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.green.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Player',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Text(
                        'Role',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                if (teamBPlayers.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Text(
                        'No players available',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  )
                else
                  ...teamBPlayers
                      .map(
                        (player) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey.shade100),
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundImage: CachedNetworkImageProvider(
                                  player.image,
                                ),
                                onBackgroundImageError:
                                    (exception, stackTrace) {},
                                backgroundColor: Colors.grey.shade200,
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
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  player.playRole,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.green.shade700,
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
          ),
        ],
      );
    });
  }

  Widget _buildErrorState(NewScheduleDetailController controller) {
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
