import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ProgressStepsBar extends StatefulWidget {
  final int filledCount;
  final int totalCount;

  const ProgressStepsBar({
    super.key,
    required this.filledCount,
    required this.totalCount,
  });

  @override
  State<ProgressStepsBar> createState() => _ProgressStepsBarState();
}

class _ProgressStepsBarState extends State<ProgressStepsBar>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.totalCount, (index) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 700),
      );
    });

    _animations = _controllers
        .map((c) => Tween<double>(begin: 0, end: 1).animate(
              CurvedAnimation(parent: c, curve: Curves.easeInOut),
            ))
        .toList();

    for (int i = 0; i < widget.filledCount; i++) {
      _controllers[i].forward();
    }
  }

  @override
  void didUpdateWidget(covariant ProgressStepsBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.filledCount > oldWidget.filledCount) {
      for (int i = oldWidget.filledCount; i < widget.filledCount; i++) {
        Future.delayed(
            Duration(milliseconds: 700 * (i - oldWidget.filledCount)), () {
          if (mounted) _controllers[i].forward();
        });
      }
    } else {
      for (int i = widget.filledCount; i < oldWidget.filledCount; i++) {
        _controllers[i].reverse();
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(widget.totalCount, (index) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Container(
              height: 50,
              decoration: ShapeDecoration(
                color: AppColors.background.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: AppColors.borderSide,
                  ),
                  borderRadius: BorderRadius.circular(80),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(80),
                child: AnimatedBuilder(
                  animation: _animations[index],
                  builder: (context, child) {
                    return FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: _animations[index].value,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.buttonColor,
                          borderRadius: BorderRadius.circular(80),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
