import {View, Text, Image, Dimensions, TouchableOpacity} from 'react-native';
import React from 'react';
import {tw} from '../utils/utils';
import {useActiveTrack, useProgress} from 'react-native-track-player';
import Slider from '@react-native-community/slider';
import CustomTrack from './CustomTrack';
import {useSheet} from '../Context/SheetContext';
let windowHeight = Dimensions.get('window').height;
export default function MainPlayer() {
  let track = useActiveTrack();
  let {duration, position} = useProgress();
  let {colorObj} = useSheet();
  return (
    <View
      style={[
        tw('p-2 px-4 h-full gap-4'),
        {
          height: windowHeight,
        },
      ]}>
      <View style={tw('mt-4')}></View>
      <View style={tw(' h-1/2 w-full')}>
        <Image
          source={{uri: track?.artwork}}
          style={tw('h-full w-full rounded-md')}
        />
      </View>
      <View style={tw('flex-row items-center justify-between')}>
        <View></View>
        <View style={tw('gap-1 items-center')}>
          <Text
            style={[
              tw('text-xl'),
              {
                color: colorObj.text,
              },
            ]}>
            {track?.title}
          </Text>
          <Text
            style={{
              color: colorObj.text,
            }}>
            {track?.artist}
          </Text>
        </View>
        <View></View>
      </View>
      <View style={tw('items-center justify-center py-2')}>
        <CustomTrack />
      </View>
      <TouchableOpacity
        style={tw('p-2')}
        onPress={() => {
          console.log('click');
        }}>
        <Text>lsa</Text>
      </TouchableOpacity>
    </View>
  );
}
