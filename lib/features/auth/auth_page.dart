import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../ui_kit/forma_ui_kit.dart';
import 'auth_components.dart';
import 'demo_auth.dart';
import '../dashboard/demo_dashboard_store.dart';
import '../../router/app_router.dart';

@RoutePage()
class AuthPage extends StatefulWidget {
  const AuthPage({super.key, this.initialMode = AuthMode.registration});

  final AuthMode initialMode;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late AuthMode _mode;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _continue() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (_mode == AuthMode.registration && name.isEmpty) {
      _showMessage('Введите имя');
      return;
    }
    if (!DemoAuth.isValidEmail(email)) {
      _showMessage('Введите корректную почту');
      return;
    }
    if (password.length < 8) {
      _showMessage('Пароль должен содержать минимум 8 символов');
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();
    DemoDashboardScope.of(context).setProfile(name: name, email: email);
    if (_mode == AuthMode.registration) {
      context.router.push(EmailRegistrationRoute(initialEmail: email));
    } else {
      context.router.replaceAll([const MainShellRoute()]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final bottomSpace = math.max(0.0, 32 - bottomInset);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final contentWidth = math.min(334.0, constraints.maxWidth - 56);
            return Center(
              child: SizedBox(
                width: contentWidth,
                height: constraints.maxHeight,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 2),
                          AuthHeader(onBack: () => context.router.maybePop()),
                          const SizedBox(height: 36),
                          Text(
                            'Создай\nаккаунт',
                            style: FormaType.heading.copyWith(
                              fontSize: 31,
                              height: 1.08,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Пара минут на анкету, и план будет готов.',
                            style: FormaType.body.copyWith(
                              fontSize: 13,
                              color: FormaColors.muted,
                            ),
                          ),
                          const SizedBox(height: 36),
                          AuthModeSegment(
                            mode: _mode,
                            onChanged: (mode) => setState(() => _mode = mode),
                          ),
                          const SizedBox(height: 20),
                          FormaTextField(
                            label: 'ИМЯ',
                            labelGap: 18,
                            controller: _nameController,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 6),
                          FormaTextField(
                            label: 'ПОЧТА',
                            labelGap: 18,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 6),
                          FormaTextField(
                            label: _mode == AuthMode.registration
                                ? 'ПРИДУМАЙТЕ ПАРОЛЬ'
                                : 'ПАРОЛЬ',
                            labelGap: 18,
                            controller: _passwordController,
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _continue(),
                          ),
                          if (_mode == AuthMode.signIn)
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => context.router.push(
                                  const PasswordResetRoute(),
                                ),
                                child: const Text('Забыли пароль?'),
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
                            AuthSocialOptions(
                              onProviderSelected: (provider) => _showMessage(
                                'Демо: ${provider.name} пока недоступен',
                              ),
                            ),
                            const SizedBox(height: 16),
                            FormaPrimaryButton(
                              label: 'Продолжить',
                              onPressed: _continue,
                            ),
                            SizedBox(height: bottomSpace),
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
