import {
  Button,
  StyleSheet,
  Text,
  Touchable,
  TouchableOpacity,
  View,
} from 'react-native';
import React, {useCallback, useEffect, useRef, useState} from 'react';
import TrackPlayer, {
  usePlaybackState,
  useProgress,
  State,
} from 'react-native-track-player';
import {tw} from '../../utils/utils';
import CustomTrack from '../../components/CustomTrack';
import {usePlayerContext} from '../../Context/PlayerContext';

export default function SecondRoute() {
  const playerState = usePlaybackState();
  useEffect(() => {
    console.log(playerState.state);
  }, []);
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
      <CustomTrack />
    </View>
  );
}
