import {View, Text, FlatList} from 'react-native';
import React, {useCallback, useEffect, useState} from 'react';
import {tw} from '../../utils/utils';
import {fetchAudioFiles} from '@gauch_99/react-native-audio-files';
import SongCard from '../../components/SongCard';
import {FlashList} from '@shopify/flash-list';
export default function SongScreen() {
  let [files, setFiles] = useState<any[]>([]);

  let getFiles = async () => {
    const audioFiles = await fetchAudioFiles();
    setFiles(audioFiles);
    return audioFiles;
  };

  useEffect(() => {
    getFiles();
  }, []);
  return (
    <View style={[tw('flex-1  px-2')]}>
     
      <FlashList
        data={files}
        // removeClippedSubviews
        estimatedItemSize={250}
        renderItem={({item, index}) => {
          return (
            <SongCard
              item={item}
              imageUrl={item.imageUrl}
              artist={item.artist}
              title={item.title}
            />
          );
        }}
      />
    </View>
  );
}
