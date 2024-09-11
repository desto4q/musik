import {View, Text} from 'react-native';
import React from 'react';
import TabViewExample from './nav/TabNav';
import {DarkTheme, NavigationContainer} from '@react-navigation/native';
import {themeObj} from './utils/utils';
import StackNav from './nav/StackNav';
let myTheme = {
  ...DarkTheme,
  colors: {
    ...DarkTheme.colors,
    background: themeObj.background,
  },
};
export default function Main() {
  return (
    <NavigationContainer theme={myTheme}>
      <StackNav />
    </NavigationContainer>
  );
}
