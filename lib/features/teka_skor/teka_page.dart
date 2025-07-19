import 'package:flutter/material.dart';
import 'dart:math';
import 'package:go_router/go_router.dart';

class TekaPage extends StatefulWidget {
  const TekaPage({super.key});

  @override
  State<TekaPage> createState() => _TekaPageState();
}

class _TekaPageState extends State<TekaPage> {
  late String targetNumber;
  final TextEditingController _controller = TextEditingController();
  final List<String> history = [];

  @override
  void initState() {
    super.initState();
    targetNumber = _generateNumber();
    print('Target: $targetNumber'); // Debug
  }

  String _generateNumber() {
    final rand = Random();
    String number = '';
    for (int i = 0; i < 4; i++) {
      number += rand.nextInt(10).toString();
    }
    return number;
  }

  void _checkGuess() {
    final guess = _controller.text;

    if (guess.length != 4 || guess.contains(RegExp(r'[^0-9]'))) {
      _showSnackBar("Masukkan 4 digit angka!");
      return;
    }

    String feedback = _evaluateGuess(guess);
    setState(() {
      history.insert(0, '$guess → $feedback');
    });

    if (guess == targetNumber) {
      _showSnackBar("🎉 Benar! Angkanya adalah $targetNumber");
    }

    _controller.clear();
  }

  String _evaluateGuess(String guess) {
    int correct = 0;
    int misplaced = 0;

    List<bool> targetMatched = List.filled(4, false);
    List<bool> guessMatched = List.filled(4, false);

    for (int i = 0; i < 4; i++) {
      if (guess[i] == targetNumber[i]) {
        correct++;
        targetMatched[i] = true;
        guessMatched[i] = true;
      }
    }

    for (int i = 0; i < 4; i++) {
      if (guessMatched[i]) continue;

      for (int j = 0; j < 4; j++) {
        if (!targetMatched[j] && guess[i] == targetNumber[j]) {
          misplaced++;
          targetMatched[j] = true;
          break;
        }
      }
    }

    return '$correct tepat, $misplaced salah posisi';
  }

  void _restartGame() {
    setState(() {
      targetNumber = _generateNumber();
      history.clear();
    });
    _showSnackBar("Game dimulai ulang! 🎯");
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.teal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('🧠 TekaSkor'),
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
            const Text(
              'Tebak angka 4 digit!\nAngka bisa kembar',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: InputDecoration(
                labelText: 'Tebakan kamu',
                counterText: '',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.numbers),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _checkGuess,
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white, 
                    ),
                    label: const Text('Submit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _restartGame,
                  icon: const Icon(
                    Icons.refresh,
                    color: Colors.black,
                  ),
                  label: const Text('Ulangi'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Riwayat Tebakan',
                style: theme.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[800],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: history.isEmpty
                  ? const Center(
                      child: Text(
                        'Belum ada tebakan.',
                        style: TextStyle(color: Colors.black54),
                      ),
                    )
                  : ListView.separated(
                      itemCount: history.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final item = history[index];
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 3,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.teal,
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  item,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
