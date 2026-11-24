import 'package:flutter/material.dart';

import 'models.dart';

// All artists, albums and tracks below are fictional demo data.

Track _t(
  String id,
  String title,
  String artist,
  String album,
  String genre,
  int seconds,
  int c1,
  int c2, {
  bool explicit = false,
}) {
  return Track(
    id: id,
    title: title,
    artist: artist,
    album: album,
    genre: genre,
    duration: Duration(seconds: seconds),
    colors: [Color(c1), Color(c2)],
    explicit: explicit,
  );
}

final List<Track> seedTracks = [
  _t('t01', 'Midnight Lanterns', 'Luna Vale', 'Paper Moons', 'Pop', 198, 0xFF7C5CFF, 0xFFEC4899),
  _t('t02', 'Glass Ocean', 'Neon Harbor', 'Tidal', 'Electronic', 224, 0xFF0EA5E9, 0xFF2EE6A6),
  _t('t03', 'Slow Burn City', 'Orbit Kid', 'Night Shift', 'Hip-Hop', 187, 0xFFF59E0B, 0xFFEF4444, explicit: true),
  _t('t04', 'Paper Planes at Dawn', 'Mara Quinn', 'Soft Light', 'Indie', 241, 0xFFFB7185, 0xFFFBBF24),
  _t('t05', 'Afterglow', 'Luna Vale', 'Paper Moons', 'Pop', 205, 0xFFEC4899, 0xFFF97316),
  _t('t06', 'Static Hearts', 'Velvet Static', 'Loud Quiet', 'Rock', 232, 0xFFEF4444, 0xFF7F1D1D),
  _t('t07', 'Low Tide', 'Echo Garden', 'Moss', 'Chill', 256, 0xFF14B8A6, 0xFF0F766E),
  _t('t08', 'Golden Hour Run', 'Kairo', 'Fast Lane', 'Electronic', 176, 0xFFFACC15, 0xFFF97316),
  _t('t09', 'Neon Rain', 'Neon Harbor', 'Tidal', 'Electronic', 213, 0xFF6366F1, 0xFF22D3EE),
  _t('t10', 'Violet Skies', 'Solstice Hill', 'Hilltop', 'Indie', 228, 0xFF8B5CF6, 0xFF3B82F6),
  _t('t11', 'Backroad Radio', 'Atlas & Rue', 'Gravel', 'Rock', 209, 0xFF84CC16, 0xFF166534),
  _t('t12', 'Moonwalk Cafe', 'Nova Reyes', 'Late Brew', 'Jazz', 262, 0xFF334155, 0xFF94A3B8),
  _t('t13', 'Heat Haze', 'Kairo', 'Fast Lane', 'Hip-Hop', 192, 0xFFF43F5E, 0xFFF59E0B, explicit: true),
  _t('t14', 'Winter Letters', 'Mara Quinn', 'Soft Light', 'Chill', 247, 0xFF60A5FA, 0xFFE0F2FE),
  _t('t15', 'Satellite Dreams', 'Echo Garden', 'Moss', 'Focus', 301, 0xFF0F766E, 0xFF1E293B),
  _t('t16', 'Open Windows', 'Solstice Hill', 'Hilltop', 'Focus', 268, 0xFF22C55E, 0xFF0EA5E9),
];

Track trackById(String id) => seedTracks.firstWhere((t) => t.id == id);

List<Track> _pick(List<String> ids) => ids.map(trackById).toList();

final List<Playlist> seedPlaylists = [
  Playlist(
    id: 'p1',
    name: 'Daily Mix 1',
    description: 'Luna Vale, Mara Quinn and more',
    tracks: _pick(['t01', 't04', 't05', 't10', 't14', 't02']),
    colors: const [Color(0xFF7C5CFF), Color(0xFFEC4899)],
  ),
  Playlist(
    id: 'p2',
    name: 'Late Night Drive',
    description: 'Neon lights, empty roads',
    tracks: _pick(['t02', 't09', 't03', 't13', 't06']),
    colors: const [Color(0xFF312E81), Color(0xFF0EA5E9)],
  ),
  Playlist(
    id: 'p3',
    name: 'Focus Flow',
    description: 'Deep work, no lyrics',
    tracks: _pick(['t15', 't16', 't07', 't12']),
    colors: const [Color(0xFF0F766E), Color(0xFF1E293B)],
  ),
  Playlist(
    id: 'p4',
    name: 'Morning Boost',
    description: 'Start the day with energy',
    tracks: _pick(['t08', 't05', 't11', 't01', 't13']),
    colors: const [Color(0xFFF59E0B), Color(0xFFEF4444)],
  ),
  Playlist(
    id: 'p5',
    name: 'Chill Waves',
    description: 'Slow down and breathe',
    tracks: _pick(['t07', 't14', 't12', 't04', 't10']),
    colors: const [Color(0xFF14B8A6), Color(0xFF60A5FA)],
  ),
  Playlist(
    id: 'p6',
    name: 'Workout Pulse',
    description: 'Fast beats to keep you moving',
    tracks: _pick(['t08', 't13', 't03', 't09', 't06', 't11']),
    colors: const [Color(0xFFEF4444), Color(0xFF7F1D1D)],
  ),
];

const List<Artist> seedArtists = [
  Artist(name: 'Luna Vale', genre: 'Pop', listeners: '4.2M listeners', colors: [Color(0xFF7C5CFF), Color(0xFFEC4899)]),
  Artist(name: 'Neon Harbor', genre: 'Electronic', listeners: '2.8M listeners', colors: [Color(0xFF0EA5E9), Color(0xFF2EE6A6)]),
  Artist(name: 'Kairo', genre: 'Hip-Hop', listeners: '3.1M listeners', colors: [Color(0xFFFACC15), Color(0xFFF97316)]),
  Artist(name: 'Mara Quinn', genre: 'Indie', listeners: '1.9M listeners', colors: [Color(0xFFFB7185), Color(0xFFFBBF24)]),
  Artist(name: 'Echo Garden', genre: 'Chill', listeners: '1.2M listeners', colors: [Color(0xFF14B8A6), Color(0xFF0F766E)]),
  Artist(name: 'Solstice Hill', genre: 'Indie', listeners: '980K listeners', colors: [Color(0xFF8B5CF6), Color(0xFF3B82F6)]),
];

const List<Genre> seedGenres = [
  Genre('Pop', Color(0xFFEC4899), Icons.auto_awesome_rounded),
  Genre('Rock', Color(0xFFDC2626), Icons.bolt_rounded),
  Genre('Hip-Hop', Color(0xFFF59E0B), Icons.mic_external_on_rounded),
  Genre('Chill', Color(0xFF14B8A6), Icons.spa_rounded),
  Genre('Electronic', Color(0xFF6366F1), Icons.graphic_eq_rounded),
  Genre('Jazz', Color(0xFF334155), Icons.piano_rounded),
  Genre('Indie', Color(0xFF8B5CF6), Icons.local_florist_rounded),
  Genre('Focus', Color(0xFF0F766E), Icons.center_focus_strong_rounded),
];
