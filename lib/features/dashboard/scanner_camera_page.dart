import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../router/app_router.dart';
import '../../ui_kit/forma_ui_kit.dart';
import 'dashboard_style.dart';
import 'food_analysis_confirmation_page.dart';
import 'food_analysis_service.dart';
import 'food_plate.dart';
import 'scanner_fallback_page.dart';

@RoutePage()
class ScannerCameraPage extends StatefulWidget {
  const ScannerCameraPage({super.key, required this.day});
  final int day;

  @override
  State<ScannerCameraPage> createState() => _ScannerCameraPageState();
}

class _ScannerCameraPageState extends State<ScannerCameraPage> {
  final ImagePicker _imagePicker = ImagePicker();
  bool _busy = false;
  String _busyMessage = 'Открываем камеру…';

  Future<void> _selectAndAnalyzeImage(ImageSource source) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _busyMessage = source == ImageSource.camera
          ? 'Открываем камеру…'
          : 'Открываем фотографии…';
    });

    try {
      final image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 2048,
      );
      if (image == null || !mounted) return;

      setState(() => _busyMessage = 'Распознаём блюдо…');
      final analysis = await const FoodAnalysisService().analyze(image);
      if (!mounted) return;

      final saved = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => FoodAnalysisConfirmationPage(
            day: widget.day,
            imagePath: image.path,
            analysis: analysis,
          ),
        ),
      );
      if (saved == true && mounted) {
        await context.router.maybePop();
      }
    } on FoodAnalysisException catch (error) {
      _showError(error.message);
    } on TimeoutException {
      _showError('Сервер долго не отвечает. Попробуй ещё раз.');
    } on MissingPluginException {
      _showError('Плагин фото не подключён. Пересобери приложение.');
    } on PlatformException {
      _showError('Не удалось открыть камеру или фотографии. Проверь разрешения.');
    } on FormatException {
      _showError('Сервер вернул данные распознавания в неверном формате.');
    } on FileSystemException {
      _showError('Не удалось прочитать выбранное фото.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          AbsorbPointer(
            absorbing: _busy,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 11, 24, 0),
                  child: Row(
                    children: [
                      FormaRoundIconButton(
                        icon: Assets.icons.x,
                        tooltip: 'Закрыть',
                        dimension: 44,
                        onPressed: () => context.router.maybePop(),
                      ),
                      Expanded(
                        child: Center(
                          child: PopupMenuButton<ScannerFallbackType>(
                            tooltip: 'Демо-состояния сканера',
                            onSelected: (type) => context.router.push(
                              ScannerFallbackRoute(
                                type: type,
                                day: widget.day,
                              ),
                            ),
                            itemBuilder: (_) => const [
                              PopupMenuItem(
                                value: ScannerFallbackType.permission,
                                child: Text('Доступ к камере'),
                              ),
                              PopupMenuItem(
                                value: ScannerFallbackType.recognition,
                                child: Text('Не удалось распознать'),
                              ),
                              PopupMenuItem(
                                value: ScannerFallbackType.offline,
                                child: Text('Нет соединения'),
                              ),
                            ],
                            child: Text(
                              'AI-СКАНЕР',
                              style: DashboardStyle.small,
                            ),
                          ),
                        ),
                      ),
                      FormaRoundIconButton(
                        icon: Assets.icons.zap,
                        tooltip: 'Вспышка камеры',
                        dimension: 44,
                        onPressed: () => ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Вспышку можно включить на экране камеры',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: FormaColors.muted),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircleAvatar(
                        radius: 3,
                        backgroundColor: FormaColors.accent,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Блюдо в кадре',
                        style: DashboardStyle.body.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: CustomPaint(
                          size: const Size.square(278),
                          painter: FoodPlatePainter(),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 146,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: FormaColors.line)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FormaRoundIconButton(
                        icon: Assets.icons.image,
                        tooltip: 'Выбрать фото',
                        dimension: 50,
                        iconSize: 32,
                        onPressed: () =>
                            _selectAndAnalyzeImage(ImageSource.gallery),
                      ),
                      Tooltip(
                        message: 'Сделать фото',
                        child: Material(
                          color: FormaColors.accent,
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () =>
                                _selectAndAnalyzeImage(ImageSource.camera),
                            child: const SizedBox.square(dimension: 68),
                          ),
                        ),
                      ),
                      FormaRoundIconButton(
                        icon: Assets.icons.scanLine,
                        tooltip: 'Штрихкод',
                        dimension: 50,
                        iconSize: 32,
                        onPressed: () => ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Сканирование штрихкода появится позже',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_busy)
            ColoredBox(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(
                      color: FormaColors.accent,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _busyMessage,
                      style: DashboardStyle.body,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    ),
  );
}
