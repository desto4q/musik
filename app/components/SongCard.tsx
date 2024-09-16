import {View, Text, Image, Pressable} from 'react-native';
import React, {useState, useCallback} from 'react';
import {colors, tw} from '../utils/utils';
import {useSheet} from '../Context/SheetContext';
import {PlayTrack} from '../trackMethods/trackMethods';
import Animated, {
  Easing,
  useSharedValue,
  useAnimatedStyle,
  withSpring,
} from 'react-native-reanimated';
import {TouchableOpacity} from 'react-native-gesture-handler';
import {FasterImageView, clearCache} from '@candlefinance/faster-image';
import {useMusicContext} from '../Context/MusicContext';

type TSongCard = {
  imageUrl: string;
  title: string;
  artist: string;
  item: any;
  index: number;
};

function SongCard({imageUrl, title, artist, item, index}: TSongCard) {
  let {currentPlayingId, setCurrentPlaying} = useMusicContext();
  let {musicList} = useMusicContext();
  const playNext = useCallback(async () => {
    try {
      await PlayTrack(musicList[index]);
      setCurrentPlaying(index);
    } catch (err) {}
  }, [item]);

  return (
    <TouchableOpacity onPress={playNext}>
      <View style={tw('flex-row w-full p-2 items-center gap-4')}>
        <FasterImageView
          source={{url: imageUrl, borderRadius: 8}}
          style={{
            height: 48,
            width: 48,
          }}
        />
        <View>
          <Text style={tw('text-lg text-neutral-200')}>{title}</Text>
          <Text style={tw('text-neutral-400')}>{artist}</Text>
        </View>
      </View>
    </TouchableOpacity>
  );
}

// Wrap SongCard in React.memo to prevent unnecessary re-renders
// export default React.memo(SongCard, (prevProps, nextProps) => {
//   return (
//     prevProps.imageUrl === nextProps.imageUrl &&
//     prevProps.title === nextProps.title &&
//     prevProps.artist === nextProps.artist &&
//     prevProps.item === nextProps.item
//   );
// });

export default SongCard;
