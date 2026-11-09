import 'package:flutter/material.dart';

import 'router/app_router.dart';
import 'features/dashboard/demo_dashboard_store.dart';
import 'ui_kit/forma_ui_kit.dart';

void main() {
  runApp(const FormaApp());
}

class FormaApp extends StatefulWidget {
  const FormaApp({super.key});

  @override
  State<FormaApp> createState() => _FormaAppState();
}

class _FormaAppState extends State<FormaApp> {
  final _router = AppRouter();
  final _dashboard = DemoDashboardStore();

  @override
  void dispose() {
    _router.dispose();
    _dashboard.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _dashboard,
      builder: (context, _) {
        FormaColors.light = _dashboard.themeMode == ThemeMode.light;
        return DemoDashboardScope(
          store: _dashboard,
          child: MaterialApp.router(
            title: 'FORMA',
            debugShowCheckedModeBanner: false,
            theme: FormaTheme.data,
            routerConfig: _router.config(),
          ),
        );
      },
    );
  }
}
