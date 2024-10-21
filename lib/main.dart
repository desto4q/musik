import 'package:flutter/material.dart';
import 'package:illur/component/main_player.dart';
import 'package:illur/component/mini_player.dart';
import 'package:illur/playerModel/player_model.dart';
import 'package:illur/tabNav/tab_nav.dart';
import 'package:just_audio/just_audio.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:provider/provider.dart';

final _navigatorKey = GlobalKey();

void main() async {
  runApp(
    MultiProvider(
      providers: [
        Provider<AudioPlayer>(
          create: (_) => AudioPlayer(),
          dispose: (_, player) =>
              player.dispose(), // Ensure disposal of the player
        ),
        ChangeNotifierProvider<SortModel>(
          create: (_) => SortModel(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MiniplayerController controller = MiniplayerController();

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<AudioPlayer>(context);
    final maxHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const Main(),
      builder: (context, child) {
        final maxHeight = MediaQuery.of(context).size.height;
        return Stack(
          children: [
            child!,
            StreamBuilder(
              stream: player.sequenceStateStream,
              builder: (context, snapshot) {
                final sequenceState = snapshot.data;
                final playlistNotEmpty =
                    sequenceState?.sequence.isNotEmpty ?? false;

                return Offstage(
                  offstage: !playlistNotEmpty,
                  child: Miniplayer(
                    controller: controller,
                    tapToCollapse: false,
                    minHeight: 80,
                    maxHeight: maxHeight,
                    builder: (height, percentage) {
                      // Calculate the opacity for MiniPlay based on the percentage
                      double miniPlayerOpacity = (percentage > 0.5)
                          ? (1 - (percentage - 0.5) * 2)
                          : 1.0;

                      // Invert the opacity for MainPlayer (opposite behavior)
                      double mainPlayerOpacity = 1 - miniPlayerOpacity;
                      return Stack(
                        children: [
                          Opacity(
                            opacity: mainPlayerOpacity,
                            child: OverflowBox(
                                maxHeight: maxHeight,
                                child: MainPlayer(
                                  miniplayerController: controller,
                                  per: percentage,
                                )),
                          ),
                          IgnorePointer(
                            ignoring: percentage >
                                0.5, // Disable gestures when per > 0.5
                            child: Opacity(
                              opacity: miniPlayerOpacity,
                              child: const MiniPlay(), // Your mini player UI
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
                // Check if any audio source is loaded
              },
            ),
          ],
        );
      },
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: TabNav());
  }
}
