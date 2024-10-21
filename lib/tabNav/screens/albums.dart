import 'package:flutter/material.dart';
import 'package:flutter_requery/flutter_requery.dart';
import 'package:illur/component/album_tile.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

class TabAlbums extends StatefulWidget {
  const TabAlbums({super.key});

  @override
  State<TabAlbums> createState() => _TabAlbumsState();
}

class _TabAlbumsState extends State<TabAlbums> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Query(const ["albums"], builder: (BuildContext builder, resp) {
        if (resp.error != null) {
          return const GridTile(child: Text("err"));
        }
        if (resp.loading) {
          return const GridTile(child: Text("loading"));
        }
        return VsScrollbar(
          controller: _scrollController,
          child: GridView.builder(
              controller: _scrollController,
              itemCount: resp.data!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (builder, index) {
                return AlbumTile(
                  album: resp.data![index],
                );
              }),
        );
      }, future: OnAudioQuery().queryAlbums),
    );
  }
}
