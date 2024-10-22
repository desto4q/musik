import 'package:flutter/material.dart';
import 'package:illur/component/mini_player_controls.dart';
import 'package:illur/component/mini_player_info.dart';
import 'package:illur/component/player_image.dart';
class MiniPlay extends StatefulWidget {
  const MiniPlay({super.key});

  @override
  State<MiniPlay> createState() => _MiniPlayState();
}

class _MiniPlayState extends State<MiniPlay> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(8.0),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PlayerImage(height: 52, width: 52),
          Flexible(
            child: MiniPlayerInfo(),
          ),
          MiniPlayerControls(),
        ],
      ),
    );
  }
}
