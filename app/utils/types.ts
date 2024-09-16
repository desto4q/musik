interface IMusicFile {
  addedDate: string; // The date the file was added (in timestamp format as a string)
  album: string; // The album name
  artist: string; // The artist(s) name
  audioUrl: string; // The file path to the audio file
  duration: number; // The duration of the track in milliseconds
  id: string; // The unique ID of the track
  imageUrl: string; // The URL to the album art or image
  size: string; // The size of the file in bytes (as a string)
  title: string; // The track title
}

type IAlbumFile = {
  albumSongs: number;
  artist: string;
  artwork: string;
  assetsCount: string;
  id: number | string;
  title: string;
  type: string | null | number | undefined;
};
export type {IMusicFile, IAlbumFile};
