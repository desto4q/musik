import {createContext, ReactNode, useContext, useEffect} from 'react';
import TrackPlayer, {State} from 'react-native-track-player';

let PlayerContext = createContext<any>(undefined);

let setUp = async () => {
  await TrackPlayer.setupPlayer();
};

let PlayerContextProvider = ({children}: {children: ReactNode}) => {
  useEffect(() => {
    setUp();
  }, []);

  let values = {};
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
