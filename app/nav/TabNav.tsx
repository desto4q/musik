import * as React from 'react';
import {Dimensions, useWindowDimensions, View} from 'react-native';
import {
  TabView,
  SceneMap,
  SceneRendererProps,
  NavigationState,
} from 'react-native-tab-view';
import SecondRoute from '../screens/tabscreens/SecondRoute';
import SongScreen from '../screens/tabscreens/SongScreen';
import CustomTabBar from '../components/CustomTabBar';
let width = Dimensions.get('window').width;
const renderScene = SceneMap({
  first: SongScreen,
  second: SecondRoute,
});

const routes = [
  {key: 'first', title: 'Song'},
  {key: 'second', title: 'Album'},
];

export default function TabNav() {
  const layout = useWindowDimensions();
  const [index, setIndex] = React.useState(0);

  return (
    <TabView
      renderTabBar={e => {
        return <CustomTabBar {...e} />;
      }}
      // swipeEnabled={false}
      tabBarPosition="bottom"
      navigationState={{index, routes}}
      renderScene={renderScene}
      onIndexChange={setIndex}
      initialLayout={{width: width}}
    />
  );
}
