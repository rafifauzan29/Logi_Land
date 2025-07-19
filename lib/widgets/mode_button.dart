import 'package:flutter/material.dart';

class ModeButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const ModeButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(55),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        elevation: 4,
      ),
      child: Text(label, style: const TextStyle(fontSize: 18)),
    );
  }
}
