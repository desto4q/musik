import {View, Text, FlatList} from 'react-native';
import React, {useEffect, useState} from 'react';
import {tw} from '../../utils/utils';
import {fetchAudioFiles} from '@gauch_99/react-native-audio-files';
import SongCard from '../../components/SongCard';

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
    <View style={[tw('flex-1 px-2')]}>
      <FlatList
        data={files}
        contentContainerStyle={tw('gap-2')}
        keyExtractor={(item) => item.id.toString()}
        renderItem={({item}) => {
          
          return (
            <SongCard
              item={item}
              artist={item.artist}
              title={item.title}
              imageUrl={item.imageUrl}
            />
          );
        }}
      />
    </View>
  );
}
