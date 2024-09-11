import {View, Text} from 'react-native';
import React, {useEffect, useState} from 'react';
import Slider from '@react-native-community/slider';
import {useProgress} from 'react-native-track-player';
import TrackPlayer, {State} from 'react-native-track-player';
export default function CustomTrack() {
  const progress = useProgress();

  // let [max, setMax] = useState(progress.duration);
  // useEffect(()=>{},[progress])
  let onEnd = (e: number) => {
    TrackPlayer.seekTo(e);
  };
  return (
    <View>
      <Slider
        minimumValue={0}
        onSlidingComplete={onEnd}
        maximumValue={progress.duration}
        value={progress.position}
        style={{width: 200, height: 40}}
        minimumTrackTintColor="#FFFFFF"
        maximumTrackTintColor="#000000"
      />
      <Text>{progress.position / 60}</Text>
      <Text>{progress.duration / 60}</Text>
    </View>
  );
}
