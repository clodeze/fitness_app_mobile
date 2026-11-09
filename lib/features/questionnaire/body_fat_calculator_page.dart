import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../ui_kit/forma_ui_kit.dart';
import '../dashboard/demo_dashboard_store.dart';

@RoutePage()
class BodyFatCalculatorPage extends StatefulWidget {
  const BodyFatCalculatorPage({super.key});

  @override
  State<BodyFatCalculatorPage> createState() => _BodyFatCalculatorPageState();
}

class _BodyFatCalculatorPageState extends State<BodyFatCalculatorPage> {
  bool _female = false;
  final _height = TextEditingController(text: '175');
  final _waist = TextEditingController(text: '84');
  final _neck = TextEditingController(text: '38');
  final _hip = TextEditingController(text: '95');

  @override
  void dispose() {
    _height.dispose();
    _waist.dispose();
    _neck.dispose();
    _hip.dispose();
    super.dispose();
  }

  int? get _result {
    final height = double.tryParse(_height.text);
    final waist = double.tryParse(_waist.text);
    final neck = double.tryParse(_neck.text);
    final hip = double.tryParse(_hip.text);
    if (height == null ||
        waist == null ||
        neck == null ||
        height <= 0 ||
        waist <= neck) {
      return null;
    }
    final circumference = _female ? waist + (hip ?? 0) - neck : waist - neck;
    if (circumference <= 0 || _female && (hip == null || hip <= 0)) return null;
    final denominator = _female
        ? 1.29579 -
              0.35004 * (math.log(circumference) / math.ln10) +
              0.22100 * (math.log(height) / math.ln10)
        : 1.0324 -
              0.19077 * (math.log(circumference) / math.ln10) +
              0.15456 * (math.log(height) / math.ln10);
    final percent = 495 / denominator - 450;
    return percent.isFinite && percent > 0 && percent < 75
        ? percent.round()
        : null;
  }

  void _useResult() {
    final result = _result;
    if (result == null) return;
    DemoDashboardScope.of(context).bodyFatPercent = result;
    context.router.pop(result);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FormaRoundIconButton(
                  icon: Assets.icons.arrowLeft,
                  tooltip: 'Назад',
                  dimension: 44,
                  onPressed: () => context.router.maybePop(),
                ),
                Expanded(
                  child: Center(
                    child: Text('КАЛЬКУЛЯТОР', style: FormaType.caption),
                  ),
                ),
                const SizedBox(width: 44),
              ],
            ),
            const SizedBox(height: 25),
            Text(
              'Процент жира',
              style: FormaType.heading.copyWith(fontSize: 29),
            ),
            const SizedBox(height: 10),
            Text(
              'Измерь талию и шею мягкой лентой. Метод US Navy.',
              style: FormaType.body.copyWith(color: FormaColors.muted),
            ),
            const SizedBox(height: 20),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('Мужчина')),
                ButtonSegment(value: true, label: Text('Женщина')),
              ],
              selected: {_female},
              onSelectionChanged: (v) => setState(() => _female = v.first),
            ),
            const SizedBox(height: 22),
            _Measure(
              label: 'РОСТ',
              controller: _height,
              onChanged: () => setState(() {}),
            ),
            _Measure(
              label: 'ТАЛИЯ',
              controller: _waist,
              onChanged: () => setState(() {}),
            ),
            _Measure(
              label: 'ШЕЯ',
              controller: _neck,
              onChanged: () => setState(() {}),
            ),
            if (_female)
              _Measure(
                label: 'БЁДРА',
                controller: _hip,
                onChanged: () => setState(() {}),
              ),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: FormaColors.surface,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('ТВОЙ РЕЗУЛЬТАТ', style: FormaType.caption),
                      const Spacer(),
                      Text(
                        _result == null ? '—' : '${_result!} %',
                        style: FormaType.number.copyWith(fontSize: 34),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: ((_result ?? 0) / 40).clamp(0, 1),
                    color: FormaColors.accent,
                    backgroundColor: FormaColors.raised,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Это оценка по окружностям тела, а не медицинское измерение.',
                    style: FormaType.caption,
                  ),
                ],
              ),
            ),
            const Spacer(),
            FormaPrimaryButton(
              label: _result == null
                  ? 'Заполни измерения'
                  : 'Использовать ${_result!} %',
              trailingIcon: Assets.icons.check,
              onPressed: _result == null ? null : _useResult,
            ),
            Center(
              child: TextButton(
                onPressed: () => context.router.maybePop(),
                child: const Text('Ввести вручную'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _Measure extends StatelessWidget {
  const _Measure({
    required this.label,
    required this.controller,
    required this.onChanged,
  });
  final String label;
  final TextEditingController controller;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Expanded(child: Text(label, style: FormaType.caption)),
        SizedBox(
          width: 90,
          child: TextField(
            controller: controller,
            onChanged: (_) => onChanged(),
            textAlign: TextAlign.end,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              suffixText: 'см',
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    ),
  );
}
