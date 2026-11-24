import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/scope.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import '../data/models.dart';
import '../data/seed.dart';
import 'mini_player.dart';
import 'track_tile.dart';

void openPlaylist(BuildContext context, Playlist playlist) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => PlaylistPage(playlist: playlist)),
  );
}

void openLikedSongs(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => const PlaylistPage(
        liked: true,
        playlist: Playlist(
          id: 'liked',
          name: 'Liked Songs',
          description: 'Songs you hearted',
          tracks: [],
          colors: [Color(0xFF4F46E5), Color(0xFF2EE6A6)],
        ),
      ),
    ),
  );
}

class PlaylistPage extends StatelessWidget {
  const PlaylistPage({super.key, required this.playlist, this.liked = false});

  final Playlist playlist;

  /// When true, the track list follows the player's liked songs.
  final bool liked;

  @override
  Widget build(BuildContext context) {
    final player = PlayerScope.of(context);
    final tracks = liked
        ? seedTracks.where((t) => player.isLiked(t.id)).toList()
        : playlist.tracks;
    final total = tracks.fold(Duration.zero, (sum, t) => sum + t.duration);

    return Scaffold(
      bottomNavigationBar: const MiniPlayer(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    playlist.colors.first.withValues(alpha: 0.8),
                    AppColors.bg,
                  ],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_rounded),
                      ),
                    ),
                    CoverArt(colors: playlist.colors, size: 180, radius: 12),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            playlist.name,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            playlist.description,
                            style: const TextStyle(color: AppColors.muted),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${tracks.length} songs · ${fmtTotal(total)}',
                            style: const TextStyle(
                              color: AppColors.muted,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (!player.shuffle) player.toggleShuffle();
                                  player.playQueue(tracks,
                                      source: playlist.name);
                                },
                                icon: Icon(
                                  Icons.shuffle_rounded,
                                  color: player.shuffle
                                      ? AppColors.accent
                                      : Colors.white,
                                ),
                              ),
                              const Spacer(),
                              IconButton.filled(
                                onPressed: tracks.isEmpty
                                    ? null
                                    : () {
                                        if (player.shuffle) {
                                          player.toggleShuffle();
                                        }
                                        player.playQueue(tracks,
                                            source: playlist.name);
                                      },
                                iconSize: 32,
                                style: IconButton.styleFrom(
                                  backgroundColor: AppColors.accent,
                                  foregroundColor: Colors.black,
                                  minimumSize: const Size(56, 56),
                                ),
                                icon: const Icon(Icons.play_arrow_rounded),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (tracks.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    'Heart a song to see it here.',
                    style: TextStyle(color: AppColors.muted),
                  ),
                ),
              ),
            ),
          SliverList.builder(
            itemCount: tracks.length,
            itemBuilder: (_, i) => TrackTile(
              track: tracks[i],
              index: i,
              onTap: () => player.playQueue(
                tracks,
                start: i,
                source: playlist.name,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }
}
