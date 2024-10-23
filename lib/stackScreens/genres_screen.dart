import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_requery/flutter_requery.dart';
import 'package:illur/component/song_tile.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class GenresScreen extends StatelessWidget {
  const GenresScreen({super.key, required this.genreModel});
  final GenreModel genreModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(genreModel.genre),
      ),
      body: Container(
        child: Query([genreModel.genre.toString()],
            builder: (builder, res) {
              if (res.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (res.error != null) {
                return (const Center(
                  child: Text("error"),
                ));
              }
              // return Text("data");
              final playlist = ConcatenatingAudioSource(
                // Start loading next item just before reaching it
                useLazyPreparation: true,
                // Customise the shuffle algorithm
                shuffleOrder: DefaultShuffleOrder(),
                // Specify the playlist items
                children: res.data!.map((toElement) {
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
                  ...res.data!.asMap().entries.map((entry) {
                    int index = entry.key; // The index
                    var toElement = entry.value;
                    return SongTile(
                      name: genreModel.genre,
                      song: toElement,
                      playlist: playlist,
                      index: index,
                    );
                  })
                ],
              );
            },
            future: () async => OnAudioQuery()
                .queryAudiosFrom(AudiosFromType.GENRE_ID, genreModel.id)),
      ),
    );
  }
}
