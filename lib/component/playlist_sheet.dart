import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_requery/flutter_requery.dart';
import 'package:flutter_tailwind_colors/flutter_tailwind_colors.dart';
import 'package:illur/component/playlist_tile.dart';
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
  int? _lastAnimatedIndex; // Track last animated index

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

          // Scroll to the current playing song only if currentIndex changed

          return Column(
            children: [
              currentIndex != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          child: Text("Now Playing"),
                        ),
                        InkWell(
                          onTap: () {
                            _listController.animateToItem(
                                index: player.currentIndex ?? 0,
                                scrollController: _scrollController,
                                alignment: 0,
                                duration: (t) => Duration(milliseconds: 300),
                                curve: (t) => Curves.easeIn);
                          },
                          child: IgnorePointer(
                            ignoring: true,
                            child: PlaylistTile(
                                player: player,
                                song: playlist[currentIndex],
                                index: currentIndex),
                          ),
                        )
                      ],
                    )
                  : Container(),
              const Divider(height: 3),
              Expanded(
                child: VsScrollbar(
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
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
