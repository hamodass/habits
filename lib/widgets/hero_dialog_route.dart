import 'package:flutter/material.dart';

class HeroDialogRoute<T> extends PageRoute<T> {
  HeroDialogRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool fullScreenDialog = false,
  })  : _builder = builder,
        super(settings: settings, fullscreenDialog: fullScreenDialog);

  final WidgetBuilder _builder;

  @override
  bool get opaque => false; //root is visiable

  @override
  bool get barrierDismissible => true; // dismissible outside of card

  @override
  Duration get transitionDuration =>
      const Duration(microseconds: 300); //how lon transition will last

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black54; //color of the background

  Widget buildTransition(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  } // transition by hero widget

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return _builder(context);
  }

  @override
  String get barrierLabel => 'Popup dialog open';
}
