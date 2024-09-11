import React from 'react';
import {createNativeStackNavigator} from '@react-navigation/native-stack';
import TabNav from './TabNav';
import {themeObj} from '../utils/utils';
let Stack = createNativeStackNavigator();
export default function StackNav() {
  return (
    <Stack.Navigator
      screenOptions={{
        headerShown: false,
        statusBarColor: themeObj.background,
      }}>
      <Stack.Screen name="mainScreen" component={TabNav} />
    </Stack.Navigator>
  );
}
