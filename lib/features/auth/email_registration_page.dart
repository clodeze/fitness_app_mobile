import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../router/app_router.dart';
import '../../ui_kit/forma_ui_kit.dart';
import 'auth_components.dart';
import 'demo_auth.dart';

enum _RegistrationStep { email, code }

@RoutePage()
class EmailRegistrationPage extends StatefulWidget {
  const EmailRegistrationPage({super.key, this.initialEmail = ''});

  final String initialEmail;

  @override
  State<EmailRegistrationPage> createState() => _EmailRegistrationPageState();
}

class _EmailRegistrationPageState extends State<EmailRegistrationPage> {
  late final TextEditingController _emailController;
  final _codeController = TextEditingController();
  _RegistrationStep _step = _RegistrationStep.email;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _back() {
    if (_step == _RegistrationStep.code) {
      setState(() => _step = _RegistrationStep.email);
    } else {
      context.router.maybePop();
    }
  }

  void _continue() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_step == _RegistrationStep.email) {
      if (!DemoAuth.isValidEmail(_emailController.text)) {
        _showMessage('Введите корректную почту');
        return;
      }
      setState(() => _step = _RegistrationStep.code);
      _showMessage('Демо-код: ${DemoAuth.verificationCode}');
      return;
    }

    if (!DemoAuth.isValidCode(_codeController.text)) {
      _showMessage('Неверный код. Демо-код: ${DemoAuth.verificationCode}');
      return;
    }
    context.router.push(const PersonalDetailsRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final contentWidth = math.min(334.0, constraints.maxWidth - 56);
            return Center(
              child: SizedBox(
                width: contentWidth,
                height: constraints.maxHeight,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 2),
                      AuthHeader(onBack: _back),
                      const SizedBox(height: 33),
                      Text(
                        'Регистрация',
                        textAlign: TextAlign.center,
                        style: FormaType.heading,
                      ),
                      const SizedBox(height: 80),
                      FormaTextField(
                        key: ValueKey(_step),
                        label: _step == _RegistrationStep.email
                            ? 'ПОЧТА'
                            : 'ВВЕДИТЕ КОД ИЗ ПОЧТЫ',
                        labelGap: 18,
                        controller: _step == _RegistrationStep.email
                            ? _emailController
                            : _codeController,
                        keyboardType: _step == _RegistrationStep.email
                            ? TextInputType.emailAddress
                            : TextInputType.number,
                        obscureText: _step == _RegistrationStep.code,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _continue(),
                      ),
                      const SizedBox(height: 72),
                      FormaFilledButton(
                        label: _step == _RegistrationStep.email
                            ? 'Отправить код'
                            : 'Регистрация',
                        onPressed: _continue,
                      ),
                      const SizedBox(height: 16),
                      AuthSocialOptions(
                        onProviderSelected: (provider) => _showMessage(
                          'Демо: ${provider.name} пока недоступен',
                        ),
                      ),
                      const SizedBox(height: 26),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
