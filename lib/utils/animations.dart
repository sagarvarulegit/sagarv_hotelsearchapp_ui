import 'package:flutter/material.dart';

class AppAnimations {
  // Page transitions
  static Route<T> slideTransition<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeOutCubic;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 200),
    );
  }

  static Route<T> fadeTransition<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
    );
  }

  static Route<T> scaleTransition<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
          )),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  // Micro-animations
  static Widget fadeIn({
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
    Duration delay = Duration.zero,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: Curves.easeOut,
      child: child,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
    );
  }

  static Widget slideUp({
    required Widget child,
    Duration duration = const Duration(milliseconds: 400),
    double offset = 50.0,
  }) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween(
        begin: Offset(0, offset),
        end: Offset.zero,
      ),
      duration: duration,
      curve: Curves.easeOutCubic,
      child: child,
      builder: (context, value, child) {
        return Transform.translate(
          offset: value,
          child: child,
        );
      },
    );
  }

  static Widget scaleIn({
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
    double scale = 0.8,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: scale, end: 1.0),
      duration: duration,
      curve: Curves.easeOutBack,
      child: child,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
    );
  }

  static Widget shimmer({
    required Widget child,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.4, end: 1.0),
      duration: duration,
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }

  // Loading animations
  static Widget loadingShimmer({
    required double width,
    required double height,
    BorderRadius? borderRadius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
    );
  }

  // Staggered animations
  static List<Widget> staggeredList({
    required List<Widget> children,
    Duration duration = const Duration(milliseconds: 400),
    double offset = 20.0,
  }) {
    return children.asMap().entries.map((entry) {
      final index = entry.key;
      final child = entry.value;
      
      return TweenAnimationBuilder<Offset>(
        tween: Tween(
          begin: Offset(0, offset),
          end: Offset.zero,
        ),
        duration: duration,
        curve: Curves.easeOutCubic,
        child: child,
        builder: (context, value, child) {
          return Transform.translate(
            offset: value,
            child: child,
          );
        },
      );
    }).toList();
  }
}

// Custom animation controllers
class AnimatedHeart extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onTap;

  const AnimatedHeart({
    Key? key,
    required this.isFavorite,
    required this.onTap,
  }) : super(key: key);

  @override
  State<AnimatedHeart> createState() => _AnimatedHeartState();
}

class _AnimatedHeartState extends State<AnimatedHeart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
        _controller.forward().then((_) => _controller.reverse());
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Icon(
          widget.isFavorite ? Icons.favorite : Icons.favorite_border,
          color: widget.isFavorite ? Colors.red : null,
        ),
      ),
    );
  }
}
