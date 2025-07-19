import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/mode_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🧠 LogiLand'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Pilih Mode Permainan:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              ModeButton(
                label: 'TekaSkor',
                onTap: () => context.go('/teka'),
              ),
              const SizedBox(height: 16),
              ModeButton(
                label: 'MathMaze',
                onTap: () => context.go('/math-maze'),
              ),
              const SizedBox(height: 16),
              ModeButton(
                label: 'Cryptarythm',
                onTap: () => context.go('/cryptarythm'),
              ),
              // Tambahkan mode lainnya di sini jika perlu
            ],
          ),
        ),
      ),
    );
  }
}
