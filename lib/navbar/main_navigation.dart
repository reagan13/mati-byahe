import 'package:flutter/material.dart';
import '../core/constant/app_colors.dart';
import '../home/home_screen.dart';

class MainNavigation extends StatefulWidget {
  final String email;
  final String role;

  const MainNavigation({super.key, required this.email, required this.role});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    bool isDriver = widget.role.toLowerCase() == 'driver';
    return isDriver ? _buildDriverUI() : _buildPassengerUI();
  }

  Widget _buildPassengerUI() {
    final List<Widget> screens = [
      HomeScreen(email: widget.email, role: widget.role),
      const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Text("History")),
      ),
      const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Text("Scanner")),
      ),
      const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Text("Report")),
      ),
      const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Text("Profile")),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: screens[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onItemTapped(2),
        backgroundColor: const Color(0xFF2FA38D),
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: 70,
        notchMargin: 10.0,
        shape: const CircularNotchedRectangle(),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_filled, "HOME", 0),
            _buildNavItem(Icons.history, "HISTORY", 1),
            const SizedBox(width: 48),
            _buildNavItem(Icons.outlined_flag, "REPORT", 3),
            _buildNavItem(Icons.person_outline, "PROFILE", 4),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverUI() {
    final List<Widget> screens = [
      HomeScreen(email: widget.email, role: widget.role),
      const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Text("Earnings")),
      ),
      const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Text("Vehicle")),
      ),
      const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Text("Profile")),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: Colors.grey.shade400,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 10,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: "HOME",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_rounded),
            label: "EARNINGS",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.minor_crash_rounded),
            label: "VEHICLE",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: "PROFILE",
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.black : Colors.blueGrey.shade200,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: isSelected ? Colors.black : Colors.blueGrey.shade200,
            ),
          ),
        ],
      ),
    );
  }
}
