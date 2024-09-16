import {View, Text, TouchableOpacity} from 'react-native';
import React from 'react';
import {useMusicContext} from '../../Context/MusicContext';
import {tw} from '../../utils/utils';
import {FlashList} from '@shopify/flash-list';
import AlbumCard from '../../components/AlbumCard';
import {IMusicFile} from '../../utils/types';

export default function AlbumScreen() {
  let {musicList, albumList} = useMusicContext();

  // Remove duplicate albums by filtering unique album names

  return (
    <View style={tw('flex-1')}>
      <TouchableOpacity
        style={tw('p-2')}
        onPress={() => {
          console.log(musicList[0]);
        }}>
        <Text>onCLick</Text>
      </TouchableOpacity>
      <FlashList
        ItemSeparatorComponent={() => {
          return <View style={tw('h-4 flex-1')}></View>;
        }}
        contentContainerStyle={{paddingBottom: 90}} // Added paddingBottom 100 here
        numColumns={2}
        estimatedItemSize={200}
        data={albumList} // Use the unique and sorted list here
        renderItem={({item}) => {
          return (
            <AlbumCard
              artistName={item.artist}
              albumName={item.title}
              image={item.artwork}
              item={item}
            />
          );
        }}
      />
    </View>
  );
}
