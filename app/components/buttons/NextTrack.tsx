import {View, Text, TouchableOpacity} from 'react-native';
import React from 'react';
import {IconPlayerTrackNext} from '@tabler/icons-react-native';
import {tw} from '../../utils/utils';
import {useSheet} from '../../Context/SheetContext';
import {useMusicContext} from '../../Context/MusicContext';
import {PlayTrack} from '../../trackMethods/trackMethods';

export default function NextTrack({size}: {size?: number}) {
  let {colorObj} = useSheet();
  let {setCurrentPlaying, currentPlayingId, musicList} = useMusicContext();
  let onPress = async () => {
    let newId = currentPlayingId + 1;
    await PlayTrack(musicList[newId]);
    setCurrentPlaying(newId);
  };
  return (
    <View>
      <TouchableOpacity style={tw('p-2')} onPress={onPress}>
        <IconPlayerTrackNext
          size={size || 22}
          color={colorObj.text ?? 'white'}
        />
      </TouchableOpacity>
    </View>
  );
}
