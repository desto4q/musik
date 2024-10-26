import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_requery/flutter_requery.dart';
import 'package:flutter_tailwind_colors/flutter_tailwind_colors.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';

class PlaylistTile extends StatelessWidget {
  const PlaylistTile({
    super.key,
    required AudioPlayer player,
    required this.song,
    required this.index,
  }) : _player = player;

  final int index;
  final AudioPlayer _player;
  final MediaItem song;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _player.seek(Duration.zero, index: index);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            SizedBox(
              height: 52,
              width: 52,
              child: Query(song.id,
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
                        height: 52,
                        width: 52,
                        filterQuality: FilterQuality.low,
                        uniqueKey: "${song.id} playlist",
                        bytes: resp.data,
                        errorWidget: const Center(
                          child: Icon(Icons.music_note),
                        ),
                      ),
                    );
                  },
                  future: () => OnAudioQuery().queryArtwork(
                        int.parse(song.id),
                        ArtworkType.AUDIO,
                        quality: 10,
                        size: 52,
                      )),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  song.artist ?? "No Artist",
                  maxLines: 1,
                  style: TextStyle(color: TWColors.neutral.shade500),
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
