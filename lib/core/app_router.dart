import 'package:go_router/go_router.dart';
import 'package:logiland/features/cryptarythm/cryptarythm_page.dart';
import 'package:logiland/features/home/home_page.dart';

import 'package:logiland/features/teka_skor/teka_page.dart' as teka;
import 'package:logiland/features/math_maze/math_maze_page.dart' as math;

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/teka',
      builder: (context, state) => const teka.TekaPage(),
    ),
    GoRoute(
      path: '/math-maze',
      builder: (context, state) => const math.MathMazePage(),
    ),
    GoRoute(
      path: '/cryptarythm',
      builder: (context, state) => const CryptarythmPage(),
    ),
  ],
);
