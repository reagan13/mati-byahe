import 'package:flutter/material.dart';
// Update this path to point to your existing shared widgets
import '../login/widgets/login_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  String _userRole = 'Passenger';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background components reused from your login_widgets
          const _SharedBackground(),
          Positioned.fill(child: CustomPaint(painter: DotGridPainter())),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  _buildHeader(),
                  const SizedBox(height: 40),
                  _buildRoleSelector(),
                  const SizedBox(height: 32),

                  // Reusing your destructured components
                  LoginInput(
                    controller: _emailController,
                    label: 'Email Address',
                  ),
                  const SizedBox(height: 20),
                  LoginInput(
                    controller: _passwordController,
                    label: 'Password',
                    obscureText: !_isPasswordVisible,
                    suffix: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () => setState(
                        () => _isPasswordVisible = !_isPasswordVisible,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  LoginInput(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    obscureText: true,
                  ),

                  const SizedBox(height: 32),
                  const LoginDivider(),
                  const SizedBox(height: 24),
                  PrimaryButton(label: 'Register Account', onPressed: () {}),
                  const SizedBox(height: 24),
                  _buildFooter(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- UI Sub-sections to keep the build method clean ---

  Widget _buildHeader() {
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

  Widget _buildRoleSelector() {
    return Row(
      children: [
        Expanded(child: _roleToggle('Passenger')),
        const SizedBox(width: 16),
        Expanded(child: _roleToggle('Rider')),
      ],
    );
  }

  Widget _roleToggle(String role) {
    bool isSelected = _userRole == role;
    return GestureDetector(
      onTap: () => setState(() => _userRole = role),
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

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Have an account already? ",
              style: TextStyle(color: Colors.grey[600]),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Text(
                'Login',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        const Text(
          'Digital Solutions You Can Trust.',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}

// Simple internal widget for the gradient to avoid code repetition
class _SharedBackground extends StatelessWidget {
  const _SharedBackground();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFF1F7FF), Color(0xFFD7E9FF)],
        ),
      ),
    );
  }
}
