import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';

class PlayerModel {
  final player = AudioPlayer();
}

class SortModel extends ChangeNotifier {
  SongSortType _sortType = SongSortType.DATE_ADDED;
  OrderType _orderType = OrderType.ASC_OR_SMALLER;

  
  // Getter for sortType
  SongSortType get sortType => _sortType;
  OrderType get orderType => _orderType;
  // Method to change the sort type and notify listeners

  void changeOrderType(OrderType orderType){
    _orderType = orderType;
    notifyListeners();

  }
  void changeSortType(SongSortType sortType) {
    _sortType = sortType;
    notifyListeners(); // Notify listeners of the change
  }
}
