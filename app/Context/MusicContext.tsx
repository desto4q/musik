import ds, {fetchAudioFiles} from '@gauch_99/react-native-audio-files';
import {getAlbumsAsync, getGenresAsync} from 'expo-music-library';
import React, {
  createContext,
  Dispatch,
  ReactNode,
  SetStateAction,
  useContext,
  useEffect,
  useState,
} from 'react';

interface IMusicContext {
  musicList: any[];
  albumList: any[];
  currentPlayingId: number;
  setCurrentPlaying: Dispatch<SetStateAction<number>>;
}
interface IMusicProvider {
  children: ReactNode;
}

let MusicContext = createContext<IMusicContext | undefined>(undefined);

let MusicContextProvider = ({children}: IMusicProvider) => {
  let [musicList, setMusicList] = useState<any>([]);
  let [albumList, setAlbumList] = useState<any>([]);
  let [currentPlayingId, setCurrentPlaying] = useState(0);
  let getAlbumFiles = async () => {
    let files = await getAlbumsAsync();
    setAlbumList(files);
  };
  let getFiles = async () => {
    const audioFiles = await fetchAudioFiles();
    setMusicList(audioFiles);
  };

  useEffect(() => {
    getFiles();
    getAlbumFiles();
  }, []);

  useEffect(() => {}, [musicList]);

  let values = {musicList, albumList, setCurrentPlaying, currentPlayingId};
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
