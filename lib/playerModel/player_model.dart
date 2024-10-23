import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';

class PlayerModel extends BaseAudioHandler with QueueHandler, SeekHandler {
  final player = AudioPlayer();
  @override
  Future<void> play() => player.play();
  @override
  Future<void> pause() => player.pause();
  @override
  Future<void> stop() => player.stop();
  @override
  Future<void> seek(Duration position) => player.seek(position);
  @override
  Future<void> skipToQueueItem(int i) => player.seek(Duration.zero, index: i);
}

class SortModel extends ChangeNotifier {
  SongSortType _sortType = SongSortType.DATE_ADDED;
  OrderType _orderType = OrderType.ASC_OR_SMALLER;

  // Getter for sortType
  SongSortType get sortType => _sortType;
  OrderType get orderType => _orderType;
  // Method to change the sort type and notify listeners

  void changeOrderType(OrderType orderType) {
    _orderType = orderType;
    notifyListeners();
  }

  void changeSortType(SongSortType sortType) {
    _sortType = sortType;
    notifyListeners(); // Notify listeners of the change
  }
}

class CurrentPlaying extends ChangeNotifier {
  String _current_playing = "";
  String get current_Playing => _current_playing;
  void changeCurrentPlaying(String playing) {
    _current_playing = current_Playing;
    notifyListeners();
  }
}
