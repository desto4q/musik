import React from 'react';
import {View, Text, Animated} from 'react-native';
// import Slider from '@react-native-community/slider';
import {useProgress} from 'react-native-track-player';
import TrackPlayer from 'react-native-track-player';
import {tw} from '../utils/utils';
import {Slider} from '@miblanchard/react-native-slider';
import {useSheet} from '../Context/SheetContext';
export default function CustomTrack() {
  const progress = useProgress();
  const onEnd = (e: number[]) => {
    TrackPlayer.seekTo(e[0]);
  };
  const position = (progress.position / 60).toFixed(2);
  const duration = (progress.duration / 60).toFixed(2);
  let {colorObj} = useSheet();
  return (
    <View style={tw('w-full flex-row items-center justify-center gap-2 ')}>
      <Text>{position}</Text>
      <Slider
        minimumValue={0}
        onSlidingComplete={e => {
          onEnd(e);
        }}
        containerStyle={tw('w-4/5 ')}
        maximumValue={progress.duration}
        value={progress.position}
        thumbStyle={tw('h-6 w-6')}
        trackStyle={{
          ...tw('bg-red-200 h-3'),
          backgroundColor: colorObj.text,
        }}
      />

      <Text>{duration}</Text>
    </View>
  );
}
