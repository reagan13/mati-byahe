import 'package:flutter/material.dart';
import '../../core/constant/app_colors.dart';

class FareDisplay extends StatelessWidget {
  final double fare;

  const FareDisplay({super.key, required this.fare});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        Text(
          'ESTIMATED FARE',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: AppColors.darkNavy.withOpacity(0.4),
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 15),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left Side: Time Estimate
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    Icons.timer_outlined,
                    size: 22,
                    color: AppColors.darkNavy.withOpacity(0.5),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '15-20 min',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkNavy.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 20),

            // Center: Price
            Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        '₱',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primaryBlue.withOpacity(0.4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${fare.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 86,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryBlue,
                        letterSpacing: -4,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 3,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryYellow,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 20),

            // Right Side: Insurance Status
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.verified_user_outlined,
                    size: 22,
                    color: Color(0xFF4CAF50),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Insured',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkNavy.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Text(
          'Standard rates applied based on local guidelines.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade500,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
