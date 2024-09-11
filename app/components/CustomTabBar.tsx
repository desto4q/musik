import {
  View,
  Text,
  TouchableOpacity,
  LayoutAnimation,
  StyleSheet,
  Dimensions,
} from 'react-native';
import React, {useEffect} from 'react';
import {SceneRendererProps, NavigationState} from 'react-native-tab-view';
import {colors, tw} from '../utils/utils';
import {IconAlbum, IconMusic} from '@tabler/icons-react-native';
import BottomSheet, {BottomSheetView} from '@gorhom/bottom-sheet';
import {useSheet} from '../Context/SheetContext';
import MiniPlayer from './MiniPlayer';

interface Route {
  key: string;
  title: string;
}
interface CTB extends SceneRendererProps {
  navigationState: NavigationState<Route>;
}

let iconSize = 22;
let IconColor = 'white';
// You can add additional properties if needed
let Icons = [
  (color?: string) => <IconMusic size={iconSize} color={color || IconColor} />,
  (color?: string) => <IconAlbum size={iconSize} color={color || IconColor} />,
];

let configure = () => {
  LayoutAnimation.configureNext(LayoutAnimation.Presets.easeInEaseOut);
};



let windowheight = Dimensions.get('window').height;
export default function CustomTabBar(e: CTB) {
  useEffect(() => {
    console.log(windowheight);
    // bottomSheetRef.current?.close();
  }, []);

  let {handleSheetChanges, bottomSheetRef} = useSheet();

  return (
    <View
      style={tw('bottom-0 absolute   h-full w-full ')}
      pointerEvents="box-none">
      <View
        style={[
          tw(
            'h-16 flex-row items-center justify-evenly w-full bg-neutral-800 relative mt-auto ',
          ),
          {
            zIndex: 20,
          },
        ]}>
        {e.navigationState.routes.map((item, i) => {
          return (
            <TouchableOpacity
              key={item.key}
              onPress={() => {
                configure();
                e.jumpTo(item.key);
              }}>
              <View
                style={[
                  tw('flex-row gap-2 items-center  p-2 rounded-md'),
                  {
                    backgroundColor:
                      e.navigationState.index == i
                        ? '#dda15e32'
                        : 'transparent',
                  },
                ]}>
                {Icons[i](e.navigationState.index == i ? '#dda15e' : undefined)}
                <Text
                  style={[
                    {
                      color:
                        e.navigationState.index == i ? '#dda15e' : undefined,
                    },
                  ]}>
                  {item.title}
                </Text>
              </View>
            </TouchableOpacity>
          );
        })}
      </View>
      <BottomSheet
        handleComponent={null}
        backgroundStyle={[
          {
            backgroundColor: colors.neutral[900],
          },
        ]}
        ref={bottomSheetRef}
        onChange={handleSheetChanges}
        snapPoints={[160, 800]}>
        <BottomSheetView>
          <MiniPlayer />
        </BottomSheetView>
      </BottomSheet>
    </View>
  );
}
