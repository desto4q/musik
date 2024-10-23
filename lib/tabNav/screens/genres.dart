import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_requery/flutter_requery.dart';
import 'package:flutter_tailwind_colors/flutter_tailwind_colors.dart';
import 'package:illur/stackScreens/genres_screen.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

class TabGenre extends StatefulWidget {
  const TabGenre({super.key});

  @override
  State<TabGenre> createState() => _TabGenreState();
}

class _TabGenreState extends State<TabGenre> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Query(const ["genres"],
          builder: (builder, resp) {
            return VsScrollbar(
              controller: _scrollController,
              child: SuperListView.builder(
                controller: _scrollController,
                itemCount: resp.data!.length,
                padding: const EdgeInsets.only(bottom: 90),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (builder) {
                        return GenresScreen(
                          genreModel: resp.data![index],
                        );
                      }));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SizedBox(
                              width: 58,
                              height: 58,
                              child: Query([resp.data![index].id.toString()],
                                  builder: (builder, imageResp) {
                                    if (imageResp.error != null) {
                                      return const SizedBox(
                                        width: 52,
                                        height: 52,
                                        child: Icon(Icons.library_music),
                                      );
                                    }
                                    if (imageResp.loading) {
                                      return Container(
                                        width: 52,
                                        height: 52,
                                        color: Colors.amber,
                                        child: const Icon(Icons.library_music),
                                      );
                                    }
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedMemoryImage(
                                        width: 52,
                                        height: 52,
                                        uniqueKey: resp.data![index].toString(),
                                        bytes: imageResp.data,
                                      ),
                                    );
                                  },
                                  future: () async => OnAudioQuery()
                                      .queryArtwork(resp.data![index].id,
                                          ArtworkType.GENRE))),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                resp.data![index].genre,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                resp.data![index].numOfSongs.toString(),
                                style: TextStyle(
                                  color: TWColors.neutral.shade500,
                                ),
                              )
                            ],
                          ))
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
          future: () async => OnAudioQuery().queryGenres()),
    );
  }
}
