import {Dimensions, Text, TouchableOpacity, View} from 'react-native';
import React, {useCallback, useEffect, useRef, useState} from 'react';
import TrackPlayer, {useActiveTrack} from 'react-native-track-player';
import {tw} from '../../utils/utils';
import CustomTrack from '../../components/CustomTrack';

import {useSheet} from '../../Context/SheetContext';

export default function SecondRoute() {
  let track = useActiveTrack();
  let {bottomSheetRef, colorObj, setObj} = useSheet();

  useEffect(() => {}, []);
  return (
    <View style={tw('flex-1')}>
      {/* <Text>{isPlaying ? 'playing' : 'not playing'}</Text> */}
      <TouchableOpacity
        style={tw('p-2')}
        onPress={() => {
          // console.log(progress.position);
          TrackPlayer.pause();
          // present();
        }}>
        <Text>stop</Text>
      </TouchableOpacity>
      <TouchableOpacity
        style={tw('p-2')}
        onPress={() => {
          TrackPlayer.play();
        }}>
        <Text>Play</Text>
      </TouchableOpacity>
      <TouchableOpacity
        style={tw('p-2')}
        onPress={() => {
          // getMusicFiles()
        }}>
        <Text>logger</Text>
      </TouchableOpacity>
      <CustomTrack />
      <Text>{track?.artist}</Text>
    </View>
  );
}
