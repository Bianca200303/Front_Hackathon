import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:siembra_segura/core/theme/semi_colors.dart';

/// Estado de ánimo de Semi. Cada uno tiene su cara, sus brazos y sus
/// extras, tal como en la ficha de expresiones del personaje.
enum SemiExpression {
  /// Saludos, bienvenida y consejos del día.
  happy,

  /// Mientras analiza el cultivo o carga datos.
  thinking,

  /// Helada, plaga o riego urgente.
  alert,

  /// Llegó la lluvia o terminó la cosecha.
  celebrating,
}

/// Dibuja a Semi con las mismas formas de su SVG original (lienzo de
/// 300 × 340), escalado al tamaño disponible.
///
/// Se dibuja a mano en lugar de cargar un SVG para poder animar piezas
/// sueltas (ojos, brazo, brote) sin dependencias extra.
class SemiPainter extends CustomPainter {
  /// Crea el pintor.
  const SemiPainter({
    required this.expression,
    this.blink = 0,
    this.wave = 0,
    this.headOnly = false,
  });

  /// Expresión a dibujar.
  final SemiExpression expression;

  /// Cierre de los ojos: 0 abiertos, 1 cerrados.
  final double blink;

  /// Giro extra del brazo derecho, en radianes (saludo).
  final double wave;

  /// Si es `true`, encuadra solo la cabeza (para avatares pequeños).
  final bool headOnly;

  static const _fullView = Rect.fromLTWH(0, 0, 300, 340);
  static const _headView = Rect.fromLTWH(60, 14, 180, 190);

  @override
  void paint(Canvas canvas, Size size) {
    final view = headOnly ? _headView : _fullView;
    final scale = math.min(size.width / view.width, size.height / view.height);
    canvas
      ..save()
      ..translate(
        (size.width - view.width * scale) / 2,
        (size.height - view.height * scale) / 2,
      )
      ..scale(scale)
      ..translate(-view.left, -view.top);
    // Solo la cabeza: el resto del cuerpo no debe salirse del encuadre.
    if (headOnly) canvas.clipRect(view);

    final pose = _Pose.of(expression);

    if (!headOnly) {
      _fill(
        canvas,
        Path()..addOval(_ellipse(150, 326, 82, 9)),
        SemiColors.ink.withValues(alpha: 0.12),
      );
      _fill(
        canvas,
        Path()..addOval(_ellipse(118, 306, 26, 15)),
        SemiColors.feet,
      );
      _fill(
        canvas,
        Path()..addOval(_ellipse(182, 306, 26, 15)),
        SemiColors.feet,
      );
      _arm(canvas, pose.leftArm);
      if (!pose.rightArmInFront) _arm(canvas, pose.rightArm, wave: wave);
    }

    _drawBody(canvas);
    _drawFace(canvas);
    if (pose.cheeks) {
      final cheek = SemiColors.cheek.withValues(alpha: 0.75);
      canvas
        ..drawCircle(const Offset(100, 162), 7, Paint()..color = cheek)
        ..drawCircle(const Offset(200, 162), 7, Paint()..color = cheek);
    }
    _drawSprout(canvas, pose.sproutTilt);

    if (!headOnly) {
      if (pose.rightArmInFront) _arm(canvas, pose.rightArm, wave: wave);
      _drawExtras(canvas);
    }
    canvas.restore();
  }

  void _drawBody(Canvas canvas) {
    final body = Path()
      ..moveTo(150, 70)
      ..cubicTo(236, 70, 262, 150, 262, 210)
      ..cubicTo(262, 280, 216, 310, 150, 310)
      ..cubicTo(84, 310, 38, 280, 38, 210)
      ..cubicTo(38, 150, 64, 70, 150, 70)
      ..close();
    _fill(canvas, body, SemiColors.body);
    _stroke(
      canvas,
      Path()
        ..moveTo(68, 168)
        ..cubicTo(72, 126, 98, 94, 136, 84),
      SemiColors.shine.withValues(alpha: 0.35),
      9,
    );
    _stroke(
      canvas,
      Path()
        ..moveTo(232, 236)
        ..cubicTo(226, 262, 210, 280, 188, 292),
      SemiColors.bodyShade.withValues(alpha: 0.35),
      5,
    );
    _fill(
      canvas,
      Path()..addOval(_ellipse(150, 262, 62, 38)),
      SemiColors.belly,
    );
    _fill(
      canvas,
      _drop(150, 244, width: 10, height: 34),
      SemiColors.shine.withValues(alpha: 0.9),
    );
    _fill(
      canvas,
      Path()
        ..moveTo(50, 196)
        ..quadraticBezierTo(150, 232, 250, 196)
        ..lineTo(252, 216)
        ..quadraticBezierTo(150, 254, 48, 216)
        ..close(),
      SemiColors.scarf,
    );
    _fill(
      canvas,
      Path()
        ..moveTo(210, 222)
        ..lineTo(236, 252)
        ..lineTo(246, 226)
        ..close(),
      SemiColors.scarfTail,
    );
    _fill(
      canvas,
      Path()..addRRect(
        RRect.fromLTRBR(78, 104, 222, 186, const Radius.circular(38)),
      ),
      SemiColors.visor,
    );
    _fill(
      canvas,
      Path()..addRRect(
        RRect.fromLTRBR(96, 112, 136, 122, const Radius.circular(5)),
      ),
      SemiColors.shine.withValues(alpha: 0.14),
    );
  }

