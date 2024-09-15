import {View, Text, Touchable, TouchableOpacity} from 'react-native';
import React from 'react';
import {useMusicContext} from '../../Context/MusicContext';
import {tw} from '../../utils/utils';
import {FlashList} from '@shopify/flash-list';
import AlbumCard from '../../components/AlbumCard';

export default function AlbumScreen() {
  let {musicList} = useMusicContext();
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
        contentContainerStyle={tw('px-1')}
        numColumns={2}
        estimatedItemSize={200}
        data={musicList}
        renderItem={({item}) => {
          return (
            <AlbumCard
              artistName={item.artist}
              albumName={item.album}
              image={item.imageUrl}
              item={item}
            />
          );
        }}
      />
    </View>
  );
}
