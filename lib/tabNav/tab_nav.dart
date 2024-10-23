import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tailwind_colors/flutter_tailwind_colors.dart';
import 'package:illur/playerModel/player_model.dart';
import 'package:illur/stackScreens/search_screen.dart';
import 'package:illur/tabNav/screens/albums.dart';
import 'package:illur/tabNav/screens/artist.dart';
import 'package:illur/tabNav/screens/genres.dart';
import 'package:illur/tabNav/screens/home.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:transitioned_indexed_stack/transitioned_indexed_stack.dart';

class TabNav extends StatefulWidget {
  const TabNav({super.key});

  @override
  State<TabNav> createState() => _TabNavState();
}

const List<Map<String, Widget>> TabItemList = [
  {"icon": Icon(Icons.home), "text": Text("Home")},
  {"icon": Icon(Icons.album), "text": Text("Albums")},
  {"icon": Icon(Icons.person), "text": Text("Artist")},
  {"icon": Icon(Icons.disc_full), "text": Text("Genre")},
];

final TabList = [
  TabHome(),
  const TabAlbums(),
  const TabArtist(),
  const TabGenre(),
];

class _TabNavState extends State<TabNav> {
  int _selected_item = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Musik"),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context,
                          MaterialPageRoute(builder: (builder) {
                        return const SearchScreen();
                      }));
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.search),
            ),
          ),
          InkWell(
            onTap: () {
              showMaterialModalBottomSheet(
                  context: context,
                  enableDrag: true,
                  useRootNavigator: true,
                  builder: (builder) {
                    Size size = MediaQuery.of(context).size;
                    return SizedBox(
                      height: size.height - 180,
                      width: size.width,
                      child:
                          Consumer<SortModel>(builder: (context, val, child) {
                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("Sort Order"),
                                ),
                                Column(
                                  children:
                                      SongSortType.values.map((toElement) {
                                    return Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: InkWell(
                                        onTap: () {
                                          val.changeSortType(toElement);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Icon(val.sortType.name ==
                                                      toElement.name
                                                  ? Icons.circle
                                                  : Icons.circle_outlined),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Text(toElement.name)
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                Row(
                                  children: OrderType.values.map((toElement) {
                                    return Expanded(
                                      child: InkWell(
                                          onTap: () {
                                            val.changeOrderType(toElement);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10), // Correct usage
                                              border: Border.all(
                                                  color: const Color.fromARGB(
                                                      255, 100, 111, 160),
                                                  width:
                                                      val.orderType == toElement
                                                          ? 4
                                                          : 0),
                                            ),
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: Text(
                                                  toElement.name.contains("ASC")
                                                      ? "ASC"
                                                      : "DESC"),
                                            ),
                                          )),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    );
                  });
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.menu),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          ClipRRect(
            child: SizedBox(
              height: 60,
              child: FlashyTabBar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  selectedIndex: _selected_item,
                  height: 60,
                  items: TabItemList.map((element) {
                    return FlashyTabBarItem(
                      activeColor: TWColors.neutral.shade200,
                      inactiveColor: TWColors.neutral.shade600,
                      icon: element["icon"] ??
                          const Icon(Icons.error), // Fallback to a default icon
                      title: element["text"] ??
                          const Text("Unknown"), // Fallback to default text
                    );
                  }).toList(),
                  onItemSelected: (e) {
                    setState(() {
                      _selected_item = e;
                    });
                  }),
            ),
          ),
          Expanded(
              child: FadeIndexedStack(
            index: _selected_item,
            children: TabList,
          ))
        ],
      ),
      // bottomNavigationBar:
    );
  }
}
