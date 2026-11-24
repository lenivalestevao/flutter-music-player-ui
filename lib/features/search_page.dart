import 'package:flutter/material.dart';

import '../core/scope.dart';
import '../core/theme.dart';
import '../data/models.dart';
import '../data/seed.dart';
import 'track_tile.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setQuery(String value) {
    _controller.text = value;
    _controller.selection = TextSelection.collapsed(offset: value.length);
    setState(() => _query = value);
  }

  List<Track> get _results {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return const [];
    return seedTracks
        .where((t) =>
            t.title.toLowerCase().contains(q) ||
            t.artist.toLowerCase().contains(q) ||
            t.album.toLowerCase().contains(q) ||
            t.genre.toLowerCase() == q)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final player = PlayerScope.of(context);
    final results = _results;
    final searching = _query.trim().isNotEmpty;

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Text(
              'Search',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _controller,
              onChanged: (v) => setState(() => _query = v),
              style: const TextStyle(color: Colors.black),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: 'What do you want to listen to?',
                hintStyle: const TextStyle(color: Color(0xFF55606B)),
                prefixIcon: const Icon(Icons.search_rounded, color: Colors.black),
                suffixIcon: searching
                    ? IconButton(
                        onPressed: () => _setQuery(''),
                        icon: const Icon(Icons.close_rounded,
                            color: Colors.black),
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: searching
                ? (results.isEmpty
                    ? Center(
                        child: Text(
                          'No results for "$_query"',
                          style: const TextStyle(color: AppColors.muted),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 8, bottom: 24),
                        itemCount: results.length,
                        itemBuilder: (_, i) => TrackTile(
                          track: results[i],
                          onTap: () => player.playQueue(
                            results,
                            start: i,
                            source: 'Search',
                          ),
                        ),
                      ))
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                    children: [
                      const Text(
                        'Browse all',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.7,
                        children: [
                          for (final g in seedGenres)
                            GestureDetector(
                              onTap: () => _setQuery(g.name),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: g.color,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Stack(
                                  children: [
                                    Text(
                                      g.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Positioned(
                                      right: -6,
                                      bottom: -6,
                                      child: Transform.rotate(
                                        angle: 0.4,
                                        child: Icon(
                                          g.icon,
                                          size: 56,
                                          color: Colors.white
                                              .withValues(alpha: 0.35),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
