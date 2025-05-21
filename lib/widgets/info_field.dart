import 'package:flutter/material.dart';

class InfoField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const InfoField({
    Key? key,
    required this.label,
    required this.value,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 320,
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            decoration: ShapeDecoration(
              color: const Color(0xFFF4F4F4),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  color: const Color(0xFFDEDEDE),
                ),
                borderRadius: BorderRadius.circular(22),
              ),
            ),
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
