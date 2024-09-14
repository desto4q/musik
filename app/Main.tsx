import {View, Text} from 'react-native';
import React from 'react';
import TabViewExample from './nav/TabNav';
import {DarkTheme, NavigationContainer} from '@react-navigation/native';
import {themeObj} from './utils/utils';
import StackNav from './nav/StackNav';
import {useSheet} from './Context/SheetContext';

export default function Main() {
  let {colorObj} = useSheet();

  let myTheme = {
    ...DarkTheme,
    colors: {
      ...DarkTheme.colors,
    },
  };
  return (
    <NavigationContainer theme={myTheme}>
      <StackNav />
    </NavigationContainer>
  );
}
