import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../router/app_router.dart';
import '../../ui_kit/forma_ui_kit.dart';
import 'questionnaire_data.dart';
import 'questionnaire_header.dart';
import 'weight_selector.dart';
import '../dashboard/demo_dashboard_store.dart';

@RoutePage()
class ParametersPage extends StatefulWidget {
  const ParametersPage({super.key});

  @override
  State<ParametersPage> createState() => _ParametersPageState();
}

class _ParametersPageState extends State<ParametersPage> {
  int? _weightKg;
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();
  final _bodyFatController = TextEditingController();

  String _ageUnit(int? age) {
    if (age == null) return 'лет';
    final lastTwo = age % 100;
    if (lastTwo >= 11 && lastTwo <= 14) return 'лет';
    return switch (age % 10) {
      1 => 'год',
      2 || 3 || 4 => 'года',
      _ => 'лет',
    };
  }

  @override
  void dispose() {
    _heightController.dispose();
    _ageController.dispose();
    _bodyFatController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _showBodyFatHelp() async {
    final result = await context.router.push<int>(
      const BodyFatCalculatorRoute(),
    );
    if (result != null && mounted) _bodyFatController.text = '$result';
  }

  void _next() {
    final height = int.tryParse(_heightController.text);
    final age = int.tryParse(_ageController.text);
    final fatText = _bodyFatController.text.trim();
    final fat = fatText.isEmpty ? null : int.tryParse(fatText);

    if (_weightKg == null) {
      _showMessage('Укажи вес');
      return;
    }
    if (height == null || height <= 0) {
      _showMessage('Укажи рост в сантиметрах');
      return;
    }
    if (age == null || age <= 0) {
      _showMessage('Укажи возраст');
      return;
    }
    if (fatText.isNotEmpty && (fat == null || fat < 0 || fat > 100)) {
      _showMessage('Укажи процент жира от 0 до 100');
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();
    DemoDashboardScope.of(context)
        .setBodyParameters(height: height, age: age, fat: fat);
    context.router.push(
      GoalRoute(
        parameters: BodyParameters(
          weightKg: _weightKg!,
          heightCm: height,
          ageYears: age,
          bodyFatPercent: fat,
        ),
      ),
    );
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
                          QuestionnaireHeader(
                            step: 2,
                            onBack: () => context.router.maybePop(),
                          ),
                          const SizedBox(height: 26),
                          Text(
                            'Твои\nпараметры',
                            style: FormaType.heading.copyWith(
                              fontSize: 31,
                              height: 1.08,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Это нам поможет точнее рассчитать нагрузку\n'
                            'и баланс питания под тебя.',
                            style: FormaType.body.copyWith(
                              fontSize: 13,
                              color: FormaColors.muted,
                            ),
                          ),
                          const SizedBox(height: 27),
                          WeightSelector(
                            onChanged: (weight) => _weightKg = weight,
                          ),
                          const SizedBox(height: 24),
                          _MeasurementRow(
                            label: 'РОСТ',
                            unit: 'см',
                            controller: _heightController,
                          ),
                          ValueListenableBuilder<TextEditingValue>(
                            valueListenable: _ageController,
                            builder: (context, value, child) => _MeasurementRow(
                              label: 'ВОЗРАСТ',
                              unit: _ageUnit(int.tryParse(value.text)),
                              controller: _ageController,
                            ),
                          ),
                          _MeasurementRow(
                            label: '% ЖИРА',
                            unit: '%',
                            controller: _bodyFatController,
                            onHelp: _showBodyFatHelp,
                          ),
                          Divider(color: FormaColors.line, height: 1),
                        ],
                      ),
                    ),
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 95,
                                  child: FormaSecondaryButton(
                                    label: 'Назад',
                                    labelStyle: FormaType.body.copyWith(
                                      fontSize: 13,
                                    ),
                                    onPressed: () => context.router.maybePop(),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: FormaPrimaryButton(
                                    label: 'Далее',
                                    onPressed: _next,
                                  ),
                                ),
                              ],
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

class _MeasurementRow extends StatelessWidget {
  const _MeasurementRow({
    required this.label,
    required this.unit,
    required this.controller,
    this.onHelp,
  });

  final String label;
  final String unit;
  final TextEditingController controller;
  final VoidCallback? onHelp;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: FormaColors.line)),
      ),
      child: Row(
        children: [
          Text(label, style: FormaType.caption),
          const Spacer(),
          if (onHelp != null) ...[
            OutlinedButton(
              onPressed: onHelp,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: FormaColors.focusedLine),
                shape: const StadiumBorder(),
                foregroundColor: FormaColors.accent,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                minimumSize: const Size(0, 24),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Как измерить',
                style: FormaType.body.copyWith(
                  fontSize: 10,
                  color: FormaColors.accent,
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          SizedBox(
            width: onHelp == null ? 70 : 52,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              maxLength: 3,
              textAlign: TextAlign.right,
              cursorColor: FormaColors.accent,
              style: FormaType.number.copyWith(fontSize: 21, letterSpacing: -1),
              decoration: InputDecoration(
                border: InputBorder.none,
                counterText: '',
                hintText: '—',
                hintStyle: FormaType.number.copyWith(
                  fontSize: 21,
                  color: FormaColors.muted,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            unit,
            style: FormaType.body.copyWith(
              fontSize: 13,
              color: FormaColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}
