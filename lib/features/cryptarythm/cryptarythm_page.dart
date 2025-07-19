import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';

class CryptarythmPage extends StatefulWidget {
  const CryptarythmPage({super.key});

  @override
  State<CryptarythmPage> createState() => _CryptarythmPageState();
}

class _CryptarythmPageState extends State<CryptarythmPage> {
  final Map<String, TextEditingController> _controllers = {};
  String message = '';
  bool isCorrect = false;
  int currentLevel = 1;
  int score = 0;

  late String word1, word2, result;
  late List<String> uniqueLetters;

  final List<Map<String, dynamic>> questionTemplates = [
    {
      'level': 1,
      'template': 'AB + AB = CBB',
      'generator': (Random r) {
        final a = r.nextInt(4) + 1;
        final b = r.nextInt(10);
        final c = a * 2;
        return {
          'word1': 'AB',
          'word2': 'AB',
          'result': 'CBB',
          'solution': {'A': a, 'B': b, 'C': c},
        };
      },
    },
    {
      'level': 1,
      'template': 'A + B = CD',
      'generator': (Random r) {
        final a = r.nextInt(5) + 5;
        final b = r.nextInt(5) + 5;
        final sum = a + b;
        return {
          'word1': 'A',
          'word2': 'B',
          'result': 'CD',
          'solution': {'A': a, 'B': b, 'C': sum ~/ 10, 'D': sum % 10},
        };
      },
    },
    {
      'level': 2,
      'template': 'SEND + MORE = MONEY',
      'generator': (Random r) => {
            'word1': 'SEND',
            'word2': 'MORE',
            'result': 'MONEY',
            'solution': {
              'S': 9,
              'E': 5,
              'N': 6,
              'D': 7,
              'M': 1,
              'O': 0,
              'R': 8,
              'Y': 2
            },
          },
    },
    {
      'level': 2,
      'template': 'BASE + BALL = GAMES',
      'generator': (Random r) => {
            'word1': 'BASE',
            'word2': 'BALL',
            'result': 'GAMES',
            'solution': {
              'B': 2,
              'A': 4,
              'S': 6,
              'E': 1,
              'L': 5,
              'G': 0,
              'M': 9
            },
          },
    },
    {
      'level': 3,
      'template': 'WORD1 + WORD2 = RESULT',
      'generator': (Random r) {
        final word1 = _generateWord(r, 5);
        final word2 = _generateWord(r, 5);
        final sum = r.nextInt(90000) + 10000;
        return {
          'word1': word1,
          'word2': word2,
          'result': sum.toString(),
          'solution': null,
        };
      },
    },
  ];

  static String _generateWord(Random r, int maxLength) {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final length = r.nextInt(maxLength - 2) + 3;
    return List.generate(length, (_) => letters[r.nextInt(letters.length)])
        .join();
  }

  @override
  void initState() {
    super.initState();
    _generateNewQuestion();
  }

  void _generateNewQuestion({int? level}) {
    currentLevel = level ?? currentLevel;
    final levelTemplates =
        questionTemplates.where((q) => q['level'] == currentLevel).toList();
    final template = levelTemplates.isEmpty
        ? questionTemplates[Random().nextInt(questionTemplates.length)]
        : levelTemplates[Random().nextInt(levelTemplates.length)];
    _generateFromTemplate(template);
  }

