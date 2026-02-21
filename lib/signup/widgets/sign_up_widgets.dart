import 'package:flutter/material.dart';

class SignupHeader extends StatelessWidget {
  const SignupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'Hop In · Register Your\nByahe Account',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Access your rides. Track trips. Manage your travels with ease.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF607D8B),
            fontSize: 14,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

class RoleSelector extends StatelessWidget {
  final String selectedRole;
  final Function(String) onRoleSelected;

  const RoleSelector({
    super.key,
    required this.selectedRole,
    required this.onRoleSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _roleToggle('Passenger')),
        const SizedBox(width: 16),
        Expanded(child: _roleToggle('Rider')),
      ],
    );
  }

  Widget _roleToggle(String role) {
    bool isSelected = selectedRole == role;
    return GestureDetector(
      onTap: () => onRoleSelected(role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey[300] : Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.grey[400]! : Colors.transparent,
          ),
        ),
        child: Center(
          child: Text(
            role,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
