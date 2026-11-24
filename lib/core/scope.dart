import 'package:flutter/widgets.dart';

import '../player/player_controller.dart';

/// Gives every route access to the [PlayerController].
class PlayerScope extends InheritedNotifier<PlayerController> {
  const PlayerScope({
    super.key,
    required PlayerController controller,
    required super.child,
  }) : super(notifier: controller);

  static PlayerController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<PlayerScope>();
    assert(scope != null, 'PlayerScope missing above this widget');
    return scope!.notifier!;
  }
}
