import {View, Text, Image, TouchableOpacity} from 'react-native';
import React, {useEffect} from 'react';
import {tw} from '../utils/utils';
import TrackPlayer, {useActiveTrack} from 'react-native-track-player';
import {useSheet} from '../Context/SheetContext';
import {PlayButton} from './buttons/PlayButton';

export default function MiniPlayer() {
  let track = useActiveTrack();
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
        <PlayButton size={32} />
      </View>
    </View>
  );
}
