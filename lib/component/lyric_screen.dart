import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_requery/flutter_requery.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lrc/lrc.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';
import 'package:provider/provider.dart';

class LyricScreen extends StatefulWidget {
  const LyricScreen({super.key});

  @override
  State<LyricScreen> createState() => _LyricScreenState();
}

class _LyricScreenState extends State<LyricScreen> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    return Container(
      width: _size.width,
      height: _size.height,
      child: Consumer<AudioPlayer>(
        builder: (context, player, child) {
          return StreamBuilder(
              stream: player.sequenceStateStream,
              builder: (builder, snapshot) {
                if (!snapshot.hasData) {
                  return const Text("data");
                }
                final playerState = snapshot.data;

                final metadata = playerState?.currentSource!.tag as SongModel;

                return Query([metadata.displayNameWOExt],
                    builder: (builder, resp) {
                      if (resp.data == null) {
                        return const Center(child: Text("No Lyrics"));
                      }
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(height: 80),
                                ...resp.data!.map((toElement) {
                                  return InkWell(
                                    onTap: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        toElement.lyrics,
                                        style: TextStyle(fontSize: 18),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          );
                        },
                    future: () async => _pathChecker(metadata));
              });
        },
      ),
    );
  }
}

Future<List<LrcLine>> _pathChecker(SongModel metadata) async {
  final path = "storage/emulated/0/Music/${metadata.displayNameWOExt}.lrc";
  final file = await File(path);

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
