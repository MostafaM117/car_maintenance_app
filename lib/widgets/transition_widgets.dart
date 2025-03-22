import 'package:flutter/material.dart';

Route FadeinTransition(Widget page) {
  return PageRouteBuilder(
    transitionDuration: Duration(milliseconds: 600),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var slideTween = Tween<Offset>(
        begin: Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(animation);

      var fadeTween = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(animation);

      return SlideTransition(
        position: slideTween,
        child: FadeTransition(
          opacity: fadeTween,
          child: child,
        ),
      );
    },
  );
}
