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

  void _showWarning(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFFFDEDED),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(24),
        elevation: 0,
        content: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFD32F2F),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Color(0xFFD32F2F),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
      if (mounted) _showWarning("Action failed. Check connection.");
    } finally {
      if (mounted) setState(() => _isSendingCode = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeHeader(email: widget.email, role: widget.role),
            if (!_isVerified)
              VerificationOverlay(
                isSendingCode: _isSendingCode,
                onVerify: _handleVerification,
              ),
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
            const LocationSelector(
              initialPickup: "Madang",
              initialDrop: "Dahican",
            ),
          ],
        ),
      ),
    );
  }
}
