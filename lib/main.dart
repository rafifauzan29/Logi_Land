import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/app_router.dart';
import 'core/theme.dart';

void main() {
  runApp(const ProviderScope(child: LogiLandApp()));
}

class LogiLandApp extends StatelessWidget {
  const LogiLandApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false, 
      title: 'LogiLand',
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}
