import 'package:flutter/material.dart';

class AnimatedRoute<T> extends MaterialPageRoute<T> {
  AnimatedRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;
    // Fades between routes. (If you don't want any animation,
    // just return child.)
    //return new FadeTransition(opacity: animation, child: child);

    return new SlideTransition(
        position: new Tween(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(
          new CurvedAnimation(
            parent: animation,
            curve: Curves.bounceInOut,
          ),
        ),
        child: child);
  }

  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration => const Duration(milliseconds: 800);
}
