import 'package:flutter/material.dart';
import 'dart:math';
import 'package:go_router/go_router.dart';

class MathMazePage extends StatefulWidget {
  const MathMazePage({super.key});

  @override
  State<MathMazePage> createState() => _MathMazePageState();
}

class _MathMazePageState extends State<MathMazePage> {
  late int number1;
  late int number2;
  late int answer;
  late List<int> options;
  int score = 0;

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  void _generateQuestion() {
    final rand = Random();
    number1 = rand.nextInt(20) + 1;
    number2 = rand.nextInt(20) + 1;
    answer = number1 + number2;

    options = [answer];
    while (options.length < 4) {
      int fakeAnswer = answer + rand.nextInt(11) - 5;
      if (fakeAnswer != answer &&
          !options.contains(fakeAnswer) &&
          fakeAnswer >= 0) {
        options.add(fakeAnswer);
      }
    }
    options.shuffle();
  }

  void _checkAnswer(int selected) {
    if (selected == answer) {
      setState(() {
        score++;
      });
      _showSnackBar("✅ Benar!");
    } else {
      _showSnackBar("❌ Salah! Jawaban: $answer");
    }

    setState(() {
      _generateQuestion();
    });
  }

  void _resetGame() {
    setState(() {
      score = 0;
      _generateQuestion();
    });
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.teal,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('🧮 Math Maze'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Berapa hasil dari:',
              style: theme.textTheme.titleMedium?.copyWith(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 4),
                  ],
                ),
                child: Text(
                  '$number1 + $number2 = ?',
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: options.map((opt) {
                return ElevatedButton(
                  onPressed: () => _checkAnswer(opt),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    opt.toString(),
                    style: const TextStyle(fontSize: 20),
                  ),
                );
              }).toList(),
            ),
            const Spacer(),
            Text(
              'Skor kamu: $score',
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _resetGame,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset Game'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[400],
                foregroundColor: Colors.black87,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
