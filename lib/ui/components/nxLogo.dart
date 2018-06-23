part of nixon_app;

class NxLogo extends StatefulWidget {
  NxLogo(
      {@required this.color,
      this.beginSize = 0.0,
      this.endSize = 120.0,
      this.repeat: false});
  final double beginSize;
  final double endSize;
  final Color color;
  final bool repeat;

  @override
  _NxLogoState createState() => new _NxLogoState();
}

// ignore: mixin_inherits_from_not_object
class _NxLogoState extends State<NxLogo> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  bool isLoading = true;

  initState() {
    // TODO: implement initState
    super.initState();
    _controller = new AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    final CurvedAnimation _curve =
        new CurvedAnimation(parent: _controller, curve: Curves.bounceInOut);
    _animation =
        new Tween(begin: widget.beginSize, end: widget.endSize).animate(_curve);

    if (widget.repeat) {
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
          _controller.addListener(() {
            if (isLoading && _controller.value < 0.6) _controller.forward();
          });
        }
      });
    }
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
            return new SizedBox(
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
