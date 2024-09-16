import React, {useEffect, useState} from 'react';
import {Dimensions, View} from 'react-native';
import {TabView, SceneMap} from 'react-native-tab-view';
import SecondRoute from '../screens/tabscreens/SecondRoute';
import SongScreen from '../screens/tabscreens/SongScreen';
import CustomTabBar from '../components/CustomTabBar';
import Animated, {
  useSharedValue,
  useAnimatedStyle,
  interpolate,
} from 'react-native-reanimated';

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

  useEffect(() => {
    // console.log('background, nav', colorObj.background);
  }, []);

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

      {/* Animated View controlled by animVal */}
      {/* MiniPlayer view */}
    </View>
  );
}
