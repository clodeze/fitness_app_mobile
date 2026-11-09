import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../auth/auth_components.dart';
import '../../router/app_router.dart';
import '../../ui_kit/forma_ui_kit.dart';

@RoutePage()
class StartPage extends StatelessWidget {
  const StartPage({super.key});

  static const _todayCalories = 1450;
  static const _dailyGoal = 2200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final contentWidth = math.min(334.0, constraints.maxWidth - 56);
            final ringSize = math.min(292.0, contentWidth - 42);
            final scale = ringSize / 292;

            return Center(
              child: SizedBox(
                width: contentWidth,
                height: constraints.maxHeight,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          const _BrandHeader(),
                          const SizedBox(height: 34),
                          Text(
                            'ТВОЙ БАЛАНС НА СЕГОДНЯ',
                            style: FormaType.caption.copyWith(height: 1.275),
                          ),
                          const SizedBox(height: 10),
                          FormaSegmentedRing(
                            progress: _todayCalories / _dailyGoal,
                            size: ringSize,
                            center: Padding(
                              padding: EdgeInsets.only(top: 16 * scale),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '1 450',
                                    style: FormaType.number.copyWith(
                                      fontSize: 61.32 * scale,
                                      height: 1.24,
                                      letterSpacing: -2 * scale,
                                    ),
                                  ),
                                  SizedBox(height: 3 * scale),
                                  Text(
                                    'из 2 200 ккал',
                                    style: FormaType.body.copyWith(
                                      fontSize: 17.52 * scale,
                                      color: FormaColors.muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Твоя лучшая\nформа.',
                              style: FormaType.heading.copyWith(
                                fontSize: 34 * math.min(1, contentWidth / 334),
                                color: FormaColors.accent,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              'Тренировки, питание и прогресс —\n'
                              'всё, чтобы быть увереннее в себе.',
                              style: FormaType.body.copyWith(
                                color: FormaColors.muted,
                              ),
                            ),
                            const SizedBox(height: 44),
                            FormaPrimaryButton(
                              label: 'Начать',
                              onPressed: () => context.router.push(AuthRoute()),
                            ),
                            const SizedBox(height: 12),
                            FormaSecondaryButton(
                              label: 'Уже есть аккаунт',
                              height: 42,
                              labelStyle: FormaType.body.copyWith(fontSize: 12),
                              onPressed: () => context.router.push(
                                AuthRoute(initialMode: AuthMode.signIn),
                              ),
                            ),
                            const SizedBox(height: 6),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 9.4,
          height: 9.4,
          decoration: BoxDecoration(
            color: FormaColors.accent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8.5),
        Text(
          'FORMA',
          style: FormaType.heading.copyWith(fontSize: 21, height: 1.24),
        ),
        const Spacer(),
        Text('V 1.0', style: FormaType.caption),
      ],
    );
  }
}
