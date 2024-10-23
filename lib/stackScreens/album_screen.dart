import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_requery/flutter_requery.dart';
import 'package:illur/component/song_tile.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({super.key, required this.album});
  final AlbumModel album;

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // Keep this alive

  @override
  Widget build(BuildContext context) {
    super.build(context); // Don't forget to call super.build
    double screenWidth = MediaQuery.of(context).size.width;
    double artworkSize = screenWidth - 40;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.album.album),
      ),
      body: Container(
        child: Center(
          child: Column(children: [
            Expanded(
              child: Query(["album", widget.album.album],
                  builder: (builder, resp) {
                    if (resp.error != null) {
                      return Text(resp.error.toString());
                    }
                    if (resp.loading) {
                      return const Text("loading");
                    }

                    final playlist = ConcatenatingAudioSource(
                      // Start loading next item just before reaching it
                      useLazyPreparation: true,
                      // Customise the shuffle algorithm
                      shuffleOrder: DefaultShuffleOrder(),
                      // Specify the playlist items
                      children: resp.data!.map((toElement) {
                        return AudioSource.uri(Uri.parse(toElement.data),
                            tag: MediaItem(
                              id: toElement.id.toString(),
                              title: toElement.title,
                              album: toElement.album,
                              artist: toElement.artist,
                              extras: {"path": toElement.displayNameWOExt},
                            ));
                      }).toList(),
                    );

                    return SuperListView(
                      children: [
                        SizedBox(
                          width: artworkSize,
                          height: artworkSize,
                          child: Column(children: [
                            QueryArtworkWidget(
                              keepOldArtwork: true,
                              artworkHeight: artworkSize,
                              artworkWidth: artworkSize,
                              artworkFit: BoxFit.contain,
                              artworkBorder: BorderRadius.circular(10),
                              id: widget.album.id,
                              type: ArtworkType.ALBUM,
                            ),
                          ]),
                        ),
                        SizedBox(
                          width: artworkSize,
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              SizedBox(
                                width: artworkSize,
                                child: Text("Album: ${widget.album.album}"),
                              ),
                              SizedBox(
                                width: artworkSize,
                                child: Text(
                                  "Artist: ${widget.album.artist ?? "No artist"}",
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...resp.data!.asMap().entries.map((entry) {
                          int index = entry.key; // The index
                          var toElement =
                              entry.value; // The element at this index

                          return SizedBox(
                            width: artworkSize,
                            child: SongTile(
                              name: widget.album.album,
                              song: toElement,
                              playlist: playlist,
                              index: index, // Pass the index here
                            ),
                          );
                        }),
                        const SizedBox(height: 90),
                      ],
                    );
                  },
                  future: () => OnAudioQuery().queryAudiosFrom(
                      AudiosFromType.ALBUM_ID, widget.album.id)),
            ),
          ]),
        ),
      ),
    );
  }
}
