import React from 'react';
import {createNativeStackNavigator} from '@react-navigation/native-stack';
import TabNav from './TabNav';
import {themeObj} from '../utils/utils';
import {useSheet} from '../Context/SheetContext';
let Stack = createNativeStackNavigator();
export default function StackNav() {
  let {colorObj} = useSheet();
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
