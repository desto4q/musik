import {
  createContext,
  ReactNode,
  RefObject,
  useCallback,
  useContext,
  useEffect,
  useRef,
} from 'react';
import BottomSheet, {BottomSheetView} from '@gorhom/bottom-sheet';
import {StyleSheet, Text} from 'react-native';
import {usePlaybackState} from 'react-native-track-player';

interface ISheetProps {
  bottomSheetRef: RefObject<BottomSheet>;
  handleSheetChanges: (index: number) => any;
}

let SheetContext = createContext<ISheetProps>();
let SheetProvider = ({children}: {children: ReactNode}) => {
  const handleSheetChanges = useCallback((index: number) => {
    console.log('handleSheetChanges', index);
  }, []);
  const bottomSheetRef = useRef<BottomSheet>(null);

  const playerState = usePlaybackState();
  const updateSheet = async () => {
    if (playerState.state == undefined) {
      console.log(playerState);
      return;
    }
    if (playerState.state === 'paused' || playerState.state === 'playing') {
      return;
    } else {
      await bottomSheetRef.current?.snapToIndex(0);
    }
  };
  useEffect(() => {
    updateSheet();
  }, [playerState]);

  useEffect(() => {}, []);
  let values = {bottomSheetRef, handleSheetChanges};

  return (
    <SheetContext.Provider value={values}>{children}</SheetContext.Provider>
  );
};

let useSheet = () => {
  let context = useContext(SheetContext);
  return context;
};

export {useSheet, SheetProvider};
