import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../core/constant/app_colors.dart';
import 'data/signup_repository.dart';
import 'widgets/signup_background.dart';
import '../login/widgets/login_widgets.dart';

class VerificationScreen extends StatefulWidget {
  final String email;
  const VerificationScreen({super.key, required this.email});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _codeController = TextEditingController();
  final _repository = SignupRepository();
  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _showNotification(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _showSuccessDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 80),
              const SizedBox(height: 20),
              const Text(
                "Account Created!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkNavy,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Your account has been verified successfully. You can now log in.",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textGrey),
              ),
              const SizedBox(height: 30),
              PrimaryButton(
                label: "Go to Login",
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _verifyOTP() async {
    if (_codeController.text.length < 8) return;
    setState(() => _isLoading = true);
    try {
      await Supabase.instance.client.auth.verifyOTP(
        token: _codeController.text.trim(),
        type: OtpType.signup,
        email: widget.email,
      );
      await _repository.markAsVerified(widget.email);
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showSuccessDialog();
    } catch (e) {
      if (!mounted) return;
      _showNotification("Invalid code. Please try again.", isError: true);
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const SignupBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  const Icon(
                    Icons.security,
                    size: 80,
                    color: AppColors.darkNavy,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Verify Account",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkNavy,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Enter the 8-digit code sent to\n${widget.email}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textGrey),
                  ),
                  const SizedBox(height: 40),
                  PinCodeTextField(
                    appContext: context,
                    length: 8,
                    controller: _codeController,
                    keyboardType: TextInputType.text,
                    onCompleted: (v) => _verifyOTP(),
                    onChanged: (v) {},
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(8),
                      fieldHeight: 50,
                      fieldWidth: 35,
                      activeColor: AppColors.primaryBlue,
                      inactiveColor: AppColors.primaryYellow.withOpacity(0.3),
                      selectedColor: AppColors.primaryBlue,
                      activeFillColor: Colors.white,
                    ),
                    animationType: AnimationType.fade,
                    cursorColor: AppColors.primaryBlue,
                  ),
                  const SizedBox(height: 40),
                  if (_isLoading)
                    const CircularProgressIndicator(
                      color: AppColors.primaryBlue,
                    )
                  else
                    PrimaryButton(label: "Verify Code", onPressed: _verifyOTP),
                  const SizedBox(height: 30),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Back to Registration",
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
