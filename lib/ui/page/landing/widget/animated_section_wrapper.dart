import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// 스크롤 방향에 관계없이 뷰포트에 들어올 때마다 애니메이션을 재생하는 래퍼 위젯
class AnimatedSectionWrapper extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final double slideYBegin;
  final Curve curve;

  const AnimatedSectionWrapper({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
    this.delay = const Duration(milliseconds: 0),
    this.slideYBegin = 0.15,
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<AnimatedSectionWrapper> createState() => _AnimatedSectionWrapperState();
}

class _AnimatedSectionWrapperState extends State<AnimatedSectionWrapper> {
  int _animationKey = 0;
  bool _hasBeenVisible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('animated_section_${widget.key}'),
      onVisibilityChanged: (VisibilityInfo info) {
        // 위젯이 뷰포트에 20% 이상 보일 때 애니메이션 재생
        if (info.visibleFraction > 0.2) {
          if (!_hasBeenVisible || info.visibleFraction > 0.5) {
            setState(() {
              _animationKey = DateTime.now().millisecondsSinceEpoch;
              _hasBeenVisible = true;
            });
          }
        }
      },
      child: widget.child
          .animate(key: ValueKey(_animationKey))
          .fadeIn(
            duration: widget.duration,
            delay: widget.delay,
          )
          .slideY(
            begin: widget.slideYBegin,
            end: 0,
            duration: widget.duration,
            delay: widget.delay,
            curve: widget.curve,
          ),
    );
  }
}
