part of nixon_app;

class ViewRecorder extends StatefulWidget {
  @override
  _ViewRecorderState createState() => _ViewRecorderState();
}

class _ViewRecorderState extends State<ViewRecorder> {
  InspectionModel model;
  //Recording _recording;
  bool _isRecording = false;
  //String _path;

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
    model.form.files ??= [];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        _buildListView(),
        _recorderWidget(),
        new SizedBox(
          height: 40.0,
        )
      ],
    );
  }

  _recorderWidget() {
    return new Center(
      child: !_isRecording
          ? new RaisedButton(
              elevation: 4.0,
              padding: EdgeInsets.all(15.0),
              color: Theme.of(context).primaryColor,
              shape: new CircleBorder(),
              child: new Icon(Icons.mic, color: Colors.white, size: 40.0),
              onPressed: _isRecording ? null : _start,
            )
          : new RaisedButton(
              elevation: 4.0,
              padding: EdgeInsets.all(15.0),
              color: Theme.of(context).primaryColor,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              child: new Icon(Icons.stop, color: Colors.white, size: 40.0),
              onPressed: _isRecording ? _stop : null,
            ),
    );
  }

  _buildListView() {
    return new Expanded(
      child: new ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: model.form.files.length,
        //itemExtent: 130.0,
        itemBuilder: (context, index) {
          UFiles f = model.form.files[index];
          // String fileName = path;
          return new Card(
            elevation: 4.0,
            child: new ExpansionTile(
                title: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new CircleAvatar(child: new Icon(Icons.audiotrack)),
                    new SizedBox(
                      width: 20.0,
                    ),
                    Text(f.name,
                        style: Theme
                            .of(context)
                            .textTheme
                            .body2
                            .copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
                trailing: new IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => setState(() {
                          model.form.files.remove(f);
                          InspectionRepos.deleteAudio(f.name);
                        })),
                children: <Widget>[
                  new Container(
                    child:
                        new _PlayerUiWidget(url: f.downloalUrl, isLocal: false),
                  ),
                ]),
          );
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
          //_recording = new Recording(duration: new Duration(), path: "");
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
    UFiles tmp = new UFiles();
    InspectionRepos.uploadAudios(file, '$date.aac').then((link) {
      tmp.downloalUrl = link;
      tmp.name = '$date.aac';
      setState(() {
        model.form.files.add(tmp);
      });
    });
    print("  File length: ${await file.length()}");
    setState(() {
      //_recording = recording;
      _isRecording = isRecording;
    });
  }
}
