import 'dart:math';

import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/scope.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import '../player/player_controller.dart';
import 'queue_sheet.dart';

void openNowPlaying(BuildContext context) {
  Navigator.of(context).push(
    PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 320),
      pageBuilder: (_, __, ___) => const NowPlayingPage(),
      transitionsBuilder: (_, animation, __, child) => SlideTransition(
        position: Tween(begin: const Offset(0, 1), end: Offset.zero).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        ),
        child: child,
      ),
    ),
  );
}

class NowPlayingPage extends StatelessWidget {
  const NowPlayingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final player = PlayerScope.of(context);
    final track = player.current;
    if (track == null) return const Scaffold();

    final totalMs = max(1, track.duration.inMilliseconds);
    final posMs = player.position.inMilliseconds.clamp(0, totalMs);

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              track.colors.first.withValues(alpha: 0.85),
              AppColors.bg,
            ],
            stops: const [0, 0.75],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded,
                          size: 32),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            'PLAYING FROM',
                            style: TextStyle(
                              fontSize: 11,
                              letterSpacing: 1.2,
                              color: AppColors.muted,
                            ),
                          ),
                          Text(
                            player.source ?? track.album,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: LayoutBuilder(
                        builder: (_, box) => CoverArt(
                          colors: track.colors,
                          size: box.maxWidth,
                          radius: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            track.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            track.artist,
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => player.toggleLike(track.id),
                      icon: Icon(
                        player.isLiked(track.id)
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 28,
                        color: player.isLiked(track.id)
                            ? AppColors.accent
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: posMs.toDouble(),
                  max: totalMs.toDouble(),
                  onChanged: (v) => player.seek(Duration(milliseconds: v.round())),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(fmtTime(player.position),
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.muted)),
                    Text(fmtTime(track.duration),
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.muted)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: player.toggleShuffle,
                      icon: Icon(
                        Icons.shuffle_rounded,
                        color: player.shuffle ? AppColors.accent : Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: player.previous,
                      iconSize: 36,
                      icon: const Icon(Icons.skip_previous_rounded),
                    ),
                    IconButton.filled(
                      onPressed: player.togglePlay,
                      iconSize: 38,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        minimumSize: const Size(68, 68),
                      ),
                      icon: Icon(
                        player.isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                      ),
                    ),
                    IconButton(
                      onPressed: player.next,
                      iconSize: 36,
                      icon: const Icon(Icons.skip_next_rounded),
                    ),
                    IconButton(
                      onPressed: player.cycleRepeat,
                      icon: Icon(
                        player.repeat == RepeatMode.one
                            ? Icons.repeat_one_rounded
                            : Icons.repeat_rounded,
                        color: player.repeat == RepeatMode.off
                            ? Colors.white
                            : AppColors.accent,
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () => showQueueSheet(context),
                    icon: const Icon(Icons.queue_music_rounded),
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
