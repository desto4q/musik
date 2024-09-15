import {View, Text, StatusBar} from 'react-native';
import React from 'react';
import {NavigationState, SceneRendererProps} from 'react-native-tab-view';
import CTBNav from './CTBNav';
import {colors, tw} from '../utils/utils';

interface Route {
  key: string;
  title: string;
}

interface CTB extends SceneRendererProps {
  navigationState: NavigationState<Route>;
}
export default function CustomTabBar(e: CTB) {
  return (
    <View
      style={{
        paddingTop: Number(StatusBar.currentHeight - 10) || 0,
        backgroundColor: colors.neutral[800],
      }}>
      <CTBNav {...e} />
    </View>
  );
}
