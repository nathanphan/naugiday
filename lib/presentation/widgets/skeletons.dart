import 'package:flutter/material.dart';
import 'package:naugiday/presentation/theme/app_theme.dart';

/// Simple shimmer effect using an animated gradient sweep.
class Shimmer extends StatefulWidget {
  const Shimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.duration = AppTheme.animMedium,
  });

  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration duration;

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = widget.baseColor ?? Colors.grey.shade300;
    final highlight = widget.highlightColor ?? Colors.grey.shade100;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (rect) {
            final width = rect.width;
            final gradientWidth = width / 2;
            final dx = (width + gradientWidth) * _controller.value - gradientWidth;
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [base, highlight, base],
              stops: const [0.1, 0.3, 0.6],
              transform: _SlidingGradientTransform(dx / width),
            ).createShader(rect);
          },
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform(this.slidePercent);
  final double slidePercent;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}

/// Rectangular skeleton block with optional shimmer.
class SkeletonBlock extends StatelessWidget {
  const SkeletonBlock({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = const BorderRadius.all(Radius.circular(AppTheme.radiusLarge)),
    this.shimmer = true,
  });

  final double? width;
  final double height;
  final BorderRadius borderRadius;
  final bool shimmer;

  @override
  Widget build(BuildContext context) {
    final base = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: borderRadius,
      ),
    );
    if (!shimmer) return base;
    return Shimmer(child: base);
  }
}

/// Common skeleton compositions for cards and lists.
class SkeletonCardGrid extends StatelessWidget {
  const SkeletonCardGrid({
    super.key,
    this.crossAxisCount = 2,
    this.aspectRatio = 0.75,
    this.itemCount = 6,
  });

  final int crossAxisCount;
  final double aspectRatio;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: aspectRatio,
        crossAxisSpacing: AppTheme.spacingM,
        mainAxisSpacing: AppTheme.spacingM,
      ),
      itemBuilder: (_, __) => SkeletonBlock(
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        height: double.infinity,
      ),
    );
  }
}

class SkeletonList extends StatelessWidget {
  const SkeletonList({super.key, this.items = 6});

  final int items;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items,
      separatorBuilder: (_, __) => const SizedBox(height: AppTheme.spacingS),
      itemBuilder: (_, __) => Row(
        children: const [
          SkeletonBlock(width: 48, height: 48, shimmer: true),
          SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBlock(width: 180, height: 14),
                SizedBox(height: AppTheme.spacingS),
                SkeletonBlock(width: 120, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// ignore_for_file: unnecessary_underscores
