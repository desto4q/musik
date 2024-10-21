import 'package:flutter/material.dart';
import 'package:flutter_requery/flutter_requery.dart';
import 'package:illur/component/song_tile.dart';
import 'package:illur/playerModel/player_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

class TabHome extends StatelessWidget {
  TabHome({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    return Container(child: Consumer<SortModel>(builder: (context, val, chi) {
      return Query(["audio", val.sortType.name, val.orderType.name],
          builder: (builder, resp) {
            if (resp.error != null) {
              return const Text("error");
            }
            if (resp.loading) {
              return const Center(
                child: Text("loading"),
              );
            }
            final playlist = ConcatenatingAudioSource(
              // Start loading next item just before reaching it
              useLazyPreparation: true,
              // Customise the shuffle algorithm
              shuffleOrder: DefaultShuffleOrder(),
              children: resp.data!.map((toElement) {
                return AudioSource.uri(Uri.parse(toElement.data),
                    tag: toElement);
              }).toList(),
            );
            return VsScrollbar(
                controller: _scrollController,
                child: SuperListView.builder(
                    physics: const BouncingScrollPhysics(),
                    controller: _scrollController,
                    itemCount: resp.data!.length,
                    itemBuilder: (context, item) {
                      return SongTile(
                        song: resp.data![item],
                        playlist: playlist,
                        index: item,
                      );
                    }));
          },
          future: () => OnAudioQuery()
              .querySongs(sortType: val.sortType, orderType: val.orderType));
    }));
  }
}
