import {View, Text, TouchableOpacity} from 'react-native';
import React from 'react';
import {
  IconPlayerTrackNext,
  IconPlayerTrackPrev,
} from '@tabler/icons-react-native';
import {tw} from '../../utils/utils';
import {useSheet} from '../../Context/SheetContext';
import {useMusicContext} from '../../Context/MusicContext';
import {PlayTrack} from '../../trackMethods/trackMethods';
import TrackPlayer, {useProgress} from 'react-native-track-player';

export default function PrevTrack({size}: {size?: number}) {
  let {colorObj} = useSheet();
  let {position} = useProgress();
  let {currentPlayingId, musicList, setCurrentPlaying} = useMusicContext();
  let onPress = async () => {
    if (Number(position) > 10) {
      await TrackPlayer.seekTo(0);
      return;
    }

    let newId = currentPlayingId - 1;
    await PlayTrack(musicList[newId]);
    setCurrentPlaying(newId);
    return;
  };
  return (
    <View>
      <TouchableOpacity style={tw('p-2')} onPress={onPress}>
        <IconPlayerTrackPrev
          size={size || 22}
          color={colorObj.text ?? 'white'}
        />
      </TouchableOpacity>
    </View>
  );
}
