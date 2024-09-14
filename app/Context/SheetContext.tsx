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
import {Animated, StyleSheet, Text} from 'react-native';
import {usePlaybackState} from 'react-native-track-player';
import BottomSheet, {BottomSheetView} from '@gorhom/bottom-sheet';
import {colors} from '../utils/utils';

type TcolObj = {
  background: string;
  text: string;
};
interface ISheetProps {
  bottomSheetRef: RefObject<BottomSheet>;
  colorObj: TcolObj;
  setObj: Dispatch<SetStateAction<TcolObj>>;
}

let SheetContext = createContext<ISheetProps | undefined>(undefined); // Initialize as undefined to catch errors
let tmp = {
  background: colors.neutral[900], // Fallback in case colors.neutral is undefined
  text: colors.neutral[400], // Fallback in case colors.neutral is undefined
};
let SheetProvider = ({children}: {children: ReactNode}) => {
  const bottomSheetRef = useRef<BottomSheet>(null);

  let [colorObj, setObj] = useState<TcolObj>(tmp);

  useEffect(() => {
    setObj(tmp);
  }, [tmp]); // Add colorObj as a dependency to track changes

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
