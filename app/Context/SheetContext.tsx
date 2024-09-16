import {
  createContext,
  Dispatch,
  ReactNode,
  RefObject,
  SetStateAction,
  useContext,
  useEffect,
  useRef,
  useState,
} from 'react';
import {Animated, LayoutAnimation, StyleSheet, Text} from 'react-native';
import {useActiveTrack, usePlaybackState} from 'react-native-track-player';
import BottomSheet, {BottomSheetView} from '@gorhom/bottom-sheet';
import {colors, generatePalette} from '../utils/utils';

type TcolObj = {
  background: string;
  text: string;
  third: string;
};
interface ISheetProps {
  bottomSheetRef: RefObject<BottomSheet>;
  colorObj: TcolObj;
  setObj: Dispatch<SetStateAction<TcolObj>>;
}

let SheetContext = createContext<ISheetProps | undefined>(undefined); // Initialize as undefined to catch errors
let tmp = {
  background: colors.neutral[900], // Fallback in case colors.neutral is undefined
  text: colors.neutral[400],
  third: colors.neutral[600], // Fallback in case colors.neutral is undefined
};
let configure = () => {
  LayoutAnimation.configureNext(LayoutAnimation.Presets.easeInEaseOut);
};
let SheetProvider = ({children}: {children: ReactNode}) => {
  const bottomSheetRef = useRef<BottomSheet>(null);

  let [colorObj, setObj] = useState<TcolObj>(tmp);
  let track = useActiveTrack();
  let gen = async () => {
    if (track?.artwork) {
      try {
        let content_uri = track.artwork;
        let pals = await generatePalette(content_uri);
        // console.log(pals);
        let newObj = {
          ...colorObj,
          background: pals[0],
          text: pals[1],
          third: pals[2],
        };
        setObj(newObj);
        return;
      } catch (err) {
        console.log(err);
      }
    }
  };
  useEffect(() => {
    configure();
    gen();
  }, [track]);
  // useEffect(() => {
  //   setObj(tmp);
  // }, [tmp]);

  let values = {bottomSheetRef, colorObj, setObj};

  return (
    <SheetContext.Provider value={values}>{children}</SheetContext.Provider>
  );
};

let useSheet = () => {
  let context = useContext(SheetContext);
  if (!context) {
    throw new Error('useSheet must be used within a SheetProvider');
  }
  return context;
};

export {useSheet, SheetProvider};
