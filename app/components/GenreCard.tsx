import {View, Text, Image, Pressable} from 'react-native';
import React, {useState, useCallback} from 'react';
import {colors, tw} from '../utils/utils';
import {useSheet} from '../Context/SheetContext';
import {PlayTrack} from '../trackMethods/trackMethods';

import {TouchableOpacity} from 'react-native-gesture-handler';
import {useNavigation} from '@react-navigation/native';

type TSongCard = {
  title: string;
  item: any;
};

function GenreCard({title, item}: TSongCard) {
  // Shared value for scale animation
  let navigation = useNavigation();

  // Animated style for scaling

  const playNext = () => {
    navigation.navigate('genreItemScreen', item);
  };

  return (
    <TouchableOpacity onPress={playNext}>
      <View style={tw('flex-row w-full p-2 items-center gap-4')}>
        <View>
          <Text style={tw('text-lg text-neutral-200')}>{title}</Text>
        </View>
      </View>
    </TouchableOpacity>
  );
}

// Wrap SongCard in React.memo to prevent unnecessary re-renders
export default React.memo(GenreCard, (prevProps, nextProps) => {
  return (
    prevProps.title === nextProps.title && prevProps.item === nextProps.item
  );
});
