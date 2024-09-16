import React from 'react';
import {createNativeStackNavigator} from '@react-navigation/native-stack';
import TabNav from './TabNav';
import {themeObj, tw} from '../utils/utils';
import {useSheet} from '../Context/SheetContext';
import AlbumItemScreen from '../screens/stackScreens/AlbumItemScreen';
import LyricScreen from '../screens/stackScreens/LyricScreen';
import {View} from 'react-native-reanimated/lib/typescript/Animated';
let Stack = createNativeStackNavigator();
export default function StackNav() {
  let {colorObj} = useSheet();
  return (
    <Stack.Navigator
      screenOptions={{
        headerShown: false,
        statusBarTranslucent: true,
        statusBarColor: 'transparent',
        // contentStyle: {paddingBottom: 190},
      }}>
      <Stack.Screen name="mainScreen" component={TabNav} />
      <Stack.Screen name="albumScreen" component={AlbumItemScreen} />
      <Stack.Screen name="lyricScreen" component={LyricScreen} />
    </Stack.Navigator>
  );
}
