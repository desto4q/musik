import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_requery/flutter_requery.dart';
import 'package:flutter_tailwind_colors/flutter_tailwind_colors.dart';
import 'package:illur/component/main_player_controls.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:lrc/lrc.dart';
import 'package:provider/provider.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class LyricScreen extends StatefulWidget {
  const LyricScreen({super.key});

  @override
  State<LyricScreen> createState() => _LyricScreenState();
}

class _LyricScreenState extends State<LyricScreen> {
  final ListController _listController = ListController();
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<int?> _activeIndexNotifier = ValueNotifier<int?>(null);
  @override
  void dispose() {
    _scrollController.dispose();
    _activeIndexNotifier.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          Consumer<AudioPlayer>(
            builder: (context, player, child) {
              return StreamBuilder(
                  stream: player.sequenceStateStream,
                  builder: (builder, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    _activeIndexNotifier.value = -1;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _listController.animateToItem(
                          index: 0,
                          scrollController: _scrollController,
                          alignment: 0.5,
                          duration: (t) => const Duration(milliseconds: 500),
                          curve: (t) => Curves.easeIn);
                    });
                    final playerState = snapshot.data;
                    final metadata =
                        playerState?.currentSource!.tag as MediaItem;
                    queryCache
                        .invalidateQueries(metadata.extras?["path"] ?? "empty");
                    return Query([metadata.extras?["path"] ?? "empty"],
                        builder: (builder, resp) {
                          if (resp.data == null || resp.data!.isEmpty) {
                            return const Center(
                                child: Text("No Lyrics Available"));
                          }

                          return Column(
                            children: [
                              const SizedBox(
                                height: 80,
                              ),
                              Expanded(
                                child: StreamBuilder<Duration>(
                                  stream: player.positionStream,
                                  builder: (context, snapshot) {
                                    final pos = snapshot.data ?? Duration.zero;
                                    final List<LrcLine> lyrics = resp.data!;

                                    int activeIndex = -1;
                                    for (int i = 0; i < lyrics.length; i++) {
                                      final LrcLine lyric = lyrics[i];
                                      final LrcLine? nextLyric =
                                          (i + 1 < lyrics.length)
                                              ? lyrics[i + 1]
                                              : null;

                                      if (pos >= lyric.timestamp &&
                                          (nextLyric == null ||
                                              pos < nextLyric.timestamp)) {
                                        activeIndex = i;
                                        break;
                                      }
                                    }

                                    if (activeIndex != -1 &&
                                        activeIndex !=
                                            _activeIndexNotifier.value) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        _listController.animateToItem(
                                            index: activeIndex,
                                            duration: (t) => const Duration(
                                                milliseconds: 300),
                                            scrollController: _scrollController,
                                            curve: (t) => Curves.easeIn,
                                            alignment: 0.5);
                                      });
                                      _activeIndexNotifier.value =
                                          activeIndex; // Update notifier value
                                    }

                                    return ValueListenableBuilder<int?>(
                                      valueListenable: _activeIndexNotifier,
                                      builder: (context, activeIndex, child) {
                                        return SuperListView.builder(
                                          padding:
                                              const EdgeInsets.only(top: 80),
                                          listController: _listController,
                                          controller: _scrollController,
                                          itemCount: lyrics.length,
                                          itemBuilder: (context, index) {
                                            final LrcLine currentLyric =
                                                lyrics[index];
                                            final bool isActiveLyric =
                                                index == activeIndex;

                                            return InkWell(
                                              onTap: () {
                                                player.seek(
                                                    currentLyric.timestamp);
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: AnimatedDefaultTextStyle(
                                                  duration: const Duration(
                                                      milliseconds: 300),
                                                  style: TextStyle(
                                                    fontSize: 23,
                                                    color: isActiveLyric
                                                        ? TWColors
                                                            .neutral.shade200
                                                        : TWColors
                                                            .neutral.shade700,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  child:
                                                      Text(currentLyric.lyrics),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                              )
                            ],
                          );
                        },
                        future: () async => _pathChecker(metadata));
                  });
            },
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: MainPlayerControls(),
              ),
            ),
          )
        ],
      ),
    );
  }
}

Future<List<LrcLine>> _pathChecker(MediaItem metadata) async {
  final path = "storage/emulated/0/Music/${metadata.extras?["path"]}.lrc";
  final file = File(path);
  if (await file.exists()) {
    Lrc parsed = Lrc.parse(file.readAsStringSync());
    return parsed.lyrics;
  } else {
    print("File does not exist at: $path");
    Lrc parsed = Lrc.parse("");
    return parsed.lyrics;
  }
}

Stream<LrcStream> streamLrc(Lrc lrc) async* {
  // Subscribe to the stream and yield the LrcStream events
  await for (LrcStream event in lrc.stream) {
    yield event;
  }
}

Stream<LrcStream> streamLrcFromList(List<LrcLine> lines) async* {
  // Convert list of LrcLine to a stream of LrcStream objects
  await for (LrcStream event in lines.toStream()) {
    yield event;
  }
}
