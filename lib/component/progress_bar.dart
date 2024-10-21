import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class MyProgressBar extends StatefulWidget {
  const MyProgressBar({super.key, required this.width});
  final double width;
  @override
  State<MyProgressBar> createState() => _MyProgressBarState();
}

class _MyProgressBarState extends State<MyProgressBar>
    with TickerProviderStateMixin {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<AudioPlayer>(context);
    Stream<PositionedData> _positionDataStream() {
      return Rx.combineLatest3<Duration, Duration, Duration?, PositionedData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
          (position, bufferedPosition, duration) => PositionedData(
              position, bufferedPosition, duration ?? Duration.zero));
    }

    return Container(
      width: widget.width,
      child: Center(
        child: StreamBuilder<PositionedData>(
          stream: _positionDataStream(),
          builder: (context, snapshot) {
            final positionData = snapshot.data;
            return ProgressBar(
              progress: positionData!.position,
              total: positionData.duration,
              onSeek: player.seek,
            );
          },
        ),
      ),
    );
  }
}

class PositionedData {
  const PositionedData(
    this.position,
    this.bufferedPosition,
    this.duration,
  );
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
}
