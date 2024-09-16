import React, {useEffect, useState} from 'react';
import {View, Text, TouchableOpacity} from 'react-native';
import {useRoute, RouteProp} from '@react-navigation/native';
import {SafeAreaView} from 'react-native-safe-area-context';
import {useMusicContext} from '../../Context/MusicContext';
import {FasterImageView} from '@candlefinance/faster-image';
import {tw} from '../../utils/utils';
import {ScrollView} from 'react-native-gesture-handler';
import {IAlbumFile, IMusicFile} from '../../utils/types';
import SongCard from '../../components/SongCard';

// Define the route type
type RouteParams = {
  params: IAlbumFile;
};

const AlbumItemScreen: React.FC = () => {
  const route = useRoute<RouteProp<RouteParams, 'params'>>();
  const {musicList} = useMusicContext();
  const [albumItems, setAlbumItems] = useState<IMusicFile[]>([]);
  const item = route.params;

  useEffect(() => {
    if (item) {
      const filteredMusic = musicList.filter(
        track => track.album === item.title,
      );
      setAlbumItems(filteredMusic);
    }
  }, [item, musicList]);

  if (!item) {
    return (
      <SafeAreaView style={tw('flex-1')}>
        <View style={tw('flex-1 justify-center items-center')}>
          <Text>No item found</Text>
        </View>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={tw('flex-1 px-2')}>
      <View style={tw('h-10')} />
      <TouchableOpacity style={tw('p-2')}>
        <Text>log and get</Text>
      </TouchableOpacity>
      <ScrollView contentContainerStyle={{paddingBottom: 90}}>
        <View>
          <FasterImageView
            style={{height: 400}}
            source={{
              url: item.artwork,
              borderRadius: 48,
              resizeMode: 'cover',
            }}
          />
        </View>
        <View style={tw('flex-1 mt-4')}>
          <View style={tw('px-2')}>
            <Text style={tw('text-xl font-bold capitalize')}>{item.title}</Text>
            <Text style={tw('text-neutral-400')}>{item.artist}</Text>
          </View>
          <View style={tw('px-2 mt-4')}>
            <Text style={tw('text-xl font-bold')}>Songs</Text>
          </View>
          <View style={tw('px-2 mt-2')}>
            {musicList.map((itm, index) => {
              if (item.title == itm.album)
                return (
                  <SongCard
                    index={index}
                    key={itm.id}
                    item={itm}
                    title={itm.title}
                    artist={itm.artist}
                    imageUrl={itm.imageUrl}
                  />
                );
            })}
          </View>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};

export default AlbumItemScreen;
