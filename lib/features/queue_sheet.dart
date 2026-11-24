import 'package:flutter/material.dart';

import '../core/scope.dart';
import '../core/theme.dart';
import '../core/widgets.dart';

void showQueueSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => const QueueSheet(),
  );
}

class QueueSheet extends StatelessWidget {
  const QueueSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final player = PlayerScope.of(context);
    final current = player.current;
    final upNext = player.upNext;

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.7,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              'Queue',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
          ),
          if (current != null) ...[
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text('Now playing',
                  style: TextStyle(color: AppColors.muted)),
            ),
            ListTile(
              leading: CoverArt(colors: current.colors, size: 48),
              title: Text(
                current.title,
                style: const TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(current.artist),
            ),
          ],
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text('Next up', style: TextStyle(color: AppColors.muted)),
          ),
          if (upNext.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Nothing queued. Add songs from the track menu.',
                style: TextStyle(color: AppColors.muted),
              ),
            ),
          for (var i = 0; i < upNext.length; i++)
            ListTile(
              leading: CoverArt(colors: upNext[i].colors, size: 48),
              title: Text(upNext[i].title, maxLines: 1),
              subtitle: Text(upNext[i].artist),
              onTap: () => player.jumpTo(player.index + 1 + i),
              trailing: IconButton(
                icon: const Icon(Icons.remove_circle_outline_rounded),
                onPressed: () => player.removeFromQueue(player.index + 1 + i),
              ),
            ),
        ],
      ),
    );
  }
}
