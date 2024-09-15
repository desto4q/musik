import {fetchAudioFiles} from '@gauch_99/react-native-audio-files';
import React, {
  createContext,
  ReactNode,
  useContext,
  useEffect,
  useState,
} from 'react';

interface IMusicContext {
  musicList: any[];
  albumList: any[];
}
interface IMusicProvider {
  children: ReactNode;
}

let MusicContext = createContext<IMusicContext | undefined>(undefined);

let MusicContextProvider = ({children}: IMusicProvider) => {
  let [musicList, setMusicList] = useState<any>([]);
  let [albumList, setAlbumList] = useState<any>({}); // Updated initial state to an empty object

  let getFiles = async () => {
    const audioFiles = await fetchAudioFiles();
    setMusicList(audioFiles);
  };

  useEffect(() => {
    getFiles();
  }, []);

  useEffect(() => {
   
  }, [musicList]);

  let values = {musicList, albumList};
  return (
    <MusicContext.Provider value={values}>{children}</MusicContext.Provider>
  );
};

let useMusicContext = () => {
  let context = useContext(MusicContext);
  if (!context) {
    throw new Error('wrap in context');
  }
  return context;
};

export {useMusicContext, MusicContextProvider};
