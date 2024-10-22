import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:audio_service/audio_service.dart';
import 'package:fading_marquee_widget/fading_marquee_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tailwind_colors/flutter_tailwind_colors.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';
import 'package:provider/provider.dart';

class MainPlayerInfo extends StatefulWidget {
  const MainPlayerInfo({super.key, required this.width});
  final double width;
  @override
  State<MainPlayerInfo> createState() => _MainPlayerInfoState();
}

class _MainPlayerInfoState extends State<MainPlayerInfo> {
  String? currentSongUri;
  AudioMetadata? currentMetadata;

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<AudioPlayer>(context);
    return StreamBuilder(
        stream: player.sequenceStateStream,
        builder: (builder, snapshot) {
          final state = snapshot.data;
          final metadata = state?.currentSource!.tag as MediaItem;
          if (state?.sequence.isEmpty == true) {
            return const SizedBox();
          }
          return Column(
            children: [
              SizedBox(
                width: widget.width,
                height: 32,
                child: Center(
                  child: FadingMarqueeWidget(
                    child: Text(
                      metadata.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              SizedBox(
                width: widget.width,
                child: Center(
                  child: FadingMarqueeWidget(
                    child: Text(
                      metadata.artist ?? "No artist",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: TWColors.neutral.shade400),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
