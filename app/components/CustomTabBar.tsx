import {View, Text} from 'react-native';
import React from 'react';
import {NavigationState, SceneRendererProps} from 'react-native-tab-view';
import CTBNav from './CTBNav';

interface Route {
  key: string;
  title: string;
}

interface CTB extends SceneRendererProps {
  navigationState: NavigationState<Route>;
}
export default function CustomTabBar(e: CTB) {
  return (
    <View>
      <CTBNav {...e} />
    </View>
  );
}
