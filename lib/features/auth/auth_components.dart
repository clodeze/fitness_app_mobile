import 'package:flutter/material.dart';

import '../../ui_kit/forma_ui_kit.dart';

enum AuthMode { registration, signIn }

enum AuthProvider { google, apple }

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: FormaRoundIconButton(
              icon: Assets.icons.arrowLeft,
              tooltip: 'Назад',
              dimension: 40,
              iconSize: 20,
              onPressed: onBack,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7.2,
                height: 7.2,
                decoration: BoxDecoration(
                  color: FormaColors.accent,
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'FORMA',
                style: FormaType.heading.copyWith(fontSize: 16, height: 1.24),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AuthModeSegment extends StatelessWidget {
  const AuthModeSegment({
    super.key,
    required this.mode,
    required this.onChanged,
  });

  final AuthMode mode;
  final ValueChanged<AuthMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: FormaColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          _tab(AuthMode.registration, 'Регистрация'),
          const SizedBox(width: 4),
          _tab(AuthMode.signIn, 'Вход'),
        ],
      ),
    );
  }

  Widget _tab(AuthMode value, String label) {
    final selected = mode == value;
    return Expanded(
      child: Semantics(
        selected: selected,
        child: Material(
          color: selected ? FormaColors.text : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => onChanged(value),
            child: Center(
              child: Text(
                label,
                style: FormaType.body.copyWith(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected ? FormaColors.ink : FormaColors.muted,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthSocialOptions extends StatelessWidget {
  const AuthSocialOptions({super.key, required this.onProviderSelected});

  final ValueChanged<AuthProvider> onProviderSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: FormaColors.line, height: 1)),
            const SizedBox(width: 14),
            Text('или', style: FormaType.caption),
            const SizedBox(width: 14),
            Expanded(child: Divider(color: FormaColors.line, height: 1)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _providerButton(AuthProvider.google, 'Google')),
            const SizedBox(width: 10),
            Expanded(child: _providerButton(AuthProvider.apple, 'Apple')),
          ],
        ),
      ],
    );
  }

  Widget _providerButton(AuthProvider provider, String label) {
    return FormaSecondaryButton(
      label: label,
      height: 48,
      labelStyle: FormaType.body.copyWith(fontSize: 12),
      onPressed: () => onProviderSelected(provider),
    );
  }
}
