import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../ui_kit/forma_ui_kit.dart';

class WeightSelector extends StatefulWidget {
  const WeightSelector({super.key, required this.onChanged});

  final ValueChanged<int?> onChanged;

  @override
  State<WeightSelector> createState() => _WeightSelectorState();
}

class _WeightSelectorState extends State<WeightSelector> {
  static const _minWeight = 20;
  static const _maxWeight = 400;

  final _controller = TextEditingController();
  int? _weight;
  double _dragWeight = 70;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged(String text) {
    final value = int.tryParse(text);
    final valid = value != null && value >= _minWeight && value <= _maxWeight;
    setState(() {
      _weight = valid ? value : null;
      if (valid) _dragWeight = value.toDouble();
    });
    widget.onChanged(_weight);
  }

  void _setWeight(int value) {
    final weight = value.clamp(_minWeight, _maxWeight);
    if (_weight == weight) return;
    final text = weight.toString();
    _controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
    setState(() => _weight = weight);
    widget.onChanged(weight);
  }

  @override
  Widget build(BuildContext context) {
    final centerWeight = _weight ?? 70;
    return Container(
      height: 198,
      decoration: BoxDecoration(
        color: FormaColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final rulerWidth = constraints.maxWidth - 48;
          return Stack(
            children: [
              Positioned(
                left: 24,
                top: 63,
                child: Text('ВЕС', style: FormaType.caption),
              ),
              Positioned(
                right: 24,
                top: 20,
                child: Row(
                  children: [
                    SizedBox(
                      width: 174,
                      height: 75,
                      child: TextField(
                        controller: _controller,
                        onChanged: _onTextChanged,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        maxLength: 3,
                        textAlign: TextAlign.right,
                        textAlignVertical: TextAlignVertical.center,
                        cursorColor: FormaColors.accent,
                        style: FormaType.number.copyWith(fontSize: 59),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          counterText: '',
                          hintText: '—',
                          hintStyle: FormaType.number.copyWith(
                            fontSize: 59,
                            color: FormaColors.muted,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'КГ',
                      style: FormaType.body.copyWith(
                        fontSize: 15,
                        color: FormaColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 24,
                right: 24,
                top: 101,
                height: 61,
                child: Semantics(
                  label: 'Вес',
                  value: _weight == null ? 'Не указан' : '$_weight килограммов',
                  increasedValue: '${centerWeight + 1} килограммов',
                  decreasedValue: '${centerWeight - 1} килограммов',
                  onIncrease: () => _setWeight(centerWeight + 1),
                  onDecrease: () => _setWeight(centerWeight - 1),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onHorizontalDragStart: (_) {
                      _dragWeight = centerWeight.toDouble();
                    },
                    onHorizontalDragUpdate: (details) {
                      _dragWeight =
                          (_dragWeight - details.delta.dx * 20 / rulerWidth)
                              .clamp(
                                _minWeight.toDouble(),
                                _maxWeight.toDouble(),
                              );
                      _setWeight(_dragWeight.round());
                    },
                    onTapUp: (details) {
                      final delta = details.localPosition.dx - rulerWidth / 2;
                      _setWeight(
                        (centerWeight + delta * 20 / rulerWidth).round(),
                      );
                    },
                    child: Stack(
                      children: [
                        Positioned(
                          top: 11,
                          left: 0,
                          right: 0,
                          height: 42,
                          child: CustomPaint(painter: _WeightRulerPainter()),
                        ),
                        Center(
                          child: Container(
                            width: 2,
                            height: 61,
                            color: FormaColors.accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 24,
                right: 24,
                top: 166,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (var offset = -10; offset <= 10; offset += 5)
                      Text(
                        '${centerWeight + offset}',
                        style: FormaType.caption.copyWith(
                          color: offset == 0 && _weight != null
                              ? FormaColors.accent
                              : FormaColors.muted,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _WeightRulerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = FormaColors.muted.withValues(alpha: 0.55)
      ..strokeWidth = 1;
    for (var index = 0; index <= 32; index++) {
      final x = index * size.width / 32;
      final length = index % 4 == 0 ? 30.0 : 15.0;
      canvas.drawLine(
        Offset(x, size.height - length),
        Offset(x, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WeightRulerPainter oldDelegate) => false;
}
