import {View, Text, Touchable, TouchableOpacity} from 'react-native';
import React from 'react';
import {tw} from '../utils/utils';
import {FasterImageView} from '@candlefinance/faster-image';
import {useNavigation} from '@react-navigation/native';
import {IMusicFile} from '../utils/types';
import Animated from 'react-native-reanimated';

interface iAlbumCard {
  image: string;
  item: IMusicFile;
  albumName: string;
  artistName: string;
}
export default function AlbumCard({
  image,
  item,
  albumName,
  artistName,
}: iAlbumCard) {
  let navigation = useNavigation();
  let onNav = () => {
    navigation.navigate('albumScreen', item);
  };
  return (
    <TouchableOpacity
      onPress={() => {
        // console.log(item);
        onNav();
      }}
      style={[tw(' flex-1 m-1 gap-2 '), {}]}>
      <FasterImageView
        style={[tw('flex-1'), {height: 170}]}
        source={{url: image, borderRadius: 48, resizeMode: 'cover'}}
      />
      <View style={tw('gap-1 pl-2')}>
        <Text numberOfLines={1} style={tw('font-extrabold text-lg')}>
          {albumName}
        </Text>
        <Text numberOfLines={1} style={tw('text-neutral-500')}>
          {artistName}
        </Text>
      </View>
    </TouchableOpacity>
  );
}
