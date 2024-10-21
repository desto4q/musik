import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_requery/flutter_requery.dart';
import 'package:flutter_tailwind_colors/flutter_tailwind_colors.dart';
import 'package:illur/stackScreens/artist_screen.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

class TabArtist extends StatefulWidget {
  const TabArtist({super.key});

  @override
  State<TabArtist> createState() => _TabArtistState();
}

class _TabArtistState extends State<TabArtist> {
  final _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Query(const ["artist"],
        builder: (context, resp) {
          return VsScrollbar(
            controller: _scrollController,
            child: SuperListView.builder(
              itemCount: resp.data!.length,
              controller: _scrollController,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (builder) {
                      return ArtistScreen(
                        artistModel: resp.data![index],
                      );
                    }));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 52,
                          height: 52,
                          child: Query([resp.data![index].id],
                              builder: (builder, image_resp) {
                                if (image_resp.error != null) {
                                  return Container(
                                    width: 52,
                                    height: 52,
                                    child: const Icon(Icons.library_music),
                                  );
                                }
                                if (image_resp.loading) {
                                  return Container(
                                    width: 52,
                                    height: 52,
                                    color: Colors.amber,
                                    child: const Icon(Icons.library_music),
                                  );
                                }
                                return CachedMemoryImage(
                                  width: 52,
                                  height: 52,
                                  uniqueKey: resp.data![index].toString(),
                                  bytes: image_resp.data,
                                );
                              },
                              future: () async => OnAudioQuery().queryArtwork(
                                  resp.data![index].id, ArtworkType.ARTIST)),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                resp.data![index].artist,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "albums: ${resp.data![index].numberOfAlbums}",
                                    style: TextStyle(
                                      color: TWColors.neutral.shade500,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                    "tracks: ${resp.data![index].numberOfTracks}",
                                    style: TextStyle(
                                      color: TWColors.neutral.shade500,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
        future: () async => OnAudioQuery().queryArtists());
  }
}
