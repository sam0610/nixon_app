part of nixon_app;

class ViewRecorder extends StatefulWidget {
  @override
  _ViewRecorderState createState() => _ViewRecorderState();
}

class _ViewRecorderState extends State<ViewRecorder> {
  InspectionModel model;
  Recording _recording;
  bool _isRecording = false;
  String _path;

  void showSnackBar(BuildContext context, String msg,
      {Color bgcolor = Colors.blue}) {
    Scaffold.of(context).showSnackBar(
          new SnackBar(
              duration: new Duration(seconds: 10),
              content: new Text(msg),
              backgroundColor: bgcolor),
        );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    model = ModelFinder<InspectionModel>().of(context);
    model.form.audios ??= [];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        _recorderWidget(),
        _buildListView(),
      ],
    );
//   }
// new Center(
//       child: new Padding(
//         padding: new EdgeInsets.all(8.0),
//         child: new Column(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: <Widget>[
//
//               new Text("1: $_path"),
//               new Text("File path of the record: ${_recording.path}"),
//               new Text(
//                   "Audio recording duration : ${_recording.duration.toString()}")
//             ]),
//       ),
  }

  _recorderWidget() {
    return new Container(
        padding: new EdgeInsets.all(24.0),
        decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(5.0), color: Colors.white),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new RaisedButton(
              shape: new CircleBorder(),
              child: new Icon(Icons.mic, color: Colors.red, size: 60.0),
              onPressed: _isRecording ? null : _start,
              color: Colors.white,
            ),
            new RaisedButton(
              shape: new CircleBorder(),
              child: new Icon(Icons.stop, color: Colors.black, size: 60.0),
              onPressed: _isRecording ? _stop : null,
              color: Colors.white,
            ),
          ],
        ));
  }

  _buildListView() {
    return new Expanded(
      child: new ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: model.form.audios.length,
        itemExtent: 100.0,
        itemBuilder: (context, index) {
          String path = model.form.audios[index];
          String fileName = path;
          return new Card(
              elevation: 5.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(5.0)),
              child: new ListTile(
                subtitle: new Container(
                    child: new _PlayerUiWidget(url: path, isLocal: false)),
                trailing: new IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => setState(() {
                          model.form.audios.remove(path);
                        })),
              ));
        },
      ),
    );
  }

  String date;
  _start() async {
    try {
      Directory appDocDirectory = await getApplicationDocumentsDirectory();
      date = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
      String path = appDocDirectory.path + '/' + '$date.aac';

      if (await AudioRecorder.hasPermissions) {
        await AudioRecorder.start(path: path);
        bool isRecording = await AudioRecorder.isRecording;
        setState(() {
          _recording = new Recording(duration: new Duration(), path: "");
          _isRecording = isRecording;
        });
      } else {
        showSnackBar(context, 'need mic usage permission', bgcolor: Colors.red);
      }
    } catch (e) {
      showSnackBar(context, e.toString(), bgcolor: Colors.red);
    }
  }

  _stop() async {
    var recording = await AudioRecorder.stop();
    print("Stop recording: ${recording.path}");
    bool isRecording = await AudioRecorder.isRecording;
    File file = new File(recording.path);
    InspectionRepos.uploadAudios(file, '$date.aac').then((link) {
      _path = link;
      setState() {
        model.form.audios.add(_path);
      }
    });
    print("  File length: ${await file.length()}");
    setState(() {
      _recording = recording;
      _isRecording = isRecording;
    });
  }
}
