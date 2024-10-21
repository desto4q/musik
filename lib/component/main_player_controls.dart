import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class MainPlayerControls extends StatelessWidget {
  const MainPlayerControls({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<AudioPlayer>(context);
    final double control_size = 52;
    return StreamBuilder<PlayerState>(
        stream: player.playerStateStream,
        builder: (c, snapshot) {
          final playerState = snapshot.data;
          final playing = playerState?.playing;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  player.seekToPrevious();
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.skip_previous,
                    size: control_size,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              InkWell(
                onTap: () {
                  if (playing == true) {
                    player.pause();
                  } else {
                    player.play();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    playing == true ? Icons.pause : Icons.play_arrow,size: control_size,
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
                  child: Icon(
                    Icons.skip_next,
                    size: control_size,
                  ),
                ),
              ),
            ],
          );
        });
  }
}
