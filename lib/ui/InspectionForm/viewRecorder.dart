part of nixon_app;

class ViewRecorder extends StatefulWidget {
  @override
  _ViewRecorderState createState() => _ViewRecorderState();
}

class _ViewRecorderState extends State<ViewRecorder> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Audio example app'),
        ),
        body: new Center(),
      ),
    );
  }
}
