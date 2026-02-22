import 'package:flutter/material.dart';
import '../core/constant/app_colors.dart';
import '../core/database/sync_service.dart';
import '../signup/verification_screen.dart';
import 'widgets/home_header.dart';
import 'widgets/dashboard_cards.dart';
import 'widgets/verification_overlay.dart';
import 'widgets/location_selector.dart';
import 'home_controller.dart';

class HomeScreen extends StatefulWidget {
  final String email;
  final String role;
  const HomeScreen({super.key, required this.email, required this.role});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController _controller = HomeController();
  bool _isVerified = false;
  bool _isLoading = true;
  bool _isSendingCode = false;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final verified = await _controller.checkVerification(widget.email);
    if (mounted) {
      setState(() {
        _isVerified = verified;
        _isLoading = false;
      });
    }
    SyncService().syncOnStart();
  }

  Future<void> _handleVerification() async {
    setState(() => _isSendingCode = true);
    try {
      await _controller.resendVerificationCode(widget.email);
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VerificationScreen(email: widget.email),
        ),
      ).then((_) => _loadStatus());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Action failed. Check connection.")),
      );
    } finally {
      if (mounted) setState(() => _isSendingCode = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_isVerified) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock_person_rounded,
                size: 80,
                color: AppColors.primaryYellow,
              ),
              const SizedBox(height: 24),
              const Text(
                "Access Restricted",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.darkNavy,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Your account is not yet verified. Please verify your email to access the dashboard features.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              VerificationOverlay(
                isSendingCode: _isSendingCode,
                onVerify: _handleVerification,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeHeader(email: widget.email, role: widget.role),
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 20, 24, 12),
              child: Text(
                'Active Status',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkNavy,
                ),
              ),
            ),
            const DashboardCards(
              tripCount: 4,
              driverName: "Lito Lapid",
              plateNumber: "CLB 4930",
            ),
            const LocationSelector(initialPickup: null, initialDrop: null),
          ],
        ),
      ),
    );
  }
}
