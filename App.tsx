import {View, Text, Platform, UIManager} from 'react-native';
import React, {useEffect} from 'react';
import Main from './app/Main';
import TrackPlayer from 'react-native-track-player';
import {PlayerContextProvider} from './app/Context/PlayerContext';
import {GestureHandlerRootView} from 'react-native-gesture-handler';
import {SheetProvider} from './app/Context/SheetContext';
import {MusicContextProvider} from './app/Context/MusicContext';

if (Platform.OS === 'android') {
  if (UIManager.setLayoutAnimationEnabledExperimental) {
    UIManager.setLayoutAnimationEnabledExperimental(true);
  }
}

export default function App() {
  return (
    <GestureHandlerRootView>
      <MusicContextProvider>
        <PlayerContextProvider>
          <SheetProvider>
            <Main />
          </SheetProvider>
        </PlayerContextProvider>
      </MusicContextProvider>
    </GestureHandlerRootView>
  );
}
