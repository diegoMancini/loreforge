import 'dart:math';

import 'package:flutter/material.dart';

/// A procedural atmospheric background that renders genre- and mood-specific
/// visual effects using [CustomPaint] and animations. No external image assets
/// are required.
class AtmosphereBackground extends StatefulWidget {
  const AtmosphereBackground({
    super.key,
    required this.genre,
    required this.mood,
    required this.child,
  });

  /// The narrative genre driving the visual palette and particle style.
  ///
  /// Supported values: `'Fantasy'`, `'Horror'`, `'Mystery'`, `'Sci-Fi'`,
  /// `'Romance'`, `'Thriller'`, `'War'`, `'Historical'`.
  /// Case-insensitive matching is used internally.
  final String genre;

  /// The current scene mood, which modulates particle speed, gradient
  /// intensity, and vignette tightness.
  ///
  /// Supported values: `'calm'`, `'tense'`, `'action'`, `'mysterious'`,
  /// `'romantic'`.
  final String mood;

  /// The child widget rendered on top of the painted background.
  final Widget child;

  @override
  State<AtmosphereBackground> createState() => _AtmosphereBackgroundState();
}

class _AtmosphereBackgroundState extends State<AtmosphereBackground>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late List<_Particle> _particles;
  late _GenreTheme _theme;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _theme = _GenreTheme.fromGenre(widget.genre);
    _particles = _generateParticles();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void didUpdateWidget(AtmosphereBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.genre != widget.genre) {
      _theme = _GenreTheme.fromGenre(widget.genre);
      _particles = _generateParticles();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<_Particle> _generateParticles() {
    final count = 15 + _random.nextInt(16); // 15-30
    return List.generate(count, (_) => _Particle.random(_random));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(
              painter: _AtmospherePainter(
                theme: _theme,
                mood: widget.mood,
                particles: _particles,
                animationValue: _controller.value,
              ),
              size: Size.infinite,
            ),
            child!,
          ],
        );
      },
      child: widget.child,
    );
  }
}

// ---------------------------------------------------------------------------
// Mood modifiers
// ---------------------------------------------------------------------------

class _MoodModifiers {
  const _MoodModifiers({
    required this.speedMultiplier,
    required this.vignetteRadius,
    required this.gradientIntensity,
    required this.pulseAmplitude,
  });

  factory _MoodModifiers.fromMood(String mood) {
    switch (mood.toLowerCase()) {
      case 'calm':
        return const _MoodModifiers(
          speedMultiplier: 0.5,
          vignetteRadius: 1.2,
          gradientIntensity: 0.8,
          pulseAmplitude: 0.0,
        );
      case 'tense':
        return const _MoodModifiers(
          speedMultiplier: 1.4,
          vignetteRadius: 0.7,
          gradientIntensity: 1.2,
          pulseAmplitude: 0.0,
        );
      case 'action':
        return const _MoodModifiers(
          speedMultiplier: 2.0,
          vignetteRadius: 0.9,
          gradientIntensity: 1.0,
          pulseAmplitude: 0.08,
        );
      case 'mysterious':
        return const _MoodModifiers(
          speedMultiplier: 0.3,
          vignetteRadius: 0.55,
          gradientIntensity: 1.1,
          pulseAmplitude: 0.0,
        );
      case 'romantic':
        return const _MoodModifiers(
          speedMultiplier: 0.6,
          vignetteRadius: 1.0,
          gradientIntensity: 0.9,
          pulseAmplitude: 0.04,
        );
      default:
        return const _MoodModifiers(
          speedMultiplier: 1.0,
          vignetteRadius: 0.9,
          gradientIntensity: 1.0,
          pulseAmplitude: 0.0,
        );
    }
  }

  final double speedMultiplier;

  /// Controls the radial gradient radius for the vignette (smaller = tighter).
  final double vignetteRadius;

  /// Multiplier applied to gradient colour opacity.
  final double gradientIntensity;

  /// Amplitude of the subtle pulsing glow effect (0 = disabled).
  final double pulseAmplitude;
}

