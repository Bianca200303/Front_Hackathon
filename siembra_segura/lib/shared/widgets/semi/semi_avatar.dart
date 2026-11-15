import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:siembra_segura/core/theme/app_palette.dart';
import 'package:siembra_segura/shared/widgets/semi/semi_painter.dart';

/// Semi, el personaje asistente, con vida propia: parpadea cada pocos
/// segundos, saluda con el brazo al aparecer contento y da un saltito al
/// cambiar de expresión.
///
/// Si el sistema pide reducir animaciones, se muestra quieto.
///
/// No hay animaciones en bucle: cada una dura menos de un segundo y la
/// siguiente se programa con un temporizador, así la pantalla queda en
/// reposo entre gestos (y las pruebas pueden esperar a que se asiente).
class SemiAvatar extends StatefulWidget {
  /// Crea a Semi de cuerpo entero.
  const SemiAvatar({
    required this.expression,
    this.size = 96,
    this.semanticLabel,
    super.key,
  }) : headOnly = false,
       haloed = false;

  /// Solo la cabeza dentro de un círculo verde claro, para avatares
  /// pequeños (cabeceras, burbujas).
  const SemiAvatar.head({
    required this.expression,
    this.size = 40,
    this.semanticLabel,
    super.key,
  }) : headOnly = true,
       haloed = true;

  /// Expresión actual.
  final SemiExpression expression;

  /// Alto en dp (el ancho se ajusta a la proporción del dibujo).
  final double size;

  /// Descripción para lectores de pantalla; si es nula, Semi es decorativo.
  final String? semanticLabel;

  /// Encuadra solo la cabeza.
  final bool headOnly;

  /// Dibuja el círculo de fondo.
  final bool haloed;

  @override
  State<SemiAvatar> createState() => _SemiAvatarState();
}

class _SemiAvatarState extends State<SemiAvatar> with TickerProviderStateMixin {
  static const _blinkDuration = Duration(milliseconds: 160);
  static const _waveDuration = Duration(milliseconds: 1100);
  static const _hopDuration = Duration(milliseconds: 420);

  late final AnimationController _blink = AnimationController(
    vsync: this,
    duration: _blinkDuration,
  );
  late final AnimationController _wave = AnimationController(
    vsync: this,
    duration: _waveDuration,
  );
  late final AnimationController _hop = AnimationController(
    vsync: this,
    duration: _hopDuration,
  );
  final _random = math.Random();
  Timer? _blinkTimer;
  bool _animated = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final animated = !MediaQuery.disableAnimationsOf(context);
    if (animated == _animated) return;
    _animated = animated;
    if (animated) {
      _scheduleBlink();
      if (widget.expression == SemiExpression.happy && !widget.headOnly) {
        unawaited(_wave.forward(from: 0));
      }
    } else {
      _blinkTimer?.cancel();
      _blink.value = 0;
      _wave.value = 0;
      _hop.value = 0;
    }
  }

  @override
  void didUpdateWidget(SemiAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_animated && oldWidget.expression != widget.expression) {
      unawaited(_hop.forward(from: 0));
      if (widget.expression == SemiExpression.happy && !widget.headOnly) {
        unawaited(_wave.forward(from: 0));
      }
    }
  }

  void _scheduleBlink() {
    _blinkTimer?.cancel();
    final wait = Duration(milliseconds: 2800 + _random.nextInt(2400));
    _blinkTimer = Timer(wait, () async {
      if (!mounted || !_animated) return;
      await _blink.forward(from: 0);
      if (!mounted) return;
      await _blink.reverse();
      if (mounted) _scheduleBlink();
    });
  }

  @override
  void dispose() {
    _blinkTimer?.cancel();
    _blink.dispose();
    _wave.dispose();
    _hop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.size;
    final width = widget.headOnly ? height : height * 300 / 340;

    Widget avatar = AnimatedBuilder(
      animation: Listenable.merge([_blink, _wave, _hop]),
      builder: (context, _) {
        // Dos vaivenes del brazo que se apagan; un salto con caída suave.
        final wave =
            math.sin(_wave.value * math.pi * 4) * (1 - _wave.value) * 0.35;
        final hop = math.sin(_hop.value * math.pi) * height * 0.06;
        return Transform.translate(
          offset: Offset(0, -hop),
          child: CustomPaint(
            size: Size(width, height),
            painter: SemiPainter(
              expression: widget.expression,
              blink: Curves.easeInOut.transform(_blink.value),
              wave: -wave,
              headOnly: widget.headOnly,
            ),
          ),
        );
      },
    );

    if (widget.haloed) {
      avatar = Container(
        width: width,
        height: height,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: context.colors.semiHalo,
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.all(height * 0.08),
        child: FittedBox(child: avatar),
      );
    }

    final label = widget.semanticLabel;
    return label == null
        ? ExcludeSemantics(child: avatar)
        : Semantics(
            image: true,
            label: label,
            child: ExcludeSemantics(child: avatar),
          );
  }
}
