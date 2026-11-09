import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../ui_kit/forma_ui_kit.dart';
import 'demo_auth.dart';

@RoutePage()
class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({super.key});

  @override
  State<PasswordResetPage> createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final _email = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _submit() {
    if (!DemoAuth.isValidEmail(_email.text.trim())) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Введите корректную почту')));
      return;
    }
    setState(() => _sent = true);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 24, 28, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormaRoundIconButton(
              icon: Assets.icons.arrowLeft,
              tooltip: 'Назад',
              dimension: 44,
              onPressed: () => context.router.maybePop(),
            ),
            const SizedBox(height: 26),
            CircleAvatar(
              radius: 38,
              backgroundColor: FormaColors.surface,
              child: Icon(
                Icons.lock_outline,
                color: FormaColors.accent,
                size: 30,
              ),
            ),
            const SizedBox(height: 20),
            Text('Сброс пароля', style: FormaType.heading),
            const SizedBox(height: 12),
            Text(
              'Введи почту, и мы отправим ссылку для нового пароля.',
              style: FormaType.body,
            ),
            const SizedBox(height: 35),
            FormaTextField(
              label: 'ПОЧТА',
              controller: _email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: FormaColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _sent
                    ? 'Демо: ссылка для сброса не отправляется. Почта проверена.'
                    : 'Письмо придёт в течение минуты. Если его нет, проверь папку «Спам».',
                style: FormaType.caption,
              ),
            ),
            const Spacer(),
            FormaPrimaryButton(
              label: _sent ? 'Отправить повторно' : 'Отправить ссылку',
              trailingIcon: Assets.icons.arrowRight,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    ),
  );
}
