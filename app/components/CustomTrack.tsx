import React, {useEffect, useState} from 'react';
import {View, Text, LayoutAnimation} from 'react-native';
import {useProgress} from 'react-native-track-player';
import TrackPlayer from 'react-native-track-player';
import {tw} from '../utils/utils';
import {useSheet} from '../Context/SheetContext';
import {Slider} from '@miblanchard/react-native-slider';

let configure = () => {
  LayoutAnimation.configureNext(LayoutAnimation.Presets.easeInEaseOut);
};
export default function CustomTrack() {
  const progress = useProgress();

  // Function to convert seconds to "mm:ss" format
  const formatTime = (seconds: number) => {
    const mins = Math.floor(seconds / 60);
    const secs = Math.floor(seconds % 60);
    return `${mins < 10 ? '0' : ''}${mins}:${secs < 10 ? '0' : ''}${secs}`;
  };

  // Format position and duration
  const position = formatTime(progress.position);
  const duration = formatTime(progress.duration);

  let {colorObj} = useSheet();
  let [sliding, setSliding] = useState(false);
  let [currentPos, setCurrentPos] = useState(0);
  const onEnd = async (e: number[]) => {
    // configure();
    setCurrentPos(e[0]);
    setSliding(false);

    await TrackPlayer.seekTo(e[0]);
  };
  useEffect(() => {}, [currentPos]);
  return (
    <View
      style={tw(
        'w-full max-w-[280px] flex-row items-center justify-center gap-4',
      )}>
      {/* Display formatted position */}
      <Text style={{color: colorObj.text}}>{position}</Text>
      {/* Slider */}
      <Slider
        minimumValue={0}
        onSlidingStart={() => {
          setSliding(true);
          setCurrentPos(progress.position);
        }}
        onSlidingComplete={onEnd}
        containerStyle={tw('flex-1')}
        maximumValue={progress.duration}
        value={sliding ? currentPos : progress.position}
        minimumTrackTintColor={colorObj.text}
        thumbTintColor={colorObj.text}
        maximumTrackTintColor={colorObj.third}
        thumbStyle={{...tw('h-4 w-4 rounded-full')}}
        trackStyle={{
          ...tw('h-1.5'),
        }}
      />
      <Text style={{color: colorObj.text}}>{duration}</Text>
    </View>
  );
}
