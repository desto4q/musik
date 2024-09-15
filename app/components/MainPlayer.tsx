import {
  View,
  Text,
  Image,
  Dimensions,
  TouchableOpacity,
  StatusBar,
} from 'react-native';
import React from 'react';
import {tw} from '../utils/utils';
import {useActiveTrack, useProgress} from 'react-native-track-player';
// import Slider from '@react-native-community/slider';
import CustomTrack from './CustomTrack';
import {useSheet} from '../Context/SheetContext';
let windowHeight = Dimensions.get('window').height;
let windowWidth = Dimensions.get('window').width;
import LinearGradient from 'react-native-linear-gradient';
import MainPlayerControls from './MainPlayerControls';
function convertRgbToRgba(rgb: string, opacity: number) {
  // Extract the RGB values using a regular expression
  const result = rgb.match(/\d+/g);

  if (!result || result.length < 3) {
    // throw new Error('Invalid rgb() string');
    return 'red';
  }

  // Return the RGBA string by appending the opacity
  const [r, g, b] = result;
  return `rgba(${r}, ${g}, ${b}, ${opacity})`;
}
export default function MainPlayer() {
  let track = useActiveTrack();
  let {duration, position} = useProgress();
  let {colorObj} = useSheet();
  return (
    <View
      style={[
        tw(' h-full  gap-4'),
        {
          height: windowHeight,
        },
      ]}>
      <View
        style={[
          tw('  w-full   absolute'),
          {
            height: windowHeight * (6 / 9),
            width: windowWidth,
          },
        ]}>
        <Image
          source={{uri: track?.artwork}}
          style={tw('h-full w-full rounded-md')}
        />
      </View>
      <LinearGradient
        locations={[0, 0.6]}
        colors={[
          convertRgbToRgba(colorObj.background, 0.2),
          colorObj.background,
        ]}
        style={tw('h-full')}>
        <View style={tw('h-4/7 w-full')}></View>
        <View style={tw('gap-1 items-center mt-10')}>
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
        <View style={tw('items-center justify-center py-2')}>
          <CustomTrack />
        </View>
        <MainPlayerControls />
      </LinearGradient>

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
