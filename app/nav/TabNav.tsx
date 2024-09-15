import React, {useEffect, useState} from 'react';
import {Dimensions, View} from 'react-native';
import {TabView, SceneMap} from 'react-native-tab-view';
import SecondRoute from '../screens/tabscreens/SecondRoute';
import SongScreen from '../screens/tabscreens/SongScreen';
import CustomTabBar from '../components/CustomTabBar';
import BottomSheet, {BottomSheetView} from '@gorhom/bottom-sheet';
import Animated, {
  useSharedValue,
  useAnimatedStyle,
  interpolate,
} from 'react-native-reanimated';
import MiniPlayer from '../components/MiniPlayer';
import MainPlayer from '../components/MainPlayer';
import {tw} from '../utils/utils';
import {useSheet} from '../Context/SheetContext';
import AlbumScreen from '../screens/tabscreens/AlbumScreen';

let width = Dimensions.get('window').width;

const renderScene = SceneMap({
  first: SongScreen,
  second: AlbumScreen,
  third: SecondRoute,
});

const routes = [
  {key: 'first', title: 'Song'},
  {key: 'second', title: 'Album'},
  {key: 'third', title: 'Test'},
];

export default function TabNav() {
  const [index, setIndex] = useState(0);

  const animVal = useSharedValue(0);
  let {bottomSheetRef, colorObj} = useSheet();
  useEffect(() => {
    // console.log('background, nav', colorObj.background);
  }, []);

  const miniPlayerStyle = useAnimatedStyle(() => {
    return {
      opacity: interpolate(animVal.value, [0, 1], [1, 0]), // Fade out mini player
      transform: [
        {
          scale: interpolate(animVal.value, [0, 1], [1, 0.8]), // Slightly shrink as it fades out
        },
      ],
    };
  });

  // Animated style for MainPlayer
  const mainPlayerStyle = useAnimatedStyle(() => {
    return {
      opacity: interpolate(animVal.value, [0, 1], [0, 1]), // Fade in main player
      transform: [
        {
          scale: interpolate(animVal.value, [0, 1], [0.8, 1]), // Scale up as it fades in
        },
      ],
    };
  });

  return (
    <View style={{flex: 1}}>
      <TabView
        style={{flex: 1}}
        renderTabBar={e => <CustomTabBar {...e} />}
        tabBarPosition="top"
        navigationState={{index, routes}}
        renderScene={renderScene}
        onIndexChange={setIndex}
        initialLayout={{width}}
      />

      {/* BottomSheet */}
      <BottomSheet
        activeOffsetY={[-1, 1]}
        failOffsetX={[-5, 5]}
        ref={bottomSheetRef}
        handleComponent={null}
        backgroundStyle={[
          {
            backgroundColor: colorObj.background,
          },
        ]}
        snapPoints={[100, '100%']}
        animatedIndex={animVal}
        enablePanDownToClose={false}>
        <BottomSheetView renderToHardwareTextureAndroid>
          <Animated.View
            style={[
              {position: 'absolute', top: 0, left: 0, right: 0, height: 120},
              miniPlayerStyle,
            ]}>
            <MiniPlayer />
          </Animated.View>

          {/* MainPlayer view */}
          <Animated.View
            style={[
              {
                top: 0,
                left: 0,
                right: 0,
                height: '100%',
              },
              mainPlayerStyle,
            ]}>
            <MainPlayer />
          </Animated.View>
          {/* Any content inside the animated view */}
        </BottomSheetView>
      </BottomSheet>

      {/* Animated View controlled by animVal */}
      {/* MiniPlayer view */}
    </View>
  );
}
