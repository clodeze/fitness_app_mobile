// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/arrow-left.svg
  SvgGenImage get arrowLeft => const SvgGenImage('assets/icons/arrow-left.svg');

  /// File path: assets/icons/arrow-right.svg
  SvgGenImage get arrowRight =>
      const SvgGenImage('assets/icons/arrow-right.svg');

  /// File path: assets/icons/camera.svg
  SvgGenImage get camera => const SvgGenImage('assets/icons/camera.svg');

  /// File path: assets/icons/check.svg
  SvgGenImage get check => const SvgGenImage('assets/icons/check.svg');

  /// File path: assets/icons/chevron-down.svg
  SvgGenImage get chevronDown =>
      const SvgGenImage('assets/icons/chevron-down.svg');

  /// File path: assets/icons/dumbbell.svg
  SvgGenImage get dumbbell => const SvgGenImage('assets/icons/dumbbell.svg');

  /// File path: assets/icons/flame.svg
  SvgGenImage get flame => const SvgGenImage('assets/icons/flame.svg');

  /// File path: assets/icons/house.svg
  SvgGenImage get house => const SvgGenImage('assets/icons/house.svg');

  /// File path: assets/icons/image.svg
  SvgGenImage get image => const SvgGenImage('assets/icons/image.svg');

  /// File path: assets/icons/minus.svg
  SvgGenImage get minus => const SvgGenImage('assets/icons/minus.svg');

  /// File path: assets/icons/pencil.svg
  SvgGenImage get pencil => const SvgGenImage('assets/icons/pencil.svg');

  /// File path: assets/icons/person-standing.svg
  SvgGenImage get personStanding =>
      const SvgGenImage('assets/icons/person-standing.svg');

  /// File path: assets/icons/play.svg
  SvgGenImage get play => const SvgGenImage('assets/icons/play.svg');

  /// File path: assets/icons/plus.svg
  SvgGenImage get plus => const SvgGenImage('assets/icons/plus.svg');

  /// File path: assets/icons/rotate-ccw.svg
  SvgGenImage get rotateCcw => const SvgGenImage('assets/icons/rotate-ccw.svg');

  /// File path: assets/icons/scan-line.svg
  SvgGenImage get scanLine => const SvgGenImage('assets/icons/scan-line.svg');

  /// File path: assets/icons/search.svg
  SvgGenImage get search => const SvgGenImage('assets/icons/search.svg');

  /// File path: assets/icons/user-round.svg
  SvgGenImage get userRound => const SvgGenImage('assets/icons/user-round.svg');

  /// File path: assets/icons/utensils.svg
  SvgGenImage get utensils => const SvgGenImage('assets/icons/utensils.svg');

  /// File path: assets/icons/x.svg
  SvgGenImage get x => const SvgGenImage('assets/icons/x.svg');

  /// File path: assets/icons/zap.svg
  SvgGenImage get zap => const SvgGenImage('assets/icons/zap.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
    arrowLeft,
    arrowRight,
    camera,
    check,
    chevronDown,
    dumbbell,
    flame,
    house,
    image,
    minus,
    pencil,
    personStanding,
    play,
    plus,
    rotateCcw,
    scanLine,
    search,
    userRound,
    utensils,
    x,
    zap,
  ];
}

abstract final class Assets {
  static const $AssetsIconsGen icons = $AssetsIconsGen();
}

class SvgGenImage {
  const SvgGenImage(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = false;

  const SvgGenImage.vec(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    _svg.ColorMapper? colorMapper,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
        colorMapper: colorMapper,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter:
          colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
