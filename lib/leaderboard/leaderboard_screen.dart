import 'dart:ui';

import 'package:endless_runner/gen/assets.gen.dart';
import 'package:endless_runner/leaderboard/persistence/cloud_leaderboard_persistence.dart';
import 'package:endless_runner/leaderboard/persistence/leaderboard_persistence.dart';
import 'package:endless_runner/settings/settings.dart';
import 'package:endless_runner/style/responsive_screen.dart';
import 'package:endless_runner/style/screen_background.dart';
import 'package:endless_runner/style/text_banner.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../achievements/achievement.dart';
import '../style/gaps.dart';
import '../style/wobbly_button.dart';
import 'leaderboard_entry.dart';

class LeaderboardScreen extends StatelessWidget {
  LeaderboardScreen({super.key, LeaderboardPersistence? leaderboardPersistence})
      : _leaderboardPersistence =
            leaderboardPersistence ?? CloudLeaderboardPersistence();

  final LeaderboardPersistence _leaderboardPersistence;

  @override
  Widget build(BuildContext context) {
    final String userId = context.read<SettingsController>().userId ?? '';

    return Material(
      child: ScreenBackground(
        child: ResponsiveScreen(
          topMessageAreaBuilder: (context, isPortrait) => TextBanner(
            title: 'Leaderboard',
            isParentPortrait: isPortrait,
          ),
          squarishMainAreaBuilder: (context, isPortrait) => ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: FutureBuilder(
              future: _leaderboardPersistence.getLeaderboard(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done ||
                    snapshot.data == null) {
                  return const Center(
                      child: Text('Loading...',
                          style: TextStyle(color: Colors.white)));
                }

                return ListView.separated(
                    itemBuilder: (context, index) {
                      final entry = snapshot.data![index];
                      final isUser = entry.userId == userId;
                      return _buildEntry(context, entry, index, isUser);
                    },
                    separatorBuilder: (context, index) => Gaps.verticalS,
                    itemCount: snapshot.data!.length);
              },
            ),
          ),
          rectangularMenuArea: WobblyButton(
            onPressed: () {
              GoRouter.of(context).go('/');
            },
            child: const Text('Back'),
          ),
        ),
      ),
    );
  }

  Widget _buildEntry(
      BuildContext context, LeaderboardEntry entry, int index, bool isUser) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text('${index + 1}. ',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: Colors.white)),
          if (isUser)
            Text('YOU: ',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.white)),
          Text(entry.name,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: Colors.white)),
          Text(' ${entry.overallScore} ',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.white)),
          _buildAchievements(entry.achievements),
        ],
      ),
    );
  }

  Widget _buildAchievements(List<AchievementType> types) {
    if (types.isEmpty) {
      return const ExcludeSemantics(child: SizedBox.shrink());
    }

    List<String> semanticallyLabeledAchievements = [];
    for (final achievement in types) {
      semanticallyLabeledAchievements.add(achievement.title);
    }

    return Semantics(
      label: 'Achievement cards: ${semanticallyLabeledAchievements.join(', ')}',
      child: ExcludeSemantics(
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            for (final achievement in types)
              Container(
                margin: const EdgeInsets.only(right: 4),
                height: 32,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: image(achievement).image(
                  height: double.infinity,
                  filterQuality: FilterQuality.none,
                ),
              ),
          ],
        ),
      ),
    );
  }

  AssetGenImage image(AchievementType type) {
    return switch (type) {
      AchievementType.whaleBuddy => Assets.images.whaleBuddy,
      AchievementType.oceanGuardian => Assets.images.oceanGuardian,
      AchievementType.recyclingHero => Assets.images.recyclingHero,
      AchievementType.ecoWarrior => Assets.images.ecoWarrior,
      AchievementType.ultimateChampion => Assets.images.ultimateChampion,
    };
  }
}
