part of nixon_app;

enum PlayerState { stopped, playing, paused }

typedef void OnError(Exception exception);

class _PlayerUiWidget extends StatefulWidget {
  final String url;
  final bool isLocal;

  _PlayerUiWidget({@required this.url, this.isLocal});

  @override
  State<StatefulWidget> createState() {
    return new _PlayerUiWidgetState(filePath: url, isLocal: isLocal);
  }
}

class _PlayerUiWidgetState extends State<_PlayerUiWidget> {
  _PlayerUiWidgetState({@required this.filePath, @required this.isLocal});

  String filePath;
  bool isLocal;

  Duration duration;
  Duration position;

  AudioPlayer audioPlayer;

  PlayerState playerState = PlayerState.stopped;

  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;

  get durationText =>
      duration != null ? duration.toString().split('.').first : '';
  get positionText =>
      position != null ? position.toString().split('.').first : '';

  bool isMuted = false;

  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    _audioPlayerStateSubscription.cancel();
    audioPlayer.stop();
    super.dispose();
  }

  void initAudioPlayer() {
    audioPlayer = new AudioPlayer();
    _positionSubscription = audioPlayer.onAudioPositionChanged
        .listen((p) => setState(() => position = p));
    _audioPlayerStateSubscription =
        audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.PLAYING) {
        setState(() => duration = audioPlayer.duration);
      } else if (s == AudioPlayerState.STOPPED) {
        onComplete();
        setState(() {
          position = duration;
        });
      }
    }, onError: (msg) {
      setState(() {
        playerState = PlayerState.stopped;
        duration = new Duration(seconds: 0);
        position = new Duration(seconds: 0);
      });
    });
  }

  Future play() async {
    await audioPlayer.play(filePath, isLocal: isLocal);
    setState(() {
      playerState = PlayerState.playing;
    });
  }

  Future pause() async {
    await audioPlayer.pause();
    setState(() => playerState = PlayerState.paused);
  }

  Future stop() async {
    await audioPlayer.stop();
    setState(() {
      playerState = PlayerState.stopped;
      position = new Duration();
    });
  }

  Future mute(bool muted) async {
    await audioPlayer.mute(muted);
    setState(() {
      isMuted = muted;
    });
  }

  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
  }

  // Future<Uint8List> _loadFileBytes(String url, {OnError onError}) async {
  //   Uint8List bytes;
  //   try {
  //     bytes = await readBytes(url);
  //   } on ClientException {
  //     rethrow;
  //   }
  //   return bytes;
  // }

  // Future _loadFile() async {
  //   final bytes = await _loadFileBytes(filePath,
  //       onError: (Exception exception) =>
  //           print('_loadFile => exception $exception'));

  //   final dir = await getApplicationDocumentsDirectory();
  //   final file = new File('${dir.path}/audio.mp3');

  //   await file.writeAsBytes(bytes);
  //   if (await file.exists())
  //     setState(() {
  //       filePath = file.path;
  //     });
  // }

  @override
  Widget build(BuildContext context) {
    return _buildPlayer();
  }

  Widget _buildPlayer() => new Container(
      padding: new EdgeInsets.all(10.0),
      child: new Row(mainAxisSize: MainAxisSize.min, children: [
        new IconButton(
            onPressed: isPlaying ? null : () => play(),
            iconSize: 20.0,
            icon: new Icon(Icons.play_arrow),
            color: Colors.cyan),
        new IconButton(
            onPressed: isPlaying ? () => pause() : null,
            iconSize: 20.0,
            icon: new Icon(Icons.pause),
            color: Colors.cyan),
        new IconButton(
            onPressed: isPlaying || isPaused ? () => stop() : null,
            iconSize: 20.0,
            icon: new Icon(Icons.stop),
            color: Colors.cyan),
      ]));
}
