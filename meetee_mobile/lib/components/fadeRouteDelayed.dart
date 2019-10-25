import 'package:flutter/material.dart';

class FadeRouteDelayed extends PageRouteBuilder {
  @override
  Duration get transitionDuration => const Duration(milliseconds: 1000);

  final Widget page;
  FadeRouteDelayed({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
