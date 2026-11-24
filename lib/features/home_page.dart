import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/scope.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import '../data/models.dart';
import '../data/seed.dart';
import 'playlist_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final player = PlayerScope.of(context);
    final quick = seedPlaylists.take(6).toList();
    final recent = seedTracks.reversed.take(8).toList();

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Text(
              greeting(DateTime.now()),
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                mainAxisExtent: 42,
              ),
              children: [
                for (final p in quick)
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => openPlaylist(context, p),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.card2,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          CoverArt(colors: p.colors, size: 42, radius: 6),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              p.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SectionTitle('Made for you'),
          SizedBox(
            height: 190,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: seedPlaylists.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (_, i) {
                final p = seedPlaylists[i];
                return _Card(
                  colors: p.colors,
                  title: p.name,
                  subtitle: p.description,
                  onTap: () => openPlaylist(context, p),
                );
              },
            ),
          ),
          const SectionTitle('Recently played'),
          SizedBox(
            height: 190,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: recent.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (_, i) {
                final t = recent[i];
                return _Card(
                  colors: t.colors,
                  title: t.title,
                  subtitle: t.artist,
                  onTap: () => player.playQueue(recent, start: i,
                      source: 'Recently played'),
                );
              },
            ),
          ),
          const SectionTitle('Popular artists'),
          SizedBox(
            height: 150,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: seedArtists.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (_, i) => _ArtistBubble(artist: seedArtists[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({
    required this.colors,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final List<Color> colors;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CoverArt(colors: colors, size: 140, radius: 10),
            const SizedBox(height: 8),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.muted, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArtistBubble extends StatelessWidget {
  const _ArtistBubble({required this.artist});

  final Artist artist;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Column(
        children: [
          CoverArt(
            colors: artist.colors,
            size: 100,
            radius: 50,
            icon: Icons.person_rounded,
          ),
          const SizedBox(height: 8),
          Text(
            artist.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
