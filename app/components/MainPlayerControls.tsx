import {View, Text} from 'react-native';
import React from 'react';
import {tw} from '../utils/utils';
import {PlayButton} from './buttons/PlayButton';
import NextTrack from './buttons/NextTrack';
import PrevTrack from './buttons/PrevTrack';

export default function MainPlayerControls() {
  return (
    <View style={tw('items-center flex-row w-full justify-center')}>
      <PrevTrack size={28} />
      <PlayButton size={44} />
      <NextTrack size={28} />
    </View>
  );
}
