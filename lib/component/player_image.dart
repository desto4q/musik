import 'dart:typed_data';
import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';
import 'package:provider/provider.dart';

class PlayerImage extends StatefulWidget {
  const PlayerImage({super.key, required this.height, required this.width});

  final double height;
  final double width;

  @override
  State<PlayerImage> createState() => _PlayerImageState();
}

class _PlayerImageState extends State<PlayerImage> {
  String? currentSongUri;
  AudioMetadata? currentMetadata;
  Uint8List? artwork;

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
          return Container(
            child: QueryArtworkWidget(
              id: int.parse(metadata.id),
              keepOldArtwork: true,
              artworkBorder: BorderRadius.circular(10),
              type: ArtworkType.AUDIO,
              artworkWidth: widget.width,
              artworkHeight: widget.height,
            ),
          );
        });
  }
}
