import 'package:flutter/material.dart';

import '../core/scope.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import '../data/seed.dart';
import 'playlist_page.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final player = PlayerScope.of(context);
    final likedCount = player.likedIds.length;

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Your Library',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Playlists'),
                  selected: _tab == 0,
                  onSelected: (_) => setState(() => _tab = 0),
                ),
                ChoiceChip(
                  label: const Text('Artists'),
                  selected: _tab == 1,
                  onSelected: (_) => setState(() => _tab = 1),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: _tab == 0
                  ? [
                      ListTile(
                        onTap: () => openLikedSongs(context),
                        leading: const CoverArt(
                          colors: [Color(0xFF4F46E5), Color(0xFF2EE6A6)],
                          size: 56,
                          icon: Icons.favorite_rounded,
                        ),
                        title: const Text(
                          'Liked Songs',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(
                          'Playlist · $likedCount songs',
                          style: const TextStyle(color: AppColors.muted),
                        ),
                      ),
                      for (final p in seedPlaylists)
                        ListTile(
                          onTap: () => openPlaylist(context, p),
                          leading: CoverArt(colors: p.colors, size: 56),
                          title: Text(
                            p.name,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                            'Playlist · ${p.tracks.length} songs',
                            style: const TextStyle(color: AppColors.muted),
                          ),
                        ),
                    ]
                  : [
                      for (final a in seedArtists)
                        ListTile(
                          leading: CoverArt(
                            colors: a.colors,
                            size: 56,
                            radius: 28,
                            icon: Icons.person_rounded,
                          ),
                          title: Text(
                            a.name,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                            '${a.genre} · ${a.listeners}',
                            style: const TextStyle(color: AppColors.muted),
                          ),
                        ),
                    ],
            ),
          ),
        ],
      ),
    );
  }
}
