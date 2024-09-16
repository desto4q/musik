import {TouchableOpacity, View} from 'react-native';
import TrackPlayer, {usePlaybackState} from 'react-native-track-player';
import {useSheet} from '../../Context/SheetContext';
import {tw} from '../../utils/utils';
import {IconPlayerPause, IconPlayerPlay} from '@tabler/icons-react-native';

let PlayButton = ({size}: {size?: number}) => {
  const playerState = usePlaybackState();
  let {colorObj} = useSheet();

  let pauseOrPlay = async () => {
    if (playerState.state == 'playing') {
      return await TrackPlayer.pause();
    }
    return await TrackPlayer.play();
  };
  return (
    <View style={tw('items-center justify-center')}>
      <TouchableOpacity
        style={tw('p-2')}
        onPress={async () => {
          await pauseOrPlay();
        }}>
        {playerState.state == 'playing' ? (
          <IconPlayerPause size={size || 22} color={colorObj.text ?? 'white'} />
        ) : (
          <IconPlayerPlay size={size || 22} color={colorObj.text ?? 'white'} />
        )}
      </TouchableOpacity>
    </View>
  );
};

export {PlayButton};
