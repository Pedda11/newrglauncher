import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/rg_event_list_data.dart';
import '../../../theme/helpers/theme_context_extensions.dart';
import '../cubit/event_screen_cubit.dart';
import 'event_item.dart';
import 'event_status_legend.dart';

class EventCategoryList extends StatelessWidget {
  final List<RgEventListData> rgEventListDataList;

  const EventCategoryList({
    super.key,
    required this.rgEventListDataList,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.launcherColors;
    final spacing = context.launcherSpacing;
    final radius = context.launcherRadius;
    final text = context.launcherText;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              spacing.screenPadding,
              spacing.screenPadding,
              spacing.screenPadding,
              spacing.screenPadding + 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: rgEventListDataList.map((category) {
                return Padding(
                  padding: EdgeInsets.only(bottom: spacing.lg),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colors.panelBackground.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(radius.panel),
                      border: Border.all(
                        color: colors.accent.withValues(alpha: 0.20),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.24),
                          blurRadius: 18,
                          spreadRadius: -8,
                          offset: const Offset(0, 8),
                        ),
                        BoxShadow(
                          color: colors.accent.withValues(alpha: 0.08),
                          blurRadius: 28,
                          spreadRadius: -10,
                        ),
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colors.panelBackground.withValues(alpha: 1.0),
                          colors.panelBackground.withValues(alpha: 0.96),
                          colors.accent.withValues(alpha: 0.018),
                        ],
                        stops: const [0.0, 0.75, 1.0],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _EventCategoryHeader(
                          title: category.events.first.categoryName,
                          isExpanded: category.isExpanded,
                          onTap: () {
                            context.read<EventScreenCubit>().toggleExpansion(
                                category.events.first.categoryId);
                          },
                        ),
                        if (category.isExpanded) ...[
                          SizedBox(height: spacing.sm),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: category.events.length,
                            itemBuilder: (context, index) {
                              return EventItem(
                                rgEventData: category.events[index],
                              );
                            },
                          ),
                          SizedBox(height: spacing.sm),
                        ],
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const EventStatusLegend(),
      ],
    );
  }
}

class _EventCategoryHeader extends StatefulWidget {
  final String title;
  final bool isExpanded;
  final VoidCallback onTap;

  const _EventCategoryHeader({
    required this.title,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  State<_EventCategoryHeader> createState() => _EventCategoryHeaderState();
}

class _EventCategoryHeaderState extends State<_EventCategoryHeader> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.launcherColors;
    final spacing = context.launcherSpacing;
    final radius = context.launcherRadius;
    final text = context.launcherText;
    final headerBottomPadding = widget.isExpanded ? 0.0 : spacing.md;

    final chipRadius = BorderRadius.circular(radius.button);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        spacing.lg,
        spacing.md,
        spacing.lg,
        headerBottomPadding,
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: colors.accentStrong,
              borderRadius: BorderRadius.circular(999),
              boxShadow: [
                BoxShadow(
                  color: colors.accent.withValues(alpha: 0.30),
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
              ],
            ),
          ),
          SizedBox(width: spacing.md),
          Expanded(
            child: Text(
              widget.title.toUpperCase(),
              style: text.fieldLabel.copyWith(
                color: colors.accentSoft,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ),
          MouseRegion(
            onEnter: (_) => setState(() => _hovered = true),
            onExit: (_) => setState(() => _hovered = false),
            cursor: SystemMouseCursors.click,
            child: Material(
              color: Colors.transparent,
              borderRadius: chipRadius,
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                borderRadius: chipRadius,
                onTap: widget.onTap,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 140),
                  curve: Curves.easeOut,
                  padding: EdgeInsets.symmetric(
                    horizontal: spacing.md,
                    vertical: spacing.sm - 1,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: chipRadius,
                    color: _hovered
                        ? colors.accent.withValues(alpha: 0.16)
                        : colors.accent.withValues(alpha: 0.10),
                    border: Border.all(
                      color: colors.accent.withValues(
                        alpha: _hovered ? 0.40 : 0.24,
                      ),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.isExpanded ? 'Einklappen' : 'Ausklappen',
                        style: text.buttonSecondary.copyWith(
                          color: colors.accentSoft,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: spacing.sm),
                      AnimatedRotation(
                        turns: widget.isExpanded ? 0.5 : 0.0,
                        duration: const Duration(milliseconds: 180),
                        child: Icon(
                          Icons.expand_more_rounded,
                          size: 20,
                          color: colors.accentSoft,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