  void _drawFace(Canvas canvas) {
    // Al parpadear los ojos se aplastan en vertical, sin desaparecer.
    final eyeScale = 1 - 0.9 * blink.clamp(0, 1);
    switch (expression) {
      case SemiExpression.happy:
        _eye(canvas, 122, 140, 11, 15, eyeScale, SemiColors.light);
        _eye(canvas, 178, 140, 11, 15, eyeScale, SemiColors.light);
        _stroke(
          canvas,
          Path()
            ..moveTo(132, 162)
            ..quadraticBezierTo(150, 177, 168, 162),
          SemiColors.light,
          5,
        );
      case SemiExpression.thinking:
        _eye(canvas, 128, 134, 10, 12, eyeScale, SemiColors.light);
        _eye(canvas, 184, 134, 10, 12, eyeScale, SemiColors.light);
        _stroke(
          canvas,
          Path()
            ..moveTo(138, 166)
            ..lineTo(162, 163),
          SemiColors.light,
          5,
        );
      case SemiExpression.alert:
        for (final x in const [120.0, 180.0]) {
          _eye(canvas, x, 140, 15, 15, eyeScale, SemiColors.alertLight);
          _eye(canvas, x, 140, 5, 5, eyeScale, SemiColors.visor);
        }
        _fill(
          canvas,
          Path()..addOval(_ellipse(150, 168, 7, 6)),
          SemiColors.alertLight,
        );
      case SemiExpression.celebrating:
        // Ojos cerrados de alegría: no parpadean.
        for (final x in const [110.0, 166.0]) {
          _stroke(
            canvas,
            Path()
              ..moveTo(x, 145)
              ..quadraticBezierTo(x + 12, 128, x + 24, 145),
            SemiColors.light,
            6,
          );
        }
        _fill(
          canvas,
          Path()
            ..moveTo(130, 158)
            ..quadraticBezierTo(150, 182, 170, 158)
            ..close(),
          SemiColors.light,
        );
    }
  }

  void _drawSprout(Canvas canvas, double tiltDegrees) {
    canvas
      ..save()
      ..translate(150, 74)
      ..rotate(tiltDegrees * math.pi / 180)
      ..translate(-150, -74);
    _stroke(
      canvas,
      Path()
        ..moveTo(150, 74)
        ..quadraticBezierTo(147, 52, 152, 30),
      SemiColors.sproutStem,
      6,
    );
    _fill(
      canvas,
      Path()
        ..moveTo(150, 44)
        ..cubicTo(126, 20, 100, 28, 96, 44)
        ..cubicTo(116, 60, 140, 58, 150, 44)
        ..close(),
      SemiColors.sproutLeafLight,
    );
    _stroke(
      canvas,
      Path()
        ..moveTo(150, 44)
        ..quadraticBezierTo(124, 42, 104, 44),
      SemiColors.sproutStem.withValues(alpha: 0.5),
      2,
    );
    _fill(
      canvas,
      Path()
        ..moveTo(152, 34)
        ..cubicTo(174, 6, 206, 12, 210, 28)
        ..cubicTo(192, 46, 166, 46, 152, 34)
        ..close(),
      SemiColors.sproutLeafDark,
    );
    _stroke(
      canvas,
      Path()
        ..moveTo(152, 34)
        ..quadraticBezierTo(180, 30, 202, 28),
      SemiColors.sproutStem.withValues(alpha: 0.6),
      2,
    );
    canvas.restore();
  }

  void _drawExtras(Canvas canvas) {
    switch (expression) {
      case SemiExpression.happy:
        break;
      case SemiExpression.thinking:
        final bubble = Paint()..color = SemiColors.belly;
        canvas
          ..drawCircle(const Offset(250, 96), 6, bubble)
          ..drawCircle(const Offset(266, 72), 9, bubble)
          ..drawCircle(const Offset(286, 44), 13, bubble);
      case SemiExpression.alert:
        _fill(
          canvas,
          Path()..addRRect(
            RRect.fromLTRBR(252, 40, 292, 80, const Radius.circular(12)),
          ),
          SemiColors.alertBadge,
        );
        _fill(
          canvas,
          Path()..addRRect(
            RRect.fromLTRBR(269, 48, 275, 64, const Radius.circular(3)),
          ),
          SemiColors.shine,
        );
        canvas.drawCircle(
          const Offset(272, 71),
          3.5,
          Paint()..color = SemiColors.shine,
        );
      case SemiExpression.celebrating:
        const drops = [
          Offset(18, 60),
          Offset(44, 24),
          Offset(258, 30),
          Offset(286, 78),
          Offset(24, 120),
        ];
        for (final drop in drops) {
          _fill(
            canvas,
            _drop(drop.dx, drop.dy, width: 7, height: 18),
            SemiColors.raindrop,
          );
        }
    }
  }

