import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../data/models.dart';

enum RepeatMode { off, all, one }

/// Simulated player: a timer advances the position, no audio is played.
/// To play real audio, call your audio package from [play], [pause],
/// [seek] and when the current track changes.
class PlayerController extends ChangeNotifier {
  PlayerController({bool autoTick = true, Random? random})
      : _autoTick = autoTick,
        _rng = random ?? Random();

  static const _tick = Duration(milliseconds: 250);

  final bool _autoTick;
  final Random _rng;

  List<Track> _queue = [];
  List<Track> _original = [];
  int _index = 0;
  bool _playing = false;
  Duration _position = Duration.zero;
  bool _shuffle = false;
  RepeatMode _repeat = RepeatMode.off;
  String? _source;
  final Set<String> _liked = {'t01', 't07'};
  Timer? _timer;

  List<Track> get queue => List.unmodifiable(_queue);
  int get index => _index;
  Track? get current => _queue.isEmpty ? null : _queue[_index];
  List<Track> get upNext =>
      _queue.isEmpty ? const [] : _queue.sublist(_index + 1);
  bool get isPlaying => _playing;
  Duration get position => _position;
  bool get shuffle => _shuffle;
  RepeatMode get repeat => _repeat;
  String? get source => _source;
  bool isLiked(String id) => _liked.contains(id);
  Set<String> get likedIds => Set.unmodifiable(_liked);

  void playQueue(List<Track> tracks, {int start = 0, String? source}) {
    if (tracks.isEmpty) return;
    _original = List.of(tracks);
    _queue = List.of(tracks);
    _index = start.clamp(0, tracks.length - 1);
    if (_shuffle) _applyShuffle();
    _position = Duration.zero;
    _playing = true;
    _source = source;
    _syncTimer();
    notifyListeners();
  }

  void jumpTo(int queueIndex) {
    if (queueIndex < 0 || queueIndex >= _queue.length) return;
    _index = queueIndex;
    _position = Duration.zero;
    _playing = true;
    _syncTimer();
    notifyListeners();
  }

  void play() {
    if (current == null) return;
    _playing = true;
    _syncTimer();
    notifyListeners();
  }

  void pause() {
    _playing = false;
    _syncTimer();
    notifyListeners();
  }

  void togglePlay() => _playing ? pause() : play();

  void next() {
    if (_queue.isEmpty) return;
    if (_index < _queue.length - 1) {
      _index++;
    } else if (_repeat == RepeatMode.all) {
      _index = 0;
    } else {
      _position = Duration.zero;
      _playing = false;
      _syncTimer();
      notifyListeners();
      return;
    }
    _position = Duration.zero;
    notifyListeners();
  }

  void previous() {
    if (_queue.isEmpty) return;
    if (_position > const Duration(seconds: 3) || _index == 0) {
      _position = Duration.zero;
    } else {
      _index--;
      _position = Duration.zero;
    }
    notifyListeners();
  }

  void seek(Duration to) {
    final t = current;
    if (t == null) return;
    _position = to < Duration.zero
        ? Duration.zero
        : (to > t.duration ? t.duration : to);
    notifyListeners();
  }

  void toggleShuffle() {
    _shuffle = !_shuffle;
    final cur = current;
    if (cur != null) {
      if (_shuffle) {
        _applyShuffle();
      } else {
        _queue = List.of(_original);
        final i = _queue.indexWhere((t) => t.id == cur.id);
        _index = i < 0 ? 0 : i;
      }
    }
    notifyListeners();
  }

  void cycleRepeat() {
    _repeat = RepeatMode.values[(_repeat.index + 1) % RepeatMode.values.length];
    notifyListeners();
  }

  void toggleLike(String id) {
    if (!_liked.remove(id)) _liked.add(id);
    notifyListeners();
  }

  void addToQueue(Track track) {
    if (_queue.isEmpty) {
      playQueue([track]);
      return;
    }
    _queue.add(track);
    _original.add(track);
    notifyListeners();
  }

  void playNext(Track track) {
    if (_queue.isEmpty) {
      playQueue([track]);
      return;
    }
    _queue.insert(_index + 1, track);
    _original.add(track);
    notifyListeners();
  }

  /// Removes an upcoming track. The track that is playing cannot be removed.
  void removeFromQueue(int queueIndex) {
    if (queueIndex <= _index || queueIndex >= _queue.length) return;
    final removed = _queue.removeAt(queueIndex);
    _original.remove(removed);
    notifyListeners();
  }

  /// Moves the position forward. Called by the timer, and by tests.
  void advance(Duration by) {
    final t = current;
    if (!_playing || t == null) return;
    _position += by;
    if (_position >= t.duration) _finishTrack();
    notifyListeners();
  }

  void _finishTrack() {
    if (_repeat == RepeatMode.one) {
      _position = Duration.zero;
    } else if (_index < _queue.length - 1) {
      _index++;
      _position = Duration.zero;
    } else if (_repeat == RepeatMode.all) {
      _index = 0;
      _position = Duration.zero;
    } else {
      _position = Duration.zero;
      _playing = false;
      _syncTimer();
    }
  }

  void _applyShuffle() {
    final cur = _queue[_index];
    final rest = List.of(_queue)..removeAt(_index);
    rest.shuffle(_rng);
    _queue = [cur, ...rest];
    _index = 0;
  }

  void _syncTimer() {
    if (_playing && _autoTick) {
      _timer ??= Timer.periodic(_tick, (_) => advance(_tick));
    } else {
      _timer?.cancel();
      _timer = null;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
