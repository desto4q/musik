import TrackPlayer, {usePlaybackState} from 'react-native-track-player';

let addToPlayer = async (item: any) => {
  await TrackPlayer.add({
    id: item.id,
    url: item.audioUrl,
    title: item.title,
    artist: item.artist,
    album: item.album,
    artwork: item.imageUrl,
    duration: item.duration / 1000, // Duration in seconds
  });

  // Optionally, you can set the newly added song as the current one and start playing
  const queue = await TrackPlayer.getQueue();
  const currentTrack = queue.length - 1; // Get the index of the last added track
  await TrackPlayer.skip(currentTrack); // Set this track as the active one
  await TrackPlayer.play(); // Start playing the track
};

export {addToPlayer};
