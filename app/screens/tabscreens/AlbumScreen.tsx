import {View, Text, TouchableOpacity} from 'react-native';
import React from 'react';
import {useMusicContext} from '../../Context/MusicContext';
import {tw} from '../../utils/utils';
import {FlashList} from '@shopify/flash-list';
import AlbumCard from '../../components/AlbumCard';
import {IMusicFile} from '../../utils/types';

export default function AlbumScreen() {
  let {musicList} = useMusicContext();

  // Remove duplicate albums by filtering unique album names
  const uniqueAlbums: IMusicFile[] = [...musicList].reduce((acc, current) => {
    const albumExists = acc.find(item => item.album === current.album);
    if (!albumExists) {
      acc.push(current);
    }
    return acc;
  }, []);

  // Sort the unique albums alphabetically
  const sortedUniqueAlbums: IMusicFile[] = uniqueAlbums.sort((a, b) => {
    if (a.album < b.album) {
      return -1;
    }
    if (a.album > b.album) {
      return 1;
    }
    return 0;
  });

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
        contentContainerStyle={{paddingBottom:90}} // Added paddingBottom 100 here
        numColumns={2}
        estimatedItemSize={200}
        data={sortedUniqueAlbums} // Use the unique and sorted list here
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
