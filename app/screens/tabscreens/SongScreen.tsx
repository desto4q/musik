import {View, StatusBar, Touchable, TouchableOpacity, Text} from 'react-native';
import React, {useEffect, useState} from 'react';
import {tw} from '../../utils/utils';
import {fetchAudioFiles} from '@gauch_99/react-native-audio-files';
import SongCard from '../../components/SongCard';
import {FlashList} from '@shopify/flash-list';
import {useMusicContext} from '../../Context/MusicContext';

export default function SongScreen() {
  let {musicList} = useMusicContext();
  return (
    <View style={[tw('flex-1')]}>
      {/* <TouchableOpacity
        style={[tw('p-2')]}
        onPress={() => {
          console.log(musicList[0]);
        }}>
        <Text>click me</Text>
      </TouchableOpacity> */}
      {/* <StatusBar translucent backgroundColor="transparent" /> */}
      <FlashList
        data={musicList}
        estimatedItemSize={52}
        renderItem={({item, index}) => {
          return (
            <SongCard
              index={index}
              item={item}
              imageUrl={item.imageUrl}
              artist={item.artist}
              title={item.title}
            />
          );
        }}
      />
    </View>
  );
}
