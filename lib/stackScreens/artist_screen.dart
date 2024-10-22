import 'package:flutter/material.dart';
import 'package:flutter_requery/flutter_requery.dart';
import 'package:illur/component/song_tile.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';

class ArtistScreen extends StatelessWidget {
  const ArtistScreen({super.key, required this.artistModel});
  final ArtistModel artistModel;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(artistModel.artist),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              QueryArtworkWidget(
                id: artistModel.id,
                type: ArtworkType.ARTIST,
                artworkWidth: size.width - 80,
                artworkHeight: size.width - 80,
              ),
              const SizedBox(
                height: 22,
              ),
              Column(
                children: [
                  Text(
                    artistModel.artist,
                    style: const TextStyle(fontSize: 22),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${artistModel.numberOfAlbums} album"),
                      const SizedBox(
                        width: 4,
                      ),
                      const Icon(
                        Icons.circle,
                        size: 12,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text("${artistModel.numberOfTracks} track"),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8.0),
                        child: Text(
                          "Tracks",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Query(["songs", artistModel.artist],
                          builder: (builder, resp) {
                            if (resp.loading) {
                              return const Center(
                                child: const Text("loading"),
                              );
                            }
                            if (resp.error != null) {
                              return const Center(
                                child: Text("error"),
                              );
                            }
                            final playlist = ConcatenatingAudioSource(
                              // Start loading next item just before reaching it
                              useLazyPreparation: true,
                              // Customise the shuffle algorithm
                              shuffleOrder: DefaultShuffleOrder(),
                              // Specify the playlist items
                              children: resp.data!.map((toElement) {
                                return AudioSource.uri(
                                    Uri.parse(toElement.data),
                                    tag: toElement);
                              }).toList(),
                            );
                            final name = artistModel.artist;
                            return Column(
                              children: resp.data!.asMap().entries.map((entry) {
                                int index = entry.key; // The index
                                var toElement = entry.value;
                                return SongTile(
                                  name: name,
                                  song: toElement,
                                  playlist: playlist,
                                  index: index,
                                );
                              }).toList(),
                            );
                          },
                          future: () async => OnAudioQuery().queryAudiosFrom(
                              AudiosFromType.ARTIST_ID, artistModel.id)),
                      SizedBox(
                        height: 120,
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
