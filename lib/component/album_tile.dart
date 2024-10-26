import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_requery/flutter_requery.dart';
import 'package:illur/stackScreens/album_screen.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';

class AlbumTile extends StatefulWidget {
  const AlbumTile({super.key, required this.album});
  final AlbumModel album;

  @override
  State<AlbumTile> createState() => _AlbumTileState();
}

class _AlbumTileState extends State<AlbumTile> {
  @override
  Widget build(BuildContext context) {
    return GridTile(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (builder){
            return AlbumScreen( album: widget.album,);
          }));
        },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(children: [
            Expanded(
              child: Query(widget.album.id,
                  builder: (builder, resp) {
                    if (resp.error != null) {
                      return const Text("err");
                    }
                    if (resp.loading) {
                      return const Icon(Icons.music_note);
                    }
                    // returnText(resp.data.toString());
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedMemoryImage(
                        
                        filterQuality: FilterQuality.low,
                        uniqueKey: widget.album.id.toString(),
                        bytes: resp.data,
                        errorWidget: const Center(
                          child: Icon(Icons.music_note),
                        ),
                      ),
                    );
                  },
                  future: () => OnAudioQuery().queryArtwork(
                      widget.album.id, ArtworkType.ALBUM,
                      quality: 10)),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              widget.album.album,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              widget.album.numOfSongs.toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ]),
        ),
      ),
    ));
  }
}
