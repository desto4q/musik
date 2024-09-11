import {View, Text, Image, Touchable, TouchableOpacity} from 'react-native';
import React, {useEffect} from 'react';
import {tw} from '../utils/utils';
import TrackPlayer, {
  useActiveTrack,
  usePlaybackState,
  useProgress,
} from 'react-native-track-player';
import {Circle, G, Svg} from 'react-native-svg';
import {IconPlayerPause, IconPlayerPlay} from '@tabler/icons-react-native';

export default function MiniPlayer() {
  let track = useActiveTrack();
  let {duration, position} = useProgress();
  useEffect(() => {
    console.log(track);
  }, []);
  return (
    <View style={tw('h-22 items-center flex-row px-4 py-2 gap-4')}>
      <Image
        style={tw('h-12 w-12 bg-red-200 rounded-md')}
        source={{uri: track?.artwork}}></Image>
      <View>
        <Text style={tw('text-lg')}>{track?.title}</Text>
        <Text>{track?.artist}</Text>
      </View>
      <View style={tw('ml-auto')}>
        <CircularProgress
          progress={position}
          max={duration }
          size={36}
          strokeWidth={2}
        />
      </View>
    </View>
  );
}

type CircularProgressProps = {
  size: number; // Diameter of the circle
  strokeWidth: number; // Thickness of the progress bar
  progress: number; // Current progress value
  min?: number; // Minimum progress value (default: 0)
  max?: number; // Maximum progress value (default: 100)
};

function CircularProgress({
  size,
  strokeWidth,
  progress,
  min = 0,
  max = 100,
}: CircularProgressProps) {
  // Ensure progress is between min and max
  const clampedProgress = Math.max(min, Math.min(progress, max));

  // Map progress to a percentage (0 to 100)
  const normalizedProgress = ((clampedProgress - min) / (max - min)) * 100;

  const radius = (size - strokeWidth) / 2;
  const circumference = 2 * Math.PI * radius;
  const strokeDashoffset =
    circumference - (circumference * normalizedProgress) / 100;
  const playerState = usePlaybackState();

  let pauseOrPlay = async () => {
    if (playerState.state == 'playing') {
      return await TrackPlayer.pause();
    }
    return await TrackPlayer.play();
  };
  return (
    <View style={tw('items-center justify-center')}>
      <Svg width={size} height={size}>
        <G rotation="-90" origin={`${size / 2}, ${size / 2}`}>
          {/* Background Circle */}
          <Circle
            stroke="#e6e7e8"
            cx={size / 2}
            cy={size / 2}
            r={radius}
            strokeWidth={strokeWidth}
            fill="none"
          />
          {/* Progress Circle */}
          <Circle
            stroke="#3b5998"
            cx={size / 2}
            cy={size / 2}
            r={radius}
            strokeWidth={strokeWidth}
            fill="none"
            strokeDasharray={circumference}
            strokeDashoffset={strokeDashoffset}
            strokeLinecap="round" // Optional, gives rounded edges
          />
        </G>
      </Svg>
      <View style={tw('absolute p-2 ')}>
        <TouchableOpacity
          onPress={async () => {
            await pauseOrPlay();
          }}>
          {playerState.state == 'paused' ? (
            <IconPlayerPlay size={22} color={'white'} />
          ) : (
            <IconPlayerPause size={22} color={'white'} />
          )}
        </TouchableOpacity>
      </View>
    </View>
  );
}
