import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class MiniPlayerInfo extends StatefulWidget {
  const MiniPlayerInfo({super.key});

  @override
  State<MiniPlayerInfo> createState() => _MiniPlayerInfoState();
}

class _MiniPlayerInfoState extends State<MiniPlayerInfo> {
  String? currentSongUri;
  AudioMetadata? currentMetadata;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: screenWidth * 3 / 7,
                child: Text(
                  metadata.extras?["path"] ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              SizedBox(
                width: screenWidth * 3 / 7,
                child: Text(
                  metadata.artist ?? "No artist",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        });
  }
}
