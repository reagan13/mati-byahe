import 'package:flutter/material.dart';
import 'widgets/login_widgets.dart';
import '../signup/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const _LoginBackground(),
          Positioned.fill(child: CustomPaint(painter: DotGridPainter())),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Hop In · Log In to Your\nByahe Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Access your rides. Track trips. Manage your travels with ease.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF607D8B),
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 48),

                  LoginInput(
                    controller: _emailController,
                    label: 'Email Address',
                  ),
                  const SizedBox(height: 24),
                  LoginInput(
                    controller: _passwordController,
                    label: 'Password',
                    obscureText: !_isPasswordVisible,
                    suffix: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey[400],
                      ),
                      onPressed: () => setState(
                        () => _isPasswordVisible = !_isPasswordVisible,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  PrimaryButton(label: 'Login', onPressed: () {}),
                  const SizedBox(height: 20),
                  const LoginDivider(),
                  const SizedBox(height: 20),
                  PrimaryButton(label: 'Continue as Guest', onPressed: () {}),

                  const SizedBox(height: 32),
                  _buildRegisterPrompt(),

                  // Footer Tagline added here
                  const SizedBox(height: 40),
                  const Text(
                    'Digital Solutions You Can Trust.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have An Account? ",
          style: TextStyle(color: Colors.grey[600]),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterScreen()),
            );
          },
          child: const Text(
            'Register',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class _LoginBackground extends StatelessWidget {
  const _LoginBackground();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.5, 1.0],
          colors: [Color(0xFFFFFFFF), Color(0xFFF1F7FF), Color(0xFFD7E9FF)],
        ),
      ),
    );
  }
}
