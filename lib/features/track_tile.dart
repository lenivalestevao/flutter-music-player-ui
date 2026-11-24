import 'package:flutter/material.dart';

import '../core/scope.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import '../data/models.dart';

class TrackTile extends StatelessWidget {
  const TrackTile({
    super.key,
    required this.track,
    required this.onTap,
    this.index,
  });

  final Track track;
  final VoidCallback onTap;

  /// When set, shows a position number instead of the cover (playlist view).
  final int? index;

  @override
  Widget build(BuildContext context) {
    final player = PlayerScope.of(context);
    final isCurrent = player.current?.id == track.id;
    final liked = player.isLiked(track.id);

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: index == null
          ? CoverArt(colors: track.colors, size: 48)
          : SizedBox(
              width: 28,
              child: Center(
                child: isCurrent && player.isPlaying
                    ? const Icon(Icons.equalizer_rounded,
                        color: AppColors.accent)
                    : Text(
                        '${index! + 1}',
                        style: TextStyle(
                          color: isCurrent
                              ? AppColors.accent
                              : AppColors.muted,
                        ),
                      ),
              ),
            ),
      title: Text(
        track.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isCurrent ? AppColors.accent : null,
        ),
      ),
      subtitle: Row(
        children: [
          if (track.explicit)
            Container(
              margin: const EdgeInsets.only(right: 6),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: AppColors.muted,
                borderRadius: BorderRadius.circular(3),
              ),
              child: const Text(
                'E',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
            ),
          Flexible(
            child: Text(
              track.artist,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.muted),
            ),
          ),
        ],
      ),
      trailing: PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert_rounded, color: AppColors.muted),
        onSelected: (value) {
          final messenger = ScaffoldMessenger.of(context);
          switch (value) {
            case 'next':
              player.playNext(track);
              messenger.showSnackBar(
                const SnackBar(content: Text('Will play next')),
              );
            case 'queue':
              player.addToQueue(track);
              messenger.showSnackBar(
                const SnackBar(content: Text('Added to queue')),
              );
            case 'like':
              player.toggleLike(track.id);
          }
        },
        itemBuilder: (_) => [
          const PopupMenuItem<String>(value: 'next', child: Text('Play next')),
          const PopupMenuItem<String>(
            value: 'queue',
            child: Text('Add to queue'),
          ),
          PopupMenuItem<String>(
            value: 'like',
            child: Text(
              liked ? 'Remove from Liked Songs' : 'Add to Liked Songs',
            ),
          ),
        ],
      ),
    );
  }
}
