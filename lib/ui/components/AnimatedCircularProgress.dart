part of nixon_app;

class AnimatedCircularProgress extends StatefulWidget {
  @override
  _AnimatedCircularProgressState createState() =>
      new _AnimatedCircularProgressState();
}

class _AnimatedCircularProgressState extends State<AnimatedCircularProgress>
    // ignore: mixin_inherits_from_not_object
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Color> _colorAnimation;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 1000));

    _colorAnimation = new ColorTween(begin: Colors.red, end: Colors.white)
        .animate(_animationController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _animationController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              _animationController.forward();
            }
          });
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return new CircularProgressIndicator(
      strokeWidth: 8.0,
      valueColor: _colorAnimation,
    );
  }
}