// ---------------------------------------------------------------------------
// Genre theme data
// ---------------------------------------------------------------------------

enum _AtmosphereType {
  radialGlow,
  vignette,
  spotlight,
  scanLines,
  warmGlow,
  highContrastVignette,
  smokeWisps,
  agedPaperNoise,
}

enum _ParticleStyle {
  sparkle,
  fogWisp,
  dustMote,
  starDot,
  petal,
  rain,
  ember,
  dust,
}

class _GenreTheme {
  const _GenreTheme({
    required this.gradientColors,
    required this.particleStyle,
    required this.particleColor,
    required this.atmosphereType,
  });

  factory _GenreTheme.fromGenre(String genre) {
    switch (genre.toLowerCase()) {
      case 'fantasy':
        return const _GenreTheme(
          gradientColors: [
            Color(0xFF2D1B69),
            Color(0xFF1A1147),
            Color(0xFF0A0A0A),
          ],
          particleStyle: _ParticleStyle.sparkle,
          particleColor: Color(0xFFFFD700),
          atmosphereType: _AtmosphereType.radialGlow,
        );
      case 'horror':
        return const _GenreTheme(
          gradientColors: [
            Color(0xFF4A0E0E),
            Color(0xFF1A0505),
            Color(0xFF050101),
          ],
          particleStyle: _ParticleStyle.fogWisp,
          particleColor: Color(0xFF9E9E9E),
          atmosphereType: _AtmosphereType.vignette,
        );
      case 'mystery':
        return const _GenreTheme(
          gradientColors: [
            Color(0xFF5C3D1E),
            Color(0xFF2E1A0A),
            Color(0xFF0A0704),
          ],
          particleStyle: _ParticleStyle.dustMote,
          particleColor: Color(0xFFD4C5A9),
          atmosphereType: _AtmosphereType.spotlight,
        );
      case 'sci-fi':
        return const _GenreTheme(
          gradientColors: [
            Color(0xFF00ACC1),
            Color(0xFF0D2137),
            Color(0xFF050A12),
          ],
          particleStyle: _ParticleStyle.starDot,
          particleColor: Color(0xFFFFFFFF),
          atmosphereType: _AtmosphereType.scanLines,
        );
      case 'romance':
        return const _GenreTheme(
          gradientColors: [
            Color(0xFFE91E63),
            Color(0xFF880E4F),
            Color(0xFF1A0A10),
          ],
          particleStyle: _ParticleStyle.petal,
          particleColor: Color(0xFFF48FB1),
          atmosphereType: _AtmosphereType.warmGlow,
        );
      case 'thriller':
        return const _GenreTheme(
          gradientColors: [
            Color(0xFFE65100),
            Color(0xFF424242),
            Color(0xFF0A0A0A),
          ],
          particleStyle: _ParticleStyle.rain,
          particleColor: Color(0xFFBDBDBD),
          atmosphereType: _AtmosphereType.highContrastVignette,
        );
      case 'war':
        return const _GenreTheme(
          gradientColors: [
            Color(0xFF5D5346),
            Color(0xFF3E4A2E),
            Color(0xFF0A0A08),
          ],
          particleStyle: _ParticleStyle.ember,
          particleColor: Color(0xFFFF6D00),
          atmosphereType: _AtmosphereType.smokeWisps,
        );
      case 'historical':
        return const _GenreTheme(
          gradientColors: [
            Color(0xFF8D7651),
            Color(0xFF3E2C16),
            Color(0xFF0F0B06),
          ],
          particleStyle: _ParticleStyle.dust,
          particleColor: Color(0xFFBCA98B),
          atmosphereType: _AtmosphereType.agedPaperNoise,
        );
      default:
        // Neutral dark fallback.
        return const _GenreTheme(
          gradientColors: [
            Color(0xFF303030),
            Color(0xFF1A1A1A),
            Color(0xFF0A0A0A),
          ],
          particleStyle: _ParticleStyle.dustMote,
          particleColor: Color(0xFF9E9E9E),
          atmosphereType: _AtmosphereType.vignette,
        );
    }
  }

