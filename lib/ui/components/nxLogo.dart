part of nixon_app;

class NxLogo extends StatefulWidget {
  NxLogo({this.color});
  final Color color;
  @override
  _NxLogoState createState() => new _NxLogoState();
}

// ignore: mixin_inherits_from_not_object
class _NxLogoState extends State<NxLogo> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    final CurvedAnimation curve =
        new CurvedAnimation(parent: _controller, curve: Curves.bounceInOut);
    _animation = new Tween(begin: 0.0, end: 120.0).animate(curve);
    _controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new GrowTransition(
        child: new Container(
          child: new Image.asset(
            'assets/nx_logo.png',
            height: _animation.value,
            width: _animation.value,
            color: widget.color ?? Colors.red.shade800,
          ),
        ),
        animation: _animation);
  }
}

class GrowTransition extends StatelessWidget {
  GrowTransition({this.child, this.animation});

  final Widget child;
  final Animation<double> animation;

  Widget build(BuildContext context) {
    return new Center(
      child: new AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget child) {
            return new Container(
              height: animation.value,
              width: animation.value,
              child: new Opacity(
                opacity: animation.value / 150,
                child: child,
              ),
            );
          },
          child: child),
    );
  }
}
