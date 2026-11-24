import 'package:flutter/material.dart';

import '../core/scope.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import 'now_playing_page.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final player = PlayerScope.of(context);
    final track = player.current;
    if (track == null) return const SizedBox.shrink();

    final total = track.duration.inMilliseconds;
    final progress =
        total == 0 ? 0.0 : player.position.inMilliseconds / total;

    return GestureDetector(
      onTap: () => openNowPlaying(context),
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 6),
        decoration: BoxDecoration(
          color: Color.alphaBlend(
            track.colors.first.withValues(alpha: 0.35),
            AppColors.card,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 4, 0),
              child: Row(
                children: [
                  CoverArt(colors: track.colors, size: 44),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          track.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          track.artist,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 12,
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
                      color: player.isLiked(track.id)
                          ? AppColors.accent
                          : Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: player.togglePlay,
                    icon: Icon(
                      player.isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 6),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  minHeight: 2,
                  backgroundColor: Colors.white24,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
