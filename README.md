### MIT Licence (See Licences folder)

# react-native-replaykit
### work in progress, breaking changes inbound - WIP

## Getting started

`$ npm install react-native-replaykit --save`

### Mostly automatic installation

`$ react-native link react-native-replaykit`

### Manual installation

#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-replaykit` and add `RNReactNativeReplaykit.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNReactNativeReplaykit.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

### Manual installation continued (required after manual installation or linking)

Create a swift file in your main project (if anyone knows a better way to get the auto generated swift build settings to show up, plese open an issue). If you delete this swift file or bridging header, the build settings needed will go away and build fail. 'Objecttive-C Generated Interface Header Name'. 


### Usage
```
import RNRK from 'react-native-replaykit'

RNRK.startRecording() // starts the recording

RNRK.stopRecording() // stops the recording and saves it <- Same as pressing Stop in blue bar up top

RKRK.getRecordings(recordings => console.log(recordings)) get all recordings stored in the app's Documents/Replays folder.

RNRK.previewRecording(path) // open a recording for trimming in the native editor.. save will replace the file, cancel just dismiss the editor.
```

## Contributing
If you find a bug or would like to request a new feature, open an issue. 
Your contributions are always welcome! Fork the project and Submit a pull request.

## TODO
* Utility for Editing multiple saved clips into one
* Utilities for ReplayKit's Broadcasting ability

  