import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:illur/playerModel/player_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';
import 'package:flutter_requery/flutter_requery.dart';
import 'package:provider/provider.dart';
class SongTile extends StatefulWidget {
  const SongTile(
      {super.key,
      required this.song,
      this.index,
      required this.playlist,
      required this.name});
  final SongModel song;
  final int? index;
  final ConcatenatingAudioSource playlist;
  final String name;
  @override
  _SongTileState createState() => _SongTileState();
}

class _SongTileState extends State<SongTile> {
  @override
  Widget build(BuildContext context) {
    final player = Provider.of<AudioPlayer>(context);

    return Consumer<CurrentPlaying>(
      builder: (_, val, child) {
        return InkWell(
          onTap: () async{
            // if (val.current_Playing == widget.name) {
            //   player.seek(Duration.zero, index: widget.index);
            //   print(val.current_Playing);
            //   return;
            // }
            // val.changeCurrentPlaying(widget.name);
            // player.stop();
            // player.setAudioSource(widget.playlist,
            //     initialIndex: widget.index, initialPosition: Duration.zero);
            // player.play();

          },
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                ImageCard(widget: widget),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.song.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis, // Prevent overflow
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.song.artist ?? "No Artist",
                        maxLines: 1, // Optionally limit artist name to one line
                        overflow: TextOverflow.ellipsis, // Prevent overflow
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ImageCard extends StatelessWidget {
  const ImageCard({
    super.key,
    required this.widget,
  });

  final SongTile widget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: 52,
      child: Query(widget.song.id,
          builder: (builder, resp) {
            if (resp.error != null) {
              return const Text("err");
            }
            if (resp.loading) {
              return const Icon(Icons.music_note);
            }
            // returnText(resp.data.toString());
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedMemoryImage(
                filterQuality: FilterQuality.low,
                uniqueKey: widget.song.id.toString(),
                bytes: resp.data,
                errorWidget: const Center(
                  child: Icon(Icons.music_note),
                ),
              ),
            );
          },
          future: () => OnAudioQuery().queryArtwork(
                widget.song.id,
                ArtworkType.AUDIO,
                quality: 10,
              )),
    );
  }
}
