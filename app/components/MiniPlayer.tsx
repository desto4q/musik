import {
  View,
  Text,
  Image,
  Touchable,
  TouchableOpacity,
  Animated,
} from 'react-native';
import React, {useEffect} from 'react';
import {tw} from '../utils/utils';
import TrackPlayer, {
  useActiveTrack,
  usePlaybackState,
  useProgress,
} from 'react-native-track-player';
import {Circle, G, Svg} from 'react-native-svg';
import {IconPlayerPause, IconPlayerPlay} from '@tabler/icons-react-native';
import {useSheet} from '../Context/SheetContext';

export default function MiniPlayer() {
  let track = useActiveTrack();
  let {duration, position} = useProgress();
  let {bottomSheetRef, colorObj} = useSheet();

  useEffect(() => {
    console.log(track);
  }, []);
  let openModal = () => {
    bottomSheetRef.current?.expand();
  };
  return (
    <View style={tw('h-22 items-center flex-row px-4 py-2 gap-4')}>
      <TouchableOpacity
        style={tw('flex-row gap-4 flex-1')}
        onPress={() => {
          // modalizeRef.current?.open('top');
          openModal();
        }}>
        {track?.artwork ? (
          <Image
            style={tw('h-12 w-12 rounded-md')}
            source={{uri: track?.artwork}}></Image>
        ) : (
          <View style={tw('h-12 w-12  rounded-md')}></View>
        )}
        <View>
          <Text
            numberOfLines={1}
            style={[
              tw('text-lg'),
              {
                color: colorObj.text,
              },
            ]}>
            {track?.title}
          </Text>
          <Text
            style={{
              color: colorObj.text,
            }}>
            {track?.artist}
          </Text>
        </View>
      </TouchableOpacity>
      <View style={tw('ml-auto')}>
        <CircularProgress
          progress={position}
          max={duration}
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

  const playerState = usePlaybackState();

  let pauseOrPlay = async () => {
    console.log('cl');
    if (playerState.state == 'playing') {
      return await TrackPlayer.pause();
    }
    return await TrackPlayer.play();
  };
  let {colorObj} = useSheet();
  return (
    <View style={tw('items-center justify-center')}>
      <TouchableOpacity
        style={tw('p-2')}
        onPress={async () => {
          await pauseOrPlay();
        }}>
        {playerState.state == 'paused' ? (
          <IconPlayerPlay size={22} color={colorObj.text ?? 'white'} />
        ) : (
          <IconPlayerPause size={22} color={colorObj.text ?? 'white'} />
        )}
      </TouchableOpacity>
    </View>
  );
}
