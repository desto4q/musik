import TrackPlayer from 'react-native-track-player';

let PlayTrack = async (item: any) => {
  try {
    // Load the track
    const loadPromise = TrackPlayer.load({
      id: item.id,
      url: item.audioUrl,
      title: item.title,
      artist: item.artist,
      album: item.album,
      artwork: item.imageUrl,
      duration: item.duration, // Duration in seconds
    });

    // Play the track once it is loaded
    loadPromise
      .then(() => TrackPlayer.play())
      .catch(error => {
        console.error('Error playing track:', error);
      });
  } catch (err) {
    console.error('Error loading track:', err);
  }
};

export {PlayTrack};
