import 'package:flutter/material.dart';
import '../core/constant/app_colors.dart';
import '../core/database/sync_service.dart';
import '../signup/verification_screen.dart';
import 'widgets/home_header.dart';
import 'widgets/dashboard_cards.dart';
import 'widgets/verification_overlay.dart';
import 'widgets/location_selector.dart';
import 'widgets/action_grid_widget.dart';
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error")));
    } finally {
      if (mounted) setState(() => _isSendingCode = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: !_isVerified ? _buildRestrictedView() : _buildHomeContent(),
    );
  }

  Widget _buildRestrictedView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
          const SizedBox(height: 32),
          VerificationOverlay(
            isSendingCode: _isSendingCode,
            onVerify: _handleVerification,
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        // Original HomeHeader kept exactly as is
        HomeHeader(email: widget.email, role: widget.role),

        // Use Expanded to fill space without allowing parent scroll
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Dashboard Card
              const DashboardCards(
                tripCount: 4,
                driverName: "Lito Lapid",
                plateNumber: "CLB 4930",
              ),
              // Action Grid (Report, News, Track Expense)
              const ActionGridWidget(),
              const SizedBox(height: 10),
              // Location Section
              const Expanded(child: LocationSelector()),
            ],
          ),
        ),
      ],
    );
  }
}
