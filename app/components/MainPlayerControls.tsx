import {View, Text} from 'react-native';
import React from 'react';
import {tw} from '../utils/utils';
import {PlayButton} from './buttons/PlayButton';

export default function MainPlayerControls() {
  return (
    <View style={tw('items-center flex-row w-full justify-center')}>
      <PlayButton size={44} />
    </View>
  );
}