  final List<Color> gradientColors;
  final _ParticleStyle particleStyle;
  final Color particleColor;
  final _AtmosphereType atmosphereType;
}

// ---------------------------------------------------------------------------
// Particle model
// ---------------------------------------------------------------------------

class _Particle {
  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.speed,
    required this.driftAngle,
    required this.phase,
  });

  factory _Particle.random(Random rng) {
    return _Particle(
      x: rng.nextDouble(),
      y: rng.nextDouble(),
      size: 1.5 + rng.nextDouble() * 3.5, // 1.5 – 5.0
      opacity: 0.15 + rng.nextDouble() * 0.55, // 0.15 – 0.70
      speed: 0.02 + rng.nextDouble() * 0.04, // normalized per cycle
      driftAngle: rng.nextDouble() * 2 * pi,
      phase: rng.nextDouble(), // offset so particles don't move in sync
    );
  }

  /// Normalized position (0-1) along the x-axis.
  double x;

  /// Normalized position (0-1) along the y-axis.
  double y;

  /// Radius in logical pixels.
  final double size;

  /// Base opacity (0-1).
  final double opacity;

  /// Movement distance per animation cycle, in normalized coordinates.
  final double speed;

  /// Angle of drift in radians.
  final double driftAngle;

  /// Phase offset so particles animate independently.
  final double phase;
}

// ---------------------------------------------------------------------------
// CustomPainter
// ---------------------------------------------------------------------------

class _AtmospherePainter extends CustomPainter {
  _AtmospherePainter({
    required this.theme,
    required this.mood,
    required this.particles,
    required this.animationValue,
  }) : _moodMod = _MoodModifiers.fromMood(mood);

  final _GenreTheme theme;
  final String mood;
  final List<_Particle> particles;
  final double animationValue;
  final _MoodModifiers _moodMod;

  @override
  void paint(Canvas canvas, Size size) {
    _drawBaseGradient(canvas, size);
    _drawParticles(canvas, size);
    _drawAtmosphere(canvas, size);
  }

  // ---- Base gradient ----

