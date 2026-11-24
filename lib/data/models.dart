import 'package:flutter/material.dart';

class Track {
  const Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.genre,
    required this.duration,
    required this.colors,
    this.explicit = false,
  });

  final String id;
  final String title;
  final String artist;
  final String album;
  final String genre;
  final Duration duration;
  final List<Color> colors;
  final bool explicit;
}

class Playlist {
  const Playlist({
    required this.id,
    required this.name,
    required this.description,
    required this.tracks,
    required this.colors,
  });

  final String id;
  final String name;
  final String description;
  final List<Track> tracks;
  final List<Color> colors;

  Duration get duration =>
      tracks.fold(Duration.zero, (sum, t) => sum + t.duration);
}

class Artist {
  const Artist({
    required this.name,
    required this.genre,
    required this.listeners,
    required this.colors,
  });

  final String name;
  final String genre;
  final String listeners;
  final List<Color> colors;
}

class Genre {
  const Genre(this.name, this.color, this.icon);

  final String name;
  final Color color;
  final IconData icon;
}
