import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../router/app_router.dart';
import '../../ui_kit/forma_ui_kit.dart';
import 'dashboard_format.dart';
import 'dashboard_style.dart';
import 'demo_dashboard_store.dart';
import 'profile_detail_page.dart';
import 'weight_trend_chart.dart';

@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = DemoDashboardScope.of(context);
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        children: [
          Row(
            children: [
              Expanded(child: Text('Профиль', style: DashboardStyle.title)),
              IconButton(
                onPressed: () => context.router.root.push(
                  ProfileDetailRoute(section: ProfileSection.settings),
                ),
                icon: Icon(Icons.settings_outlined, color: FormaColors.muted),
                tooltip: 'Настройки',
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Container(
                width: 72,
                height: 72,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: FormaColors.surface,
                  border: Border.all(color: FormaColors.accent),
                ),
                child: Text(
                  (store.profileName.isEmpty ? 'Н' : store.profileName[0])
                      .toUpperCase(),
                  style: DashboardStyle.title.copyWith(
                    color: FormaColors.accent,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.profileName.isEmpty ? '—' : store.profileName,
                    style: DashboardStyle.body.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    store.profileEmail.isEmpty ? '—' : store.profileEmail,
                    style: DashboardStyle.muted,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: FormaColors.surface,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('ВЕС', style: DashboardStyle.small),
                    const Spacer(),
                    Text(
                      '-1,4 кг за неделю',
                      style: DashboardStyle.small.copyWith(
                        color: FormaColors.accent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: formatWeight(store.weightKg),
                        style: DashboardStyle.metric.copyWith(fontSize: 32),
                      ),
                      TextSpan(text: '  кг', style: DashboardStyle.muted),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: WeightTrendChart(height: 48),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Цель ${store.targetWeightKg.round()} кг · 3 / 3',
                      style: DashboardStyle.small,
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => context.router.root.push(
                        ProfileDetailRoute(section: ProfileSection.progress),
                      ),
                      child: Text(
                        'Подробнее',
                        style: DashboardStyle.small.copyWith(
                          color: FormaColors.accent,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Material(
            color: FormaColors.accent,
            borderRadius: BorderRadius.circular(24),
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => context.router.root.push(
                ProfileDetailRoute(section: ProfileSection.premium),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'FORMA Premium',
                            style: DashboardStyle.body.copyWith(
                              color: FormaColors.ink,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Больше возможностей для результата',
                            style: DashboardStyle.small.copyWith(
                              color: FormaColors.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      radius: 21,
                      backgroundColor: FormaColors.ink,
                      child: FormaIcon(
                        glyph: Assets.icons.arrowRight,
                        color: FormaColors.accent,
                        size: 19,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          _ProfileLink(
            icon: Icons.person_outline,
            label: 'Редактировать аккаунт',
            onTap: () => context.router.root.push(
              ProfileDetailRoute(section: ProfileSection.account),
            ),
          ),
          _ProfileLink(
            icon: Icons.shield_outlined,
            label: 'Здоровье и анализы',
            onTap: () => context.router.root.push(
              ProfileDetailRoute(section: ProfileSection.health),
            ),
          ),
          _ProfileLink(
            icon: Icons.track_changes_outlined,
            label: 'Цели и нормы КБЖУ',
            onTap: () => context.router.root.push(
              ProfileDetailRoute(section: ProfileSection.goals),
            ),
          ),
          _ProfileLink(
            icon: Icons.fitness_center_outlined,
            label: 'План тренировок',
            onTap: () =>
                context.router.root.push(const WorkoutGeneratorRoute()),
          ),
          _ProfileLink(
            icon: Icons.notifications_none_outlined,
            label: 'Напоминания',
            onTap: () => context.router.root.push(
              ProfileDetailRoute(section: ProfileSection.reminders),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileLink extends StatelessWidget {
  const _ProfileLink({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: FormaColors.background,
    child: InkWell(
      onTap: onTap,
      child: Container(
        height: 57,
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: FormaColors.line)),
        ),
        child: Row(
          children: [
            Icon(icon, color: FormaColors.accent, size: 20),
            const SizedBox(width: 16),
            Expanded(child: Text(label, style: DashboardStyle.body)),
            Icon(Icons.chevron_right, color: FormaColors.muted, size: 18),
          ],
        ),
      ),
    ),
  );
}