  void _drawBaseGradient(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: theme.gradientColors.map((c) {
        final hsl = HSLColor.fromColor(c);
        return hsl
            .withSaturation(
              (hsl.saturation * _moodMod.gradientIntensity).clamp(0.0, 1.0),
            )
            .toColor();
      }).toList(),
    );
    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
  }

  // ---- Particles ----

  void _drawParticles(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = (animationValue + p.phase) % 1.0;
      final dx = cos(p.driftAngle) * p.speed * t * _moodMod.speedMultiplier;
      final dy = sin(p.driftAngle) * p.speed * t * _moodMod.speedMultiplier;

      // Wrap around edges.
      var px = (p.x + dx) % 1.0;
      var py = (p.y + dy) % 1.0;
      if (px < 0) px += 1.0;
      if (py < 0) py += 1.0;

      final cx = px * size.width;
      final cy = py * size.height;

      // Subtle opacity oscillation for liveliness.
      final flickerOpacity =
          (p.opacity * (0.7 + 0.3 * sin(t * 2 * pi))).clamp(0.0, 1.0);

      switch (theme.particleStyle) {
        case _ParticleStyle.sparkle:
          _drawSparkle(canvas, cx, cy, p.size, flickerOpacity);
        case _ParticleStyle.fogWisp:
          _drawFogWisp(canvas, cx, cy, p.size, flickerOpacity);
        case _ParticleStyle.dustMote:
        case _ParticleStyle.dust:
          _drawDustMote(canvas, cx, cy, p.size, flickerOpacity);
        case _ParticleStyle.starDot:
          _drawStarDot(canvas, cx, cy, p.size, flickerOpacity);
        case _ParticleStyle.petal:
          _drawPetal(canvas, cx, cy, p.size, flickerOpacity, t);
        case _ParticleStyle.rain:
          _drawRain(canvas, cx, cy, p.size, flickerOpacity);
        case _ParticleStyle.ember:
          _drawEmber(canvas, cx, cy, p.size, flickerOpacity, t);
      }
    }
  }

  void _drawSparkle(
    Canvas canvas,
    double x,
    double y,
    double size,
    double opacity,
  ) {
    final paint = Paint()
      ..color = theme.particleColor.withValues(alpha: opacity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);
    canvas.drawCircle(Offset(x, y), size, paint);
    // Brighter core.
    canvas.drawCircle(
      Offset(x, y),
      size * 0.4,
      Paint()..color = Colors.white.withValues(alpha: opacity * 0.8),
    );
  }

  void _drawFogWisp(
    Canvas canvas,
    double x,
    double y,
    double size,
    double opacity,
  ) {
    final paint = Paint()
      ..color = theme.particleColor.withValues(alpha: opacity * 0.35)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, size * 3);
    canvas.drawCircle(Offset(x, y), size * 4, paint);
  }

  void _drawDustMote(
    Canvas canvas,
    double x,
    double y,
    double size,
    double opacity,
  ) {
    final paint = Paint()
      ..color = theme.particleColor.withValues(alpha: opacity * 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.0);
    canvas.drawCircle(Offset(x, y), size * 0.7, paint);
  }

  void _drawStarDot(
    Canvas canvas,
    double x,
    double y,
    double size,
    double opacity,
  ) {
    final paint = Paint()
      ..color = theme.particleColor.withValues(alpha: opacity);
    canvas.drawCircle(Offset(x, y), size * 0.5, paint);
  }

  void _drawPetal(
    Canvas canvas,
    double x,
    double y,
    double size,
    double opacity,
    double t,
  ) {
    final paint = Paint()
      ..color = theme.particleColor.withValues(alpha: opacity * 0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.0);
    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(t * 2 * pi);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: size * 2.5, height: size),
      paint,
    );
    canvas.restore();
  }

  void _drawRain(
    Canvas canvas,
    double x,
    double y,
    double size,
    double opacity,
  ) {
    final paint = Paint()
      ..color = theme.particleColor.withValues(alpha: opacity * 0.4)
      ..strokeWidth = size * 0.3
      ..strokeCap = StrokeCap.round;
    // Diagonal line downward-right.
    canvas.drawLine(
      Offset(x, y),
      Offset(x + size * 1.5, y + size * 4),
      paint,
    );
  }

  void _drawEmber(
    Canvas canvas,
    double x,
    double y,
    double size,
    double opacity,
    double t,
  ) {
    // Fading orange dot.
    final fadedOpacity = (opacity * (1.0 - t)).clamp(0.0, 1.0);
    final paint = Paint()
      ..color = theme.particleColor.withValues(alpha: fadedOpacity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);
    canvas.drawCircle(Offset(x, y), size * (0.5 + 0.5 * t), paint);
  }

  // ---- Atmosphere overlay ----

  void _drawAtmosphere(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = Offset(size.width / 2, size.height / 2);
    final maxDim = max(size.width, size.height);

    switch (theme.atmosphereType) {
      case _AtmosphereType.radialGlow:
        _drawRadialGlow(canvas, center, maxDim, rect);
      case _AtmosphereType.vignette:
        _drawVignette(canvas, center, maxDim, rect);
      case _AtmosphereType.spotlight:
        _drawSpotlight(canvas, size, rect);
      case _AtmosphereType.scanLines:
        _drawScanLines(canvas, size);
      case _AtmosphereType.warmGlow:
        _drawWarmGlow(canvas, center, maxDim, rect);
      case _AtmosphereType.highContrastVignette:
        _drawHighContrastVignette(canvas, center, maxDim, rect);
      case _AtmosphereType.smokeWisps:
        _drawSmokeWisps(canvas, size);
      case _AtmosphereType.agedPaperNoise:
        _drawAgedPaperNoise(canvas, size);
    }

    // Pulse overlay for 'action' mood.
    if (_moodMod.pulseAmplitude > 0) {
      final pulseOpacity =
          (_moodMod.pulseAmplitude * sin(animationValue * 2 * pi)).abs();
      canvas.drawRect(
        rect,
        Paint()..color = Colors.white.withValues(alpha: pulseOpacity),
      );
    }
  }

  void _drawRadialGlow(
    Canvas canvas,
    Offset center,
    double maxDim,
    Rect rect,
  ) {
    final gradient = RadialGradient(
      center: Alignment.center,
      radius: 0.6,
      colors: [
        theme.gradientColors.first.withValues(alpha: 0.15),
        Colors.transparent,
      ],
    );
    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
  }

  void _drawVignette(
    Canvas canvas,
    Offset center,
    double maxDim,
    Rect rect,
  ) {
    final gradient = RadialGradient(
      center: Alignment.center,
      radius: _moodMod.vignetteRadius,
      colors: const [Colors.transparent, Colors.black],
      stops: const [0.4, 1.0],
    );
    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
  }

  void _drawSpotlight(Canvas canvas, Size size, Rect rect) {
    // Cone of light from top-center.
    final gradient = RadialGradient(
      center: const Alignment(0.0, -1.0),
      radius: 1.2 * _moodMod.vignetteRadius,
      colors: [
        Colors.white.withValues(alpha: 0.06),
        Colors.transparent,
      ],
    );
    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
    // Dark edges.
    _drawVignette(
      canvas,
      Offset(size.width / 2, size.height / 2),
      max(size.width, size.height),
      rect,
    );
  }

  void _drawScanLines(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withValues(alpha: 0.05);
    const lineSpacing = 4.0;
    for (var y = 0.0; y < size.height; y += lineSpacing) {
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, 1), paint);
    }
  }

  void _drawWarmGlow(
    Canvas canvas,
    Offset center,
    double maxDim,
    Rect rect,
  ) {
    final gradient = RadialGradient(
      center: Alignment.center,
      radius: 0.8,
      colors: [
        theme.gradientColors.first.withValues(alpha: 0.12),
        Colors.transparent,
      ],
    );
    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
  }

  void _drawHighContrastVignette(
    Canvas canvas,
    Offset center,
    double maxDim,
    Rect rect,
  ) {
    final gradient = RadialGradient(
      center: Alignment.center,
      radius: _moodMod.vignetteRadius * 0.7,
      colors: const [Colors.transparent, Colors.black],
      stops: const [0.3, 1.0],
    );
    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
  }

  void _drawSmokeWisps(Canvas canvas, Size size) {
    // Semi-transparent gradient band at the bottom to simulate low smoke.
    final rect = Rect.fromLTWH(0, size.height * 0.7, size.width, size.height * 0.3);
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.transparent,
        Colors.grey.withValues(alpha: 0.08),
        Colors.grey.withValues(alpha: 0.15),
      ],
    );
    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
  }

  void _drawAgedPaperNoise(Canvas canvas, Size size) {
    // Simulate a faint noise-like overlay using a grid of translucent dots.
    final rng = Random(42); // Fixed seed for deterministic "noise".
    final paint = Paint();
    const step = 8.0;
    for (var x = 0.0; x < size.width; x += step) {
      for (var y = 0.0; y < size.height; y += step) {
        final v = rng.nextDouble();
        if (v > 0.7) {
          paint.color = const Color(0xFF8D7651).withValues(alpha: v * 0.04);
          canvas.drawRect(Rect.fromLTWH(x, y, step, step), paint);
        }
      }
    }
    // Light vignette on top.
    final rect = Offset.zero & size;
    final gradient = RadialGradient(
      center: Alignment.center,
      radius: _moodMod.vignetteRadius * 1.1,
      colors: const [Colors.transparent, Colors.black],
      stops: const [0.5, 1.0],
    );
    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
  }

  @override
  bool shouldRepaint(covariant _AtmospherePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue ||
      oldDelegate.mood != mood;
}
