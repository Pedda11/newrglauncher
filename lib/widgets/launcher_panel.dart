import 'package:flutter/material.dart';

import '../theme/helpers/theme_context_extensions.dart';

class LauncherPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const LauncherPanel({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.launcherColors;
    final radius = context.launcherRadius;
    final effects = context.launcherEffects;
    final spacing = context.launcherSpacing;
    final components = context.launcherComponents;

    final panelRadius = BorderRadius.circular(radius.panel);

    return Padding(
      padding: EdgeInsets.all(components.panelOuterPadding),
      child: Stack(
        children: [
          /// Outer glow layer
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: panelRadius,
                  boxShadow: [
                    BoxShadow(
                      color: colors.accent.withValues(alpha: 0.18),
                      blurRadius: 24,
                      spreadRadius: 0,
                      blurStyle: BlurStyle.outer,
                    ),
                    BoxShadow(
                      color: colors.accent.withValues(alpha: 0.08),
                      blurRadius: 42,
                      spreadRadius: 2,
                      blurStyle: BlurStyle.outer,
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// Main panel
          ClipRRect(
            borderRadius: panelRadius,
            child: Stack(
              children: [
                Container(
                  padding: padding ?? EdgeInsets.all(spacing.panelPadding),
                  decoration: BoxDecoration(
                    borderRadius: panelRadius,
                    border: Border.all(
                      color: colors.accent.withValues(alpha: 0.52),
                      width: effects.panelBorderWidth,
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colors.panelBackground.withValues(alpha: 1.0),
                        colors.panelBackground.withValues(alpha: 0.995),
                        colors.panelBackground.withValues(alpha: 0.985),
                        colors.accent.withValues(alpha: 0.018),
                      ],
                      stops: const [0.0, 0.45, 0.82, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.34),
                        blurRadius: 28,
                        spreadRadius: -8,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: child,
                ),

                /// Subtle top-left inner light
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: const Alignment(-0.92, -0.92),
                          radius: 0.75,
                          colors: [
                            colors.accent.withValues(alpha: 0.12),
                            colors.accent.withValues(alpha: 0.05),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.22, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),

                /// Top-left border hotspot
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: _PanelBorderHighlightPainter(
                        radius: radius.panel,
                        color: colors.accent,
                      ),
                    ),
                  ),
                ),

                /// Bottom edge light
                Positioned(
                  left: 18,
                  right: 18,
                  bottom: 0,
                  child: IgnorePointer(
                    child: Container(
                      height: 10,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            colors.accent.withValues(alpha: 0.00),
                            colors.accent.withValues(alpha: 0.18),
                            colors.accent.withValues(alpha: 0.24),
                            colors.accent.withValues(alpha: 0.18),
                            colors.accent.withValues(alpha: 0.00),
                          ],
                          stops: const [0.0, 0.18, 0.5, 0.82, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PanelBorderHighlightPainter extends CustomPainter {
  final double radius;
  final Color color;

  const _PanelBorderHighlightPainter({
    required this.radius,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(
      rect.deflate(0.9),
      Radius.circular(radius),
    );

    /// Bright edge hotspot
    final brightEdgePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white,
          Colors.white,
          Colors.transparent,
          Colors.transparent,
        ],
        stops: [0.0, 0.04, 0.1, 0.18],
      ).createShader(rect);

    canvas.drawRRect(rrect, brightEdgePaint);

    /// Local neon glow for top and left edge
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = color.withValues(alpha: 0.22)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final path = Path()
      ..moveTo(radius, 0)
      ..lineTo(size.width * 0.22, 0)
      ..moveTo(0, radius)
      ..lineTo(0, size.height * 0.14);

    canvas.drawPath(path, glowPaint);
  }

  @override
  bool shouldRepaint(covariant _PanelBorderHighlightPainter oldDelegate) {
    return oldDelegate.radius != radius || oldDelegate.color != color;
  }
}
