import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tailwind_colors/flutter_tailwind_colors.dart';
import 'package:illur/component/lyric_screen.dart';
import 'package:illur/component/main_player_controls.dart';
import 'package:illur/component/main_player_info.dart';
import 'package:illur/component/player_image.dart';
import 'package:illur/component/playlist_sheet.dart';
import 'package:illur/component/progress_bar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:transitioned_indexed_stack/transitioned_indexed_stack.dart';

class MainPlayer extends StatefulWidget {
  const MainPlayer(
      {super.key, required this.per, required this.miniplayerController});
  final double per;
  final MiniplayerController miniplayerController;

  @override
  State<MainPlayer> createState() => _MainPlayerState();
}

class _MainPlayerState extends State<MainPlayer> {
  int _selectedIndex = 0;
  bool _modalOpen = false;
  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (_modalOpen) {
      return false;
    }
    if (_selectedIndex > 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return true;
    }
    if (widget.per > 0.5) {
      widget.miniplayerController.animateToHeight(height: 80);
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 60;
    final player = Provider.of<AudioPlayer>(context);

    return PopScope(
      canPop: false, // Set canPop based on selected index
      child: Container(
        child: StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (builder, snapshot) {
            if (!snapshot.hasData) {
              return const Text("Loading player state...");
            }
            final playerState = snapshot.data;
            return Column(
              children: [
                Flexible(
                  child: FadeIndexedStack(
                    index: _selectedIndex,
                    children: [
                      Column(
                        children: [
                          const SizedBox(
                            height: 60,
                          ),
                          Text(playerState!.processingState.name.toString()),
                          Center(
                            child: PlayerImage(height: width, width: width),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          MainPlayerInfo(
                            width: width,
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          MyProgressBar(
                            width: width,
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          const MainPlayerControls(),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedIndex =
                                        (_selectedIndex == 1) ? 0 : 1;
                                  });
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(Icons.lyrics),
                                ),
                              ),
                              StreamBuilder(
                                  stream: player.shuffleModeEnabledStream,
                                  builder: (context, snapshot) {
                                    bool shuffles = snapshot.data as bool;

                                    return InkWell(
                                      onTap: () {
                                        player.setShuffleModeEnabled(!shuffles);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: shuffles
                                            ? const Icon(
                                                Icons.shuffle,
                                              )
                                            : Icon(
                                                Icons.shuffle,
                                                color:
                                                    TWColors.neutral.shade600,
                                              ),
                                      ),
                                    );
                                  }),
                              StreamBuilder<LoopMode>(
                                  stream: player.loopModeStream,
                                  builder: (context, snapshot) {
                                    final loopmode = snapshot.data;

                                    return InkWell(
                                      onTap: () {
                                        if (loopmode == LoopMode.one) {
                                          player.setLoopMode(LoopMode.all);
                                          return;
                                        }
                                        if (loopmode == LoopMode.all) {
                                          player.setLoopMode(LoopMode.off);
                                          return;
                                        }
                                        player.setLoopMode(LoopMode.one);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: loopmode == LoopMode.one
                                            ? const Icon(Icons.repeat)
                                            : loopmode == LoopMode.all
                                                ? const Icon(
                                                    Icons.repeat_on_outlined)
                                                : Icon(
                                                    Icons.repeat,
                                                    color: TWColors
                                                        .neutral.shade600,
                                                  ),
                                      ),
                                    );
                                  }),
                              InkWell(
                                onTap: ()async {
                                  setState(() {
                                    _modalOpen = true;
                                  });
                                  showMaterialModalBottomSheet(
                                      context: context,
                                      builder: (builder) {
                                        return const PlaylistSheet();
                                      }).then((onValue){
                                         setState(() {
                                      _modalOpen = false;
                                  });
                                      });
                                  
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(Icons.playlist_add_check),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          )
                        ],
                      ),
                      const LyricScreen(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