  void _generateFromTemplate(Map<String, dynamic> template) {
    final generator = template['generator'] as Function;
    final question = generator(Random());

    word1 = question['word1']!;
    word2 = question['word2']!;
    result = question['result']!;

    final allLetters = (word1 + word2 + result).split('').toSet().toList();
    uniqueLetters = allLetters;

    _controllers.clear();
    for (var l in uniqueLetters) {
      _controllers[l] = TextEditingController();
    }

    setState(() {
      message = '';
      isCorrect = false;
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _checkAnswer() {
    try {
      final map = <String, int>{};
      for (var l in uniqueLetters) {
        final value = int.parse(_controllers[l]!.text);
        map[l] = value;
      }

      final values = map.values.toList();
      if (values.toSet().length != values.length) {
        setState(() {
          message = '⛔ Tidak boleh ada angka yang sama!';
          isCorrect = false;
        });
        return;
      }

      if (map[word1[0]] == 0 || map[word2[0]] == 0 || map[result[0]] == 0) {
        setState(() {
          message = '⛔ Huruf pertama tidak boleh 0!';
          isCorrect = false;
        });
        return;
      }

      int getValue(String word) {
        return int.parse(word.split('').map((c) => map[c]).join());
      }

      final num1 = getValue(word1);
      final num2 = getValue(word2);
      final res = getValue(result);

      if (num1 + num2 == res) {
        setState(() {
          message = '✅ Benar! $num1 + $num2 = $res';
          isCorrect = true;
          score += currentLevel * 10;
        });
      } else {
        setState(() {
          message = '❌ Salah! $num1 + $num2 ≠ $res';
          isCorrect = false;
        });
      }
    } catch (_) {
      setState(() {
        message = '⚠️ Masukkan semua angka dengan benar!';
        isCorrect = false;
      });
    }
  }

  Widget _buildLevelSelector() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      children: [1, 2, 3].map((level) {
        return ChoiceChip(
          label: Text('Level $level'),
          selected: currentLevel == level,
          onSelected: (selected) => _generateNewQuestion(level: level),
          selectedColor: Colors.teal,
          labelStyle: TextStyle(
            color: currentLevel == level ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildVerticalLayout() {
    final maxLength = max(word1.length, max(word2.length, result.length));

    List<String> pad(String word) =>
        List.generate(maxLength - word.length, (_) => '')
            .followedBy(word.split(''))
            .toList();

    final w1 = pad(word1);
    final w2 = pad(word2);
    final res = pad(result);

    Widget buildInputRow(List<String> letters) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          final boxWidth =
              (totalWidth - 40) / (letters.length + 1); // +1 for "+"
          final boxSize = boxWidth.clamp(30.0, 60.0);

          return Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: boxSize), // Spacer untuk "+" sejajar
                ...letters.map((l) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: SizedBox(
                      width: boxSize,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            l,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          l != ''
                              ? TextField(
                                  controller: _controllers[l],
                                  maxLength: 1,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    counterText: '',
                                    isDense: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(vertical: 2),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : const SizedBox(height: 45),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        },
      );
    }

    Widget buildPlusRow(List<String> letters) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          final boxWidth = (totalWidth - 40) / (letters.length + 1);
          final boxSize = boxWidth.clamp(30.0, 60.0);
          final lineWidth = boxSize * letters.length + (letters.length - 1) * 4;

          return Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: boxSize,
                  child: const Text(
                    '+',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: lineWidth,
                  child: const Divider(
                    thickness: 2,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildInputRow(w1), // Baris 1
          const SizedBox(height: 4),
          buildInputRow(w2), // Baris 2
          buildPlusRow(w2), // Baris 3: simbol + dan garis
          const SizedBox(height: 4),
          buildInputRow(res), // Baris 4 (jawaban)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('🔐 Cryptarythm'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.canPop() ? context.pop() : context.go('/'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildLevelSelector(),
              const SizedBox(height: 20),
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text('Level $currentLevel',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: Colors.teal)),
                      const SizedBox(height: 12),
                      _buildVerticalLayout(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _checkAnswer,
                icon: const Icon(Icons.check),
                label: const Text('Cek Jawaban'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              Text(message,
                  style: TextStyle(
                    fontSize: 16,
                    color: isCorrect ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  )),
              const SizedBox(height: 12),
              Text('Skor: $score',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      for (var c in _controllers.values) {
                        c.clear();
                      }
                      setState(() {
                        message = '';
                        isCorrect = false;
                      });
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Ulangi'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[400],
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _generateNewQuestion,
                    icon: const Icon(Icons.shuffle),
                    label: const Text('Soal Baru'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[400],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
