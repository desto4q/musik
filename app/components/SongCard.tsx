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

type TSongCard = {
  imageUrl: string;
  title: string;
  artist: string;
  item: any;
};

function SongCard({imageUrl, title, artist, item}: TSongCard) {
  // Shared value for scale animation
  const scale = useSharedValue(1);

  // Animated style for scaling
  const animatedStyle = useAnimatedStyle(() => {
    return {
      transform: [{scale: scale.value}],
    };
  });

  // Function to handle press and play track
  const playNext = useCallback(async () => {
    scale.value = withSpring(0.95, {damping: 2, stiffness: 100}, () => {
      scale.value = withSpring(1);
    });
    try {
      await PlayTrack(item).then(async res => {});
    } catch (err) {}
  }, [item, scale]);

  return (
    <Pressable onPress={playNext}>
      <Animated.View style={[animatedStyle]}>
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
      </Animated.View>
    </Pressable>
  );
}

// Wrap SongCard in React.memo to prevent unnecessary re-renders
export default React.memo(SongCard, (prevProps, nextProps) => {
  return (
    prevProps.imageUrl === nextProps.imageUrl &&
    prevProps.title === nextProps.title &&
    prevProps.artist === nextProps.artist &&
    prevProps.item === nextProps.item
  );
});
