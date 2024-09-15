import {View, Text} from 'react-native';
import React from 'react';
import {useRoute, RouteProp} from '@react-navigation/native'; // Import RouteProp to type route
import {IMusicFile} from '../../utils/types'; // Import your IMusicFile interface
import {SafeAreaView} from 'react-native-safe-area-context';
import {useMusicContext} from '../../Context/MusicContext';
import {FlashList} from '@shopify/flash-list';
import {tw} from '../../utils/utils';
import SongCard from '../../components/SongCard';
import {FasterImageView} from '@candlefinance/faster-image';
import {ScrollView} from 'react-native-gesture-handler';
// Define the route type
type RouteParams = {
  params: IMusicFile;
};

export default function AlbumItemScreen() {
  const route = useRoute<RouteProp<RouteParams, 'params'>>(); // Type the route
  const {musicList} = useMusicContext();

  // Safely access item
  const item: IMusicFile | undefined = route.params;

  if (!item) {
    return (
      <View>
        <Text>No item found</Text>
      </View>
    );
  }

  // Filter the musicList for songs with the same album name
  const sameAlbumSongs = musicList.filter(song => song.album === item.album);

  return (
    <SafeAreaView style={[tw('px-2'), {flex: 1}]}>
      <View style={tw('h-10')}></View>

      <ScrollView contentContainerStyle={{paddingBottom: 90}}>
        <View>
          <FasterImageView
            style={[
              tw(''),
              {
                height: 400,
                // width:400
              },
            ]}
            source={{
              url: item.imageUrl,
              borderRadius: 48,
              resizeMode: 'cover',
            }}
          />
        </View>
        <View style={tw('flex-1 gap-2 mt-4')}>
          <View style={tw('px-2 gap-1')}>
            <Text style={tw('text-xl font-bold capitalize')}>{item.album}</Text>
            <Text style={tw('text-neutral-400')}>{item.artist}</Text>
          </View>
          {/* <FlashList
            estimatedItemSize={120}
            data={sameAlbumSongs}
            renderItem={({item}) => {
              return (
                <SongCard
                  item={item}
                  imageUrl={item.imageUrl}
                  artist={item.artist}
                  title={item.title}
                />
              );
            }}
          /> */}
          <View style={tw('px-2')}>
            <Text style={tw('text-xl font-bold')}>Song</Text>
          </View>
          <View>
            {sameAlbumSongs.map(item => {
              return (
                <SongCard
                  key={item.id}
                  item={item}
                  imageUrl={item.imageUrl}
                  artist={item.artist}
                  title={item.title}
                />
              );
            })}
          </View>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}
