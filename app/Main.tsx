import {View, Text} from 'react-native';
import React from 'react';
import TabViewExample from './nav/TabNav';
import {DarkTheme, NavigationContainer} from '@react-navigation/native';
import {colors, themeObj} from './utils/utils';
import StackNav from './nav/StackNav';
import {useSheet} from './Context/SheetContext';
import BottomSheet, {BottomSheetView} from '@gorhom/bottom-sheet';
import Animated, {
  interpolate,
  useAnimatedStyle,
  useSharedValue,
} from 'react-native-reanimated';
import MiniPlayer from './components/MiniPlayer';
import MainPlayer from './components/MainPlayer';

export default function Main() {
  let {bottomSheetRef, colorObj} = useSheet();

  let myTheme = {
    ...DarkTheme,
    colors: {
      ...DarkTheme.colors,
      background: colors.neutral[900],
    },
  };
  const animVal = useSharedValue(0);

  // Animated style for MiniPlayer
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
    <NavigationContainer theme={myTheme}>
      <StackNav />
      <BottomSheet
        activeOffsetY={[-10, 10]}
        failOffsetX={[-10, 10]}
        ref={bottomSheetRef}
        handleComponent={null}
        style={{
          zIndex: 1, // Ensure zIndex is lower than StackNav
        }}
        backgroundStyle={[
          {
            backgroundColor: colorObj.background,
          },
        ]}
        snapPoints={[90, '100%']}
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
    </NavigationContainer>
  );
}
