import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_requery/flutter_requery.dart';
import 'package:flutter_tailwind_colors/flutter_tailwind_colors.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

class PlaylistSheet extends StatefulWidget {
  const PlaylistSheet({super.key});

  @override
  State<PlaylistSheet> createState() => _PlaylistSheetState();
}

class _PlaylistSheetState extends State<PlaylistSheet> {
  final ListController _listController = ListController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final AudioPlayer player = Provider.of<AudioPlayer>(context);

    return SizedBox(
      height: size.height - 100,
      width: size.width,
      child: StreamBuilder<SequenceState?>(
        stream: player.sequenceStateStream,
        builder: (context, snapshot) {
          final sequenceState = snapshot.data;
          if (!snapshot.hasData || sequenceState!.effectiveSequence.isEmpty) {
            return const Center(child: Text("No songs in playlist"));
          }

          // Retrieve the playlist and current index
          List<MediaItem> playlist = sequenceState.effectiveSequence
              .map((audioSource) => audioSource.tag as MediaItem)
              .toList();
          int? currentIndex = sequenceState.currentIndex;

          // Scroll to the current playing song
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _listController.jumpToItem(
              alignment: 0,
              index: currentIndex,
              scrollController: _scrollController,
            );
          });
        
          return VsScrollbar(
            controller: _scrollController,
            child: SuperListView.builder(
              controller: _scrollController,
              listController: _listController,
              itemCount: playlist.length,
              itemBuilder: (context, index) {
                return PlaylistTile(
                  player: player,
                  song: playlist[index],
                  index: index,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

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