  void _arm(Canvas canvas, _Arm arm, {double wave = 0}) {
    canvas.save();
    if (wave != 0) {
      canvas
        ..translate(arm.shoulder.dx, arm.shoulder.dy)
        ..rotate(wave)
        ..translate(-arm.shoulder.dx, -arm.shoulder.dy);
    }
    _stroke(
      canvas,
      Path()
        ..moveTo(arm.shoulder.dx, arm.shoulder.dy)
        ..quadraticBezierTo(
          arm.elbow.dx,
          arm.elbow.dy,
          arm.hand.dx,
          arm.hand.dy,
        ),
      SemiColors.arm,
      18,
    );
    canvas
      ..drawCircle(arm.hand, 14, Paint()..color = SemiColors.body)
      ..restore();
  }

  void _eye(
    Canvas canvas,
    double cx,
    double cy,
    double rx,
    double ry,
    double scaleY,
    Color color,
  ) {
    _fill(canvas, Path()..addOval(_ellipse(cx, cy, rx, ry * scaleY)), color);
  }

  /// Gota con la punta arriba en ([x], [y]).
  static Path _drop(
    double x,
    double y, {
    required double width,
    required double height,
  }) {
    final w = width;
    final h = height;
    return Path()
      ..moveTo(x, y)
      ..cubicTo(x - w, y + h * 0.55, x - w, y + h * 0.88, x, y + h)
      ..cubicTo(x + w, y + h * 0.88, x + w, y + h * 0.55, x, y)
      ..close();
  }

  static Rect _ellipse(double cx, double cy, double rx, double ry) =>
      Rect.fromCenter(center: Offset(cx, cy), width: rx * 2, height: ry * 2);

  static void _fill(Canvas canvas, Path path, Color color) =>
      canvas.drawPath(path, Paint()..color = color);

  static void _stroke(Canvas canvas, Path path, Color color, double width) =>
      canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = width
          ..strokeCap = StrokeCap.round,
      );

  @override
  bool shouldRepaint(SemiPainter oldDelegate) =>
      oldDelegate.expression != expression ||
      oldDelegate.blink != blink ||
      oldDelegate.wave != wave ||
      oldDelegate.headOnly != headOnly;
}

/// Brazo como curva cuadrática: hombro → codo (control) → mano.
class _Arm {
  const _Arm(this.shoulder, this.elbow, this.hand);

  final Offset shoulder;
  final Offset elbow;
  final Offset hand;
}

/// Postura de cada expresión, copiada de la ficha del personaje.
class _Pose {
  const _Pose({
    required this.leftArm,
    required this.rightArm,
    this.rightArmInFront = false,
    this.cheeks = false,
    this.sproutTilt = 0,
  });

  factory _Pose.of(SemiExpression expression) => switch (expression) {
    SemiExpression.happy => const _Pose(
      leftArm: _Arm(Offset(48, 218), Offset(29, 242), Offset(22, 250)),
      rightArm: _Arm(Offset(252, 205), Offset(261, 185.5), Offset(282, 150)),
      cheeks: true,
    ),
    SemiExpression.thinking => const _Pose(
      leftArm: _Arm(Offset(48, 218), Offset(29, 243), Offset(22, 252)),
      rightArm: _Arm(Offset(250, 215), Offset(225, 231.5), Offset(212, 232)),
      rightArmInFront: true,
      sproutTilt: -8,
    ),
    SemiExpression.alert => const _Pose(
      leftArm: _Arm(Offset(48, 214), Offset(26, 215), Offset(16, 200)),
      rightArm: _Arm(Offset(252, 214), Offset(262, 215), Offset(284, 200)),
    ),
    SemiExpression.celebrating => const _Pose(
      leftArm: _Arm(Offset(50, 200), Offset(30, 178), Offset(22, 140)),
      rightArm: _Arm(Offset(250, 200), Offset(258, 178), Offset(278, 140)),
      cheeks: true,
      sproutTilt: 6,
    ),
  };

  final _Arm leftArm;
  final _Arm rightArm;
  final bool rightArmInFront;
  final bool cheeks;
  final double sproutTilt;
}
