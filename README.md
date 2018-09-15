
# react-native-replaykit

## Getting started

`$ npm install react-native-replaykit --save`

### Mostly automatic installation

`$ react-native link react-native-replaykit`

### Usage

```
import RNRK from 'react-native-replaykit'

RNRK.startRecording() // starts the recording

RNRK.stopRecording() // stops the recording and opens the preview/edit modal <- same as tapping top blue stop bar

RKRK.getRecordings(recordings => console.log(recordings)) get all recordings stored in the app's Documents/Replays folder.

RNRK.previewRecording(path) // open a recording for trimming in the native editor.. save will replace the file, cancel just dismiss the editor.

```

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-replaykit` and add `RNReactNativeReplaykit.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNReactNativeReplaykit.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

### Manual installation continued (required after manual installation or linking)

Create a swift file in your main project (if anyone knows a better way to get the auto generated swift build settings to show up, plese open an issue). If you delete this swift file or bridging header, the build settings needed will go away and build fail. 'Objecttive-C Generated Interface Header Name'. 


## Usage
```javascript
import RNReactNativeReplaykit from 'react-native-replaykit';

// TODO: What to do with the module?
RNReactNativeReplaykit;
```
  