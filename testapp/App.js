
import { StyleSheet, Text, View, TouchableOpacity, ListView, ScrollView, Alert } from 'react-native'
import RNRK from 'react-native-replaykit'
import React from 'react'
import Sound from 'react-native-sound'

RNRK.initialize({
  showOverlay: false
});

const audioTests = [
  {
    title: 'mp3 in bundle',
    url: 'advertising.mp3',
    basePath: Sound.MAIN_BUNDLE,
  }
]

const Header = ({children, style}) => <Text style={[styles.header, style]}>{children}</Text>;

const Feature = ({title, onPress, description, buttonLabel = 'PLAY', status}) => (
  <View style={styles.feature}>
    <Header style={{flex: 1}}>{title}</Header>
    {status ? <Text style={{padding: 5}}>{resultIcons[status] || ''}</Text> : null}
    <Button title={buttonLabel} onPress={onPress} />
  </View>
);

const resultIcons = {
  '': '',
  pending: '?',
  playing: '\u25B6',
  win: '\u2713',
  fail: '\u274C',
};

/**
 * Generic play function for majority of tests
 */
function playSound(testInfo, component) {
  setTestState(testInfo, component, 'pending');

  const callback = (error, sound) => {
    if (error) {
      Alert.alert('error', error.message);
      setTestState(testInfo, component, 'fail');
      return;
    }
    setTestState(testInfo, component, 'playing');
    // Run optional pre-play callback
    testInfo.onPrepared && testInfo.onPrepared(sound, component);
    sound.play(() => {
      // Success counts as getting to the end
      setTestState(testInfo, component, 'win');
      // Release when it's done so we're not using up resources
      sound.release();
    });
  };

  // If the audio is a 'require' then the second parameter must be the callback.
  if (testInfo.isRequire) {
    const sound = new Sound(testInfo.url, error => callback(error, sound));
  } else {
    const sound = new Sound(testInfo.url, testInfo.basePath, error => callback(error, sound));
  }
}

const Button = ({title, onPress}) => (
  <TouchableOpacity onPress={onPress}>
    <Text style={styles.button}>{title}</Text>
  </TouchableOpacity>
);

function setTestState(testInfo, component, status) {
  component.setState({tests: {...component.state.tests, [testInfo.title]: status}});
}

export default class HomeScreen extends React.Component {

  state = {
    recordings: []
  }

  constructor (props) {
    super(props)
    console.disableYellowBox = true
    Sound.setCategory('Playback', true)
    this.ds = new ListView.DataSource({rowHasChanged: (r1, r2) => true});
    this.state = {
      recordings: this.ds.cloneWithRows([]),
      loopingSound: undefined,
      tests: {},
    };
  }

  componentDidMount () {
    RNRK.getRecordings((recordings) => {
      this.updateRecordings(recordings)
    })
  }

  updateRecordings = (recordings) => {
    this.setState({ recordings: this.ds.cloneWithRows(recordings) })
  }

  doRecord = () => {
    console.log("Start pressed");
    RNRK.startRecording((recordings, error) => {
      console.log(error)
      console.log(recordings)
      console.log("Start Recording Finished");
    });
  }

  stopRecord = () => {
    RNRK.stopRecording(recordings => {
      console.log("Stop recording finished, number of recordings: ", recordings.length);
      console.log(recordings)
      setTimeout(() => {
        this.updateRecordings(recordings)
      }, 1000)
    });
    console.log("Stop pressed");
  }

  stopSoundLooped = () => {
    if (!this.state.loopingSound) {
      return;
    }

    this.state.loopingSound.stop().release();
    this.setState({loopingSound: null, tests: {...this.state.tests, ['mp3 in bundle (looped)']: 'win'}});
  };

  renderRecordingListItem = (data) => {
    return (
        <View style={styles.recordingItemContainer}>
          <TouchableOpacity onPress={() => RNRK.previewRecording(data)} style={{flex: 1}}>
            <View>
              <Text>
                {data}
              </Text>
            </View>
          </TouchableOpacity>
          <TouchableOpacity onPress={() => RNRK.deleteRecording(data, (recordings, deletedRecording) => {
            this.updateRecordings(recordings)
          })}>
            <View>
              <Text>
                Delete
              </Text>
            </View>
          </TouchableOpacity>
          <TouchableOpacity onPress={() => RNRK.copyRecording(data, (recordings, newRecordingPath) => {
            this.updateRecordings(recordings)
          })}>
            <View>
              <Text>
                Copy
              </Text>
            </View>
          </TouchableOpacity>
        </View>
    )
  }

  renderButton = (text, onPress) => {
    return (
      <TouchableOpacity style={styles.button} onPress={onPress}>
        <Text style={styles.buttonText}>{text}</Text>
      </TouchableOpacity>
    )
  }

  render() {
    return (
      <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
        <View style={styles.buttonContainer}>
          {this.renderButton('Record', this.doRecord)}
          {this.renderButton('Stop', this.stopRecord)}
        </View>

        {audioTests.map(testInfo => {
            return (
              <Feature
                status={this.state.tests[testInfo.title]}
                key={testInfo.title}
                title={testInfo.title}
                onPress={() => {
                  return playSound(testInfo, this);
                }}
              />
            );
          })}
          
        <ListView
          contentContainerStyle={styles.listContainer}
          style={{flex: 1}}
          dataSource={this.state.recordings}
          renderRow={(data) => this.renderRecordingListItem(data)}
        />
      </View>
    );
  }
}

const styles = StyleSheet.create({
  listContainer: {
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
    width: '100%'
  },
  buttonContainer: {
    marginTop: 100
  },
  recordingItemContainer: {
    width: 300,
    backgroundColor: 'red',
    marginBottom: 20,
    flexDirection: 'row'
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
  button: {
    padding: 20
  },
  container: {
    flex: 1,
  },
  scrollContainer: {},
  title: {
    fontSize: 20,
    fontWeight: 'bold',
    paddingTop: 30,
    padding: 20,
    textAlign: 'center',
    backgroundColor: 'rgba(240,240,240,1)',
  },
  button: {
    fontSize: 20,
    backgroundColor: 'rgba(220,220,220,1)',
    borderRadius: 4,
    borderWidth: 1,
    borderColor: 'rgba(80,80,80,0.5)',
    overflow: 'hidden',
    padding: 7,
  },
  header: {
    textAlign: 'left',
  },
  feature: {
    flexDirection: 'row',
    padding: 10,
    alignSelf: 'stretch',
    alignItems: 'center',
    borderTopWidth: 1,
    borderTopColor: 'rgb(180,180,180)',
    borderBottomWidth: 1,
    borderBottomColor: 'rgb(230,230,230)',
  },
});