import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class MiniPlayerControls extends StatelessWidget {
  const MiniPlayerControls({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<AudioPlayer>(context);

    return StreamBuilder(
        stream: player.playerStateStream,
        builder: (context, snapshot) {
          final state = snapshot.data;
          return Row(
            children: [
              InkWell(
                onTap: () {
                  player.seekToPrevious();
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(Icons.skip_previous),
                ),
              ),
              const SizedBox(width: 4),
              InkWell(
                onTap: () {
                  
                  if (state.playing == true) {
                    player.pause();
                  } else {
                    player.play();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    state!.playing == true ? Icons.pause : Icons.play_arrow,
                    size: 42,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              InkWell(
                onTap: () {
                  player.seekToNext();
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(Icons.skip_next),
                ),
              ),
            ],
          );
        });
  }
}
