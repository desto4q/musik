import 'package:flutter/material.dart';
import 'package:flutter_requery/flutter_requery.dart';
import 'package:illur/component/song_tile.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by title or artist...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          // Query for fetching songs
          Expanded(
            child: Query(
              const ["audio", "search"],
              builder: (context, resp) {
                if (resp.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (resp.error != null) {
                  return const Center(
                    child: Text("error"),
                  );
                }
                final songlist = resp.data!;

                // Filter songs based on the search query (both title and artist)
                final filteredSongs = songlist.where((song) {
                  final songTitle = song.title.toLowerCase();
                  final songArtist =
                      (song.artist ?? 'Unknown Artist').toLowerCase();
                  return songTitle.contains(_searchQuery) ||
                      songArtist.contains(_searchQuery);
                }).toList();

                const name = "main";
                final playlist = ConcatenatingAudioSource(
                  useLazyPreparation: true,
                  shuffleOrder: DefaultShuffleOrder(),
                  children: filteredSongs.map((song) {
                    return AudioSource.uri(Uri.parse(song.data),
                        tag: MediaItem(
                            id: song.id.toString(),
                            title: song.title,
                            album: song.album,
                            artist: song.artist,
                            displayTitle: song.displayNameWOExt));
                  }).toList(),
                );

                // Use AnimatedSwitcher for smooth transitions between filtered results
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: filteredSongs.isNotEmpty
                      ? SuperListView.builder(
                          key: ValueKey(filteredSongs
                              .length), // Unique key for each filtered list
                          itemCount: filteredSongs.length,
                          itemBuilder: (_, index) {
                            return SongTile(
                              song: filteredSongs[index],
                              playlist: playlist,
                              name: name,
                              index: index,
                            );
                          },
                        )
                      : const Center(
                          key: ValueKey(0), // Unique key for empty state
                          child: Text('No songs found'),
                        ),
                );
              },
              future: () async => await OnAudioQuery().querySongs(),
            ),
          ),
        ],
      ),
    );
  }
}
