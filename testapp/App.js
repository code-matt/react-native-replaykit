
import { StyleSheet, Text, View, TouchableOpacity, ListView } from 'react-native';
import RNRK from 'react-native-replaykit';
import React from 'react'

RNRK.initialize({
  showOverlay: true
});

export default class HomeScreen extends React.Component {

  state = {
    recordings: []
  }

  constructor (props) {
    super(props)
    this.ds = new ListView.DataSource({rowHasChanged: (r1, r2) => true});
    this.state = {
      recordings: this.ds.cloneWithRows([])
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
      this.updateRecordings(recordings)
    });
    console.log("Stop pressed");
  }

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
    // flex: 1,
    // justifyContent: 'center',
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
  }
});