import 'package:flutter/material.dart';
import 'package:store_management/localization/app_localizations.dart';

class ModulePageView extends StatelessWidget {
  const ModulePageView({super.key, required this.title, required this.icon, required this.description, this.highlights = const []});

  final String title;
  final IconData icon;
  final String description;
  final List<String> highlights;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [colorScheme.surface, colorScheme.surfaceContainerLow]),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [colorScheme.primaryContainer, colorScheme.tertiaryContainer]),
                    boxShadow: [BoxShadow(color: colorScheme.shadow.withValues(alpha: 0.08), blurRadius: 28, offset: const Offset(0, 16))],
                  ),
                  child: Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(color: colorScheme.surface.withValues(alpha: 0.72), borderRadius: BorderRadius.circular(22)),
                        child: Icon(icon, size: 34, color: colorScheme.primary),
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 760),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900, height: 1.05)),
                            const SizedBox(height: 12),
                            Text(description, style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant, height: 1.5)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _ModuleStatusCard(
                      title: l10n.isArabic ? 'الحالة' : 'Status',
                      value: l10n.isArabic ? 'جاهز' : 'Ready',
                      caption: l10n.isArabic ? 'التنقل نشط وهذه الشاشة متصلة.' : 'Navigation is active and this screen is connected.',
                      icon: Icons.check_circle_rounded,
                    ),
                    _ModuleStatusCard(
                      title: l10n.isArabic ? 'المحتوى' : 'Content',
                      value: l10n.isArabic ? 'فارغ' : 'Empty',
                      caption: l10n.isArabic ? 'أضف النماذج والجداول والفلاتر هنا لاحقًا.' : 'Add forms, tables, and filters here next.',
                      icon: Icons.dashboard_customize_rounded,
                    ),
                  ],
                ),
                if (highlights.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(l10n.isArabic ? 'الأقسام المخطط لها' : 'Planned sections', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: highlights
                        .map(
                          (item) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: colorScheme.outlineVariant),
                            ),
                            child: Text(item, style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700)),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModuleStatusCard extends StatelessWidget {
  const _ModuleStatusCard({required this.title, required this.value, required this.caption, required this.icon});

  final String title;
  final String value;
  final String caption;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: 280,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: colorScheme.primaryContainer, borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, color: colorScheme.onPrimaryContainer),
          ),
          const SizedBox(height: 14),
          Text(title, style: theme.textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant)),
          const SizedBox(height: 4),
          Text(value, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(caption, style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant, height: 1.45)),
        ],
      ),
    );
  }
}
