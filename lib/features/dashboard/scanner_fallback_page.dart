import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../router/app_router.dart';
import '../../ui_kit/forma_ui_kit.dart';
import 'dashboard_style.dart';

enum ScannerFallbackType { permission, recognition, offline }

@RoutePage()
class ScannerFallbackPage extends StatelessWidget {
  const ScannerFallbackPage({super.key, required this.type, required this.day});

  final ScannerFallbackType type;
  final int day;

  @override
  Widget build(BuildContext context) {
    final title = switch (type) {
      ScannerFallbackType.permission => 'Нужен доступ к камере',
      ScannerFallbackType.recognition => 'Не удалось\nраспознать еду',
      ScannerFallbackType.offline => 'Нет соединения',
    };
    final description = switch (type) {
      ScannerFallbackType.permission =>
        'Камера нужна, чтобы определять блюдо по фото и показывать КБЖУ.',
      ScannerFallbackType.recognition => 'Попробуй снять сверху при хорошем свете, чтобы вся тарелка была в кадре. Или найди блюдо вручную.',
      ScannerFallbackType.offline => 'Дневник и тренировки доступны без сети. Сканер и синхронизация заработают, когда интернет появится.',
    };
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: FormaRoundIconButton(
                  icon: Assets.icons.arrowLeft,
                  tooltip: 'Назад',
                  dimension: 44,
                  onPressed: () => context.router.maybePop(),
                ),
              ),
              const Spacer(),
              Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(
                  color: FormaColors.surface,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Icon(
                    switch (type) {
                      ScannerFallbackType.permission =>
                        Icons.camera_alt_outlined,
                      ScannerFallbackType.recognition =>
                        Icons.center_focus_weak,
                      ScannerFallbackType.offline => Icons.wifi_off,
                    },
                    size: 75,
                    color: FormaColors.accent,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                title,
                textAlign: TextAlign.center,
                style: DashboardStyle.title.copyWith(fontSize: 27),
              ),
              const SizedBox(height: 15),
              Text(
                description,
                textAlign: TextAlign.center,
                style: DashboardStyle.muted.copyWith(fontSize: 14),
              ),
              if (type == ScannerFallbackType.recognition) ...[
                const SizedBox(height: 22),
                for (final tip in const [
                  'Больше света, без бликов',
                  'Блюдо целиком в рамке',
                  'Одно блюдо за раз',
                ])
                  ListTile(
                    leading: Icon(
                      Icons.circle,
                      size: 6,
                      color: FormaColors.accent,
                    ),
                    title: Text(tip, style: DashboardStyle.body),
                  ),
              ],
              const Spacer(),
              FormaPrimaryButton(
                label: switch (type) {
                  ScannerFallbackType.permission => 'Разрешить',
                  ScannerFallbackType.recognition => 'Снять ещё раз',
                  ScannerFallbackType.offline => 'Повторить',
                },
                trailingIcon: Assets.icons.arrowRight,
                onPressed: () {
                  if (type == ScannerFallbackType.offline) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('В демо сеть не проверяется'),
                      ),
                    );
                  } else {
                    context.router.replace(ScannerCameraRoute(day: day));
                  }
                },
              ),
              TextButton(
                onPressed: () {
                  if (type == ScannerFallbackType.offline) {
                    context.router.replaceAll([const MainShellRoute()]);
                  } else {
                    context.router.replace(AddFoodRoute(day: day));
                  }
                },
                child: Text(
                  type == ScannerFallbackType.offline
                      ? 'Открыть дневник офлайн'
                      : 'Добавить еду вручную',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
