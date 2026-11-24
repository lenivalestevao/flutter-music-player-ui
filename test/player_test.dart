import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:waveline_music/data/seed.dart';
import 'package:waveline_music/player/player_controller.dart';

PlayerController _player() =>
    PlayerController(autoTick: false, random: Random(1));

void main() {
  final tracks = seedTracks.take(4).toList();

  test('playQueue starts the chosen track', () {
    final p = _player()..playQueue(tracks, start: 2);
    expect(p.current, tracks[2]);
    expect(p.isPlaying, isTrue);
    expect(p.position, Duration.zero);
  });

  test('advance moves position and goes to the next track at the end', () {
    final p = _player()..playQueue(tracks);
    p.advance(const Duration(seconds: 10));
    expect(p.position, const Duration(seconds: 10));
    p.advance(tracks[0].duration);
    expect(p.current, tracks[1]);
    expect(p.position, Duration.zero);
  });

  test('repeat one loops the same track', () {
    final p = _player()..playQueue(tracks);
    p.cycleRepeat(); // all
    p.cycleRepeat(); // one
    expect(p.repeat, RepeatMode.one);
    p.advance(tracks[0].duration);
    expect(p.current, tracks[0]);
    expect(p.isPlaying, isTrue);
  });

  test('stops at the end of the queue when repeat is off', () {
    final p = _player()..playQueue(tracks, start: 3);
    p.advance(tracks[3].duration);
    expect(p.isPlaying, isFalse);
    expect(p.current, tracks[3]);
  });

  test('repeat all wraps to the first track', () {
    final p = _player()..playQueue(tracks, start: 3);
    p.cycleRepeat();
    p.advance(tracks[3].duration);
    expect(p.current, tracks[0]);
  });

  test('previous restarts the track after 3 seconds, else goes back', () {
    final p = _player()..playQueue(tracks, start: 1);
    p.advance(const Duration(seconds: 5));
    p.previous();
    expect(p.current, tracks[1]);
    expect(p.position, Duration.zero);
    p.previous();
    expect(p.current, tracks[0]);
  });

  test('seek is clamped to the track length', () {
    final p = _player()..playQueue(tracks);
    p.seek(const Duration(hours: 1));
    expect(p.position, tracks[0].duration);
    p.seek(const Duration(seconds: -5));
    expect(p.position, Duration.zero);
  });

  test('shuffle keeps the current track first and the same songs', () {
    final p = _player()..playQueue(tracks, start: 2);
    p.toggleShuffle();
    expect(p.current, tracks[2]);
    expect(p.queue.toSet(), tracks.toSet());
    p.toggleShuffle();
    expect(p.queue, tracks);
    expect(p.current, tracks[2]);
  });

  test('queue editing', () {
    final p = _player()..playQueue(tracks.take(2).toList());
    p.addToQueue(tracks[3]);
    expect(p.upNext, [tracks[1], tracks[3]]);
    p.playNext(tracks[2]);
    expect(p.upNext.first, tracks[2]);
    p.removeFromQueue(p.index + 1);
    expect(p.upNext, [tracks[1], tracks[3]]);
    p.removeFromQueue(p.index); // the playing track cannot be removed
    expect(p.current, tracks[0]);
  });

  test('toggleLike adds and removes', () {
    final p = _player();
    final id = seedTracks.last.id;
    expect(p.isLiked(id), isFalse);
    p.toggleLike(id);
    expect(p.isLiked(id), isTrue);
    p.toggleLike(id);
    expect(p.isLiked(id), isFalse);
  });
}
