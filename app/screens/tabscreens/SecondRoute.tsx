import {
  Dimensions,
  LayoutAnimation,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import React, {useCallback, useEffect, useRef, useState} from 'react';
import TrackPlayer, {useActiveTrack} from 'react-native-track-player';
import {
  convertContentUriToFileUri,
  generatePalette,
  tw,
} from '../../utils/utils';
import CustomTrack from '../../components/CustomTrack';
// import {
//   getPalette,
//   getAverageColor,
//   getSegmentsAverageColor,
//   getSegmentsPalette,
// } from '@somesoap/react-native-image-palette';
import {useSheet} from '../../Context/SheetContext';
import RNColorThief from 'react-native-color-thief';
let height = Dimensions.get('window').height;
let configure = async () => {
  LayoutAnimation.configureNext(LayoutAnimation.Presets.easeInEaseOut);
};
export default function SecondRoute() {
  let track = useActiveTrack();
  let {bottomSheetRef, colorObj, setObj} = useSheet();

  let gen = async () => {
    if (track?.artwork) {
      try {
        let content_uri = track.artwork;
        let pals = await generatePalette(content_uri);
        // console.log(pals);
        let newObj = {
          ...colorObj,
          background: pals[0],
          text: pals[1],
        };
        setObj(newObj);
        return;
      } catch (err) {
        console.log(err);
      }
    }
  };
  useEffect(() => {
    gen();
  }, [track]);
  useEffect(() => {
    console.log('height', height - 140);
  }, []);
  return (
    <View style={tw('flex-1')}>
      {/* <Text>{isPlaying ? 'playing' : 'not playing'}</Text> */}
      <TouchableOpacity
        style={tw('p-2')}
        onPress={() => {
          // console.log(progress.position);
          TrackPlayer.pause();
          // present();
        }}>
        <Text>stop</Text>
      </TouchableOpacity>
      <TouchableOpacity
        style={tw('p-2')}
        onPress={() => {
          TrackPlayer.play();
        }}>
        <Text>Play</Text>
      </TouchableOpacity>

      <CustomTrack />
      <Text>{track?.artist}</Text>
    </View>
  );
}
