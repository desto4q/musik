import 'package:flutter/material.dart';
import 'package:flutter_tailwind_colors/flutter_tailwind_colors.dart';
import 'package:illur/component/main_player.dart';
import 'package:illur/component/mini_player.dart';
import 'package:illur/playerModel/player_model.dart';
import 'package:illur/tabNav/tab_nav.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

final _navigatorKey = GlobalKey();

Future<void> main() async {
  await JustAudioBackground.init(
    notificationColor: TWColors.emerald.shade700,
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CurrentPlaying(),
        ),
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
  State<MyApp> createState() => _GrantedState();
}

class _GrantedState extends State<MyApp> {
  bool _permissionsGranted = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    PermissionStatus storagePermission = await Permission.storage.status;
    PermissionStatus mediaLibraryPermission =
        await Permission.mediaLibrary.status;

    // If storage permission is not granted, request it
    if (!storagePermission.isGranted || !mediaLibraryPermission.isGranted) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
        Permission.mediaLibrary,
      ].request();

      setState(() {
        _permissionsGranted = statuses[Permission.storage]!.isGranted &&
            statuses[Permission.mediaLibrary]!.isGranted;
      });
    } else {
      setState(() {
        _permissionsGranted = true;
      });
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return _permissionsGranted ? const Entry() : const SplashPage();
  }
}

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Center(
          child: Text("Musik",style: TextStyle(
            fontSize: 32
          ),),
        ),
      ),
    );
  }
}

class Entry extends StatefulWidget {
  const Entry({super.key});

  @override
  State<Entry> createState() => _MyAppState();
}

class _MyAppState extends State<Entry> {
  MiniplayerController controller = MiniplayerController();

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<AudioPlayer>(context);
    final maxHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(
          body: MiniplayerWillPopScope(
            onWillPop: () async {
              final NavigatorState navigator =
                  _navigatorKey.currentState as NavigatorState;
              if (!navigator.canPop()) return true;
              navigator.pop();

              return false;
            },
            child: Stack(
              children: [
                Navigator(
                  key: _navigatorKey,
                  onGenerateRoute: (RouteSettings settings) =>
                      MaterialPageRoute(
                    settings: settings,
                    builder: (BuildContext context) => const TabNav(),
                  ),
                ),
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
                                  ),
                                ),
                              ),
                              IgnorePointer(
                                ignoring: percentage >
                                    0.5, // Disable gestures when per > 0.5
                                child: Opacity(
                                  opacity: miniPlayerOpacity,
                                  child:
                                      const MiniPlay(), // Your mini player UI
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
            ),
          ),
        ));
  }
}
