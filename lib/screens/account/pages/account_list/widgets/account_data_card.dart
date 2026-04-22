import 'package:flutter/material.dart';

import '../../../../../data/character.dart';
import '../../../../../localization/generated/l10n.dart';
import '../../../../../theme/helpers/theme_context_extensions.dart';

class AccountDataCard extends StatelessWidget {
  final Character character;

  const AccountDataCard({
    super.key,
    required this.character,
  });

  @override
  Widget build(BuildContext context) {
    final locales = Localize.of(context);
    final colors = context.launcherColors;
    final spacing = context.launcherSpacing;
    final radius = context.launcherRadius;
    final text = context.launcherText;

    final cardRadius = BorderRadius.circular(radius.card);

    return Container(
      decoration: BoxDecoration(
        borderRadius: cardRadius,
        border: Border.all(
          color: colors.panelBorder.withValues(alpha: 0.78),
          width: 1,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.panelBackground.withValues(alpha: 0.98),
            colors.panelBackground.withValues(alpha: 0.94),
            colors.accent.withValues(alpha: 0.02),
          ],
          stops: const [0.0, 0.78, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 16,
            spreadRadius: -6,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: spacing.xs,
                children: [
                  Text(
                    locales.accountDataCardNameLabel,
                    style: text.sectionTitle.copyWith(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    character.name,
                    style: text.sectionTitle.copyWith(
                      fontSize: 18,
                      color: colors.bodyText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: spacing.md),
            Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    colors.panelBorder.withValues(alpha: 0.9),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            SizedBox(height: spacing.md),
            _AccountInfoRow(
              leftLabel: locales.accountDataCardGuildLabel,
              leftValue: character.guildName.isEmpty
                  ? locales.accountDataCardNoGuild
                  : character.guildRank.isEmpty
                      ? character.guildName
                      : '${character.guildName}/${character.guildRank}',
              rightLabel: locales.accountDataCardFactionLabel,
              rightValue: character.faction,
            ),
            SizedBox(height: spacing.sm),
            _AccountInfoRow(
              leftLabel: locales.accountDataCardZoneLabel,
              leftValue: character.subZone.isEmpty
                  ? character.zone
                  : '${character.zone}/${character.subZone}',
              rightLabel: locales.accountDataCardClassLabel,
              rightValue: character.charClass,
            ),
            SizedBox(height: spacing.sm),
            _AccountInfoRow(
              leftLabel: locales.accountDataCardGoldLabel,
              leftValue: character.money,
              rightLabel: locales.accountDataCardLastLogoutLabel,
              rightValue: character.lastLogout,
            ),
            if (character.savedInstances.isNotEmpty) ...[
              SizedBox(height: spacing.lg),
              _SavedInstancesSection(character: character),
            ],
          ],
        ),
      ),
    );
  }
}

class _AccountInfoRow extends StatelessWidget {
  final String leftLabel;
  final String leftValue;
  final String rightLabel;
  final String rightValue;

  const _AccountInfoRow({
    required this.leftLabel,
    required this.leftValue,
    required this.rightLabel,
    required this.rightValue,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = context.launcherSpacing;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _InfoPair(
            label: leftLabel,
            value: leftValue,
          ),
        ),
        SizedBox(width: spacing.lg),
        Expanded(
          child: _InfoPair(
            label: rightLabel,
            value: rightValue,
            alignEnd: true,
          ),
        ),
      ],
    );
  }
}

class _InfoPair extends StatelessWidget {
  final String label;
  final String value;
  final bool alignEnd;

  const _InfoPair({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.launcherColors;
    final text = context.launcherText;

    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: text.fieldLabel.copyWith(
            fontSize: 13,
          ),
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: text.fieldValue.copyWith(
            color: colors.bodyText.withValues(alpha: 0.92),
          ),
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
        ),
      ],
    );
  }
}

class _SavedInstancesSection extends StatelessWidget {
  final Character character;

  const _SavedInstancesSection({
    required this.character,
  });

  @override
  Widget build(BuildContext context) {
    final locales = Localize.of(context);
    final colors = context.launcherColors;
    final spacing = context.launcherSpacing;
    final radius = context.launcherRadius;
    final text = context.launcherText;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius.input),
        color: colors.inputBackground.withValues(alpha: 0.82),
        border: Border.all(
          color: colors.accent.withValues(alpha: 0.14),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              locales.accountDataCardInstancesTitle,
              style: text.fieldLabel.copyWith(
                color: colors.accentSoft,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: spacing.md),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: character.savedInstances.length,
              separatorBuilder: (_, __) => Divider(
                height: spacing.md,
                color: colors.panelBorder.withValues(alpha: 0.55),
              ),
              itemBuilder: (context, index) {
                final instance = character.savedInstances[index];

                return Row(
                  children: [
                    SizedBox(
                      width: 52,
                      child: Text(
                        instance.id.toString(),
                        style: text.hintText.copyWith(
                          color: colors.mutedText,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        instance.title ?? locales.accountDataCardNullValue,
                        style: text.fieldValue,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: spacing.md),
                    Text(
                      instance.resetDay ?? locales.accountDataCardNullValue,
                      style: text.hintText.copyWith(
                        color: colors.bodyText.withValues(alpha: 0.82),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
