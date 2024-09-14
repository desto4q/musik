import {
  View,
  Text,
  TouchableOpacity,
  LayoutAnimation,
  StyleSheet,
  Dimensions,
  Animated,
} from 'react-native';
import {colors, tw} from '../utils/utils';
import {NavigationState, SceneRendererProps} from 'react-native-tab-view';
import {IconAlbum, IconMusic} from '@tabler/icons-react-native';
interface Route {
  key: string;
  title: string;
}

interface CTB extends SceneRendererProps {
  navigationState: NavigationState<Route>;
}
const ICON_SIZE = 22;
const ICON_COLOR = 'white';

const ICONS = [
  (color?: string) => (
    <IconMusic size={ICON_SIZE} color={color || ICON_COLOR} />
  ),
  (color?: string) => (
    <IconAlbum size={ICON_SIZE} color={color || ICON_COLOR} />
  ),
];
let CTBNav = (props: CTB) => {
  return (
    <View
      style={[
        tw(
          'h-16 flex-row items-center justify-evenly w-full bg-neutral-800 relative mt-auto',
        ),
        {zIndex: 20},
      ]}>
      {props.navigationState.routes.map((item, i) => (
        <TouchableOpacity
          key={item.key}
          style={tw('px-2  items-center flex-1 py-2')}
          onPress={() => {
            props.jumpTo(item.key);
          }}>
          {ICONS[i](
            props.navigationState.index == i ? colors.orange[400] : 'white',
          )}
        </TouchableOpacity>
      ))}
    </View>
  );
};
export default CTBNav;
