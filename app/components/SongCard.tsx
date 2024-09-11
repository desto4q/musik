import {View, Text, Image, TouchableOpacity} from 'react-native';
import React, {useEffect} from 'react';
import {tw} from '../utils/utils';
import {addToPlayer} from '../trackMethods/trackMethods';

type TSongCard = {
  imageUrl: string;
  title: string;
  artist: string;
  item: any;
};

function SongCard({imageUrl, title, artist, item}: TSongCard) {
  useEffect(() => {
    // You can remove or modify the effect if not necessary.
  }, []);

  return (
    <View>
      <TouchableOpacity
        onPress={async () => {
          await addToPlayer(item);
          // console.log(item);
        }}>
        <View style={tw('flex-row w-full p-2 items-center gap-4')}>
          <Image source={{uri: imageUrl}} style={tw('h-12 w-12 rounded-md')} />
          <View>
            <Text style={tw('text-lg text-neutral-200')}>{title}</Text>
            <Text style={tw('text-neutral-400')}>{artist}</Text>
          </View>
        </View>
      </TouchableOpacity>
    </View>
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
