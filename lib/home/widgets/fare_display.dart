import 'package:flutter/material.dart';
import '../../core/constant/app_colors.dart';
import '../../core/constant/app_texts.dart';

class FareDisplay extends StatelessWidget {
  final double fare;

  const FareDisplay({super.key, required this.fare});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.darkNavy,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            AppTexts.fareLabel,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          Text(
            '${AppTexts.currency}${fare.toStringAsFixed(2)}',
            style: const TextStyle(
              fontFamily: 'Unbound', // Using Unbound for the price
              color: AppColors.primaryYellow,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
