import {
  Children,
  createContext,
  ReactNode,
  useContext,
  useEffect,
  useState,
} from 'react';
import TrackPlayer, {
  Event,
  usePlaybackState,
  useProgress,
  useTrackPlayerEvents,
} from 'react-native-track-player';


let PlayerContext = createContext<any>(undefined);
const events = [Event.PlaybackState, Event.PlaybackError];
let setUp = async () => {
  await TrackPlayer.setupPlayer();
};
let PlayerContextProvider = ({children}: {children: ReactNode}) => {
  useEffect(() => {
    setUp();
  }, []);

  let progress = useProgress();
  let values = {progress};
  return (
    <PlayerContext.Provider value={values}>{children}</PlayerContext.Provider>
  );
};

let usePlayerContext = () => {
  let context = useContext(PlayerContext);

  if (!context) {
    throw new Error('wrap in provider');
  }
  return context;
};

export {PlayerContext, PlayerContextProvider, usePlayerContext};
