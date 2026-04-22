import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../data/account.dart';
import '../../../../../theme/helpers/theme_context_extensions.dart';
import '../../../cubit/account_cubit/account_screen_cubit.dart';
import '../../../cubit/character_cubit/character_data_cubit.dart';

class AccountCard extends StatefulWidget {
  final Account acc;
  final Function()? onTap;
  final Function()? onDoubleTap;
  final bool isSelected;

  const AccountCard({
    super.key,
    required this.acc,
    this.onTap,
    this.onDoubleTap,
    this.isSelected = false,
  });

  @override
  State<AccountCard> createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  double _progress = 0.0;
  bool _isLaunching = false;
  bool _hovered = false;

  void _onDoubleTap() async {
    if (_isLaunching) return;

    setState(() {
      _isLaunching = true;
      _progress = 0.0;
    });

    for (int i = 1; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 50));
      if (!mounted) return;
      setState(() {
        _progress = i / 200;
      });
    }

    await Future.delayed(const Duration(milliseconds: 200));

    if (!mounted) return;
    setState(() {
      _isLaunching = false;
      _progress = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.launcherColors;
    final spacing = context.launcherSpacing;
    final radius = context.launcherRadius;
    final text = context.launcherText;

    final cardRadius = BorderRadius.circular(radius.card);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onDoubleTap: () {
          _onDoubleTap();
          widget.onDoubleTap?.call();
        },
        onTap: widget.onTap,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: cardRadius,
                border: Border.all(
                  color: widget.isSelected
                      ? colors.accentStrong.withValues(alpha: 0.92)
                      : _hovered
                          ? colors.accent.withValues(alpha: 0.38)
                          : colors.panelBorder.withValues(alpha: 0.75),
                  width: widget.isSelected ? 1.2 : 1,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colors.panelBackground.withValues(alpha: 0.98),
                    colors.panelBackground.withValues(alpha: 0.94),
                    colors.accent.withValues(
                      alpha: widget.isSelected
                          ? 0.08
                          : _hovered
                              ? 0.04
                              : 0.02,
                    ),
                  ],
                  stops: const [0.0, 0.75, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 14,
                    spreadRadius: -6,
                    offset: const Offset(0, 6),
                  ),
                  if (_hovered || widget.isSelected)
                    BoxShadow(
                      color: colors.accent.withValues(
                        alpha: widget.isSelected ? 0.18 : 0.12,
                      ),
                      blurRadius: widget.isSelected ? 24 : 20,
                      spreadRadius: -8,
                    ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.lg,
                  vertical: spacing.md,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.accent.withValues(alpha: 0.18),
                        border: Border.all(
                          color: colors.accent.withValues(alpha: 0.35),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.person_rounded,
                        color: colors.accentSoft,
                        size: 18,
                      ),
                    ),
                    SizedBox(width: spacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.acc.listName,
                            style: text.fieldValue.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: colors.titleText,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: spacing.xs),
                          Text(
                            widget.acc.accountName,
                            style: text.hintText.copyWith(
                              color: colors.mutedText,
                              fontSize: 13,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: spacing.md),
                    Icon(
                      Icons.play_arrow_rounded,
                      color: colors.mutedText.withValues(alpha: 0.75),
                      size: 22,
                    ),
                  ],
                ),
              ),
            ),
            if (_isLaunching)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: cardRadius,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 50),
                          width: MediaQuery.of(context).size.width * _progress,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                colors.accent.withValues(alpha: 0.22),
                                colors.accentStrong.withValues(alpha: 0.14),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: cardRadius,
                            border: Border.all(
                              color: colors.accent.withValues(alpha: 0.55),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
