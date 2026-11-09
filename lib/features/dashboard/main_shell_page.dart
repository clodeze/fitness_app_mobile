import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../router/app_router.dart';
import '../../ui_kit/forma_ui_kit.dart';
import 'dashboard_style.dart';

@RoutePage()
class MainShellPage extends StatelessWidget {
  const MainShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: const [HomeRoute(), NutritionRoute(), GymRoute(), ProfileRoute()],
      backgroundColor: FormaColors.background,
      bottomNavigationBuilder: (context, tabsRouter) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
          child: FormaBottomNavigation(
            selected: FormaTab.values[tabsRouter.activeIndex],
            labelStyle: DashboardStyle.small.copyWith(fontSize: 11),
            onSelected: (tab) => tabsRouter.setActiveIndex(tab.index),
          ),
        ),
      ),
    );
  }
}
