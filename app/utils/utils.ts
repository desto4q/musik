import {style as tw} from 'twrnc';
import {tailwind} from 'easycolors';
let themeObj = {
  background: tailwind.neutral[800],
  text: tailwind.slate[200],
};
let colors = tailwind;
import RNFetchBlob from 'react-native-blob-util';

import RNFS from '@dr.pogodin/react-native-fs';
import RNColorThief from 'react-native-color-thief';

async function convertContentUriToFileUri(contentUri: string) {
  try {
    // Get the app's document directory
    const documentDirectory = RNFetchBlob.fs.dirs.DocumentDir;
    const fileName = 'saved_file.jpg';
    const filePath = `${documentDirectory}/${fileName}`;

    await RNFetchBlob.fs.cp(contentUri, filePath);
    return `file://${filePath}`; // Return the file URI
  } catch (error) {
    console.error('Error converting contentUri to fileUri:', error);
    throw error;
  }
}
type IColors = {r: string; g: string; b: string};
const rgbToString = (color: IColors) =>
  `rgb(${color.r}, ${color.g}, ${color.b})`;

let generatePalette = async (url: string) => {
  let col_arr: string[] = [];
  let file_path = await convertContentUriToFileUri(url);
  // let colors = await RNColorThief.getColor(file_path, 10, false);
  let palette: IColors[] = await RNColorThief.getPalette(
    file_path,
    5,
    3,
    false,
  );
  for (let pal of palette) {
    let newPal = rgbToString(pal);
    col_arr.push(newPal);
  }
  return col_arr;
};
function parseLRC(lrc: string) {
  const lines = lrc.split('\n');
  const result: any = [];
  const timeExp = /\[(\d{2}):(\d{2})\.(\d{2})\]/;
  lines.forEach(line => {
    const match = timeExp.exec(line);
    if (match) {
      const min = parseInt(match[1], 10);
      const sec = parseInt(match[2], 10);
      const millisec = parseInt(match[3], 10);
      const time = min * 60 + sec + millisec / 100;

      const lyricText = line.replace(timeExp, '').trim();
      result.push({time, text: lyricText});
    }
  });

  return result;
}
export {
  tw,
  themeObj,
  colors,
  convertContentUriToFileUri,
  generatePalette,
  parseLRC,
};
