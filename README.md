### MIT Licence

# react-native-replaykit

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

RNRK.initialize({
  showOverlay: true // you must pass true or false for this option. It determines if a blue overlay will show up at the top of the screen that will indicate recording but not show up in the actual screen recording.
}) // you need to call this before using RNRK and only once during app's life.

RNRK.startRecording((recordings, error) => console.log(recordings)) // starts the recording. The callback is fired when the recording is completed.

RNRK.stopRecording(recordings => console.log(recordings)) // stops the recording and saves it <- Same as pressing Stop in blue bar up top

RNRK.getRecordings(recordings => console.log(recordings)) get all recordings stored in the app's Documents/Replays folder.

RNRK.previewRecording(path) // open a recording for trimming in the native editor.. save will replace the file, cancel just dismiss the editor.

RNRK.copyRecording(recordingPath, (recordings, copyPath) => {
  console.log(recordings) // the array of all your recordings
  console.log(copyPath) // the new path of the recording you just made by copying another
})

RNRK.deleteRecording(recordingPath, (recordings, deletedPath) => {
  console.log(recordings) // the array of all your recordings
  console.log(deletedPath) // the path of the recording just deleted
})
```

## Contributing
If you find a bug or would like to request a new feature, open an issue. 
Your contributions are always welcome! Fork the project and Submit a pull request.

## TODO
* Utility for editing multiple saved clips into one and being able to sort them however desired and preview that result.
* Utilities for ReplayKit's Broadcasting ability

  
