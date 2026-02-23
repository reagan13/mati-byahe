import 'package:flutter/material.dart';
import 'location_input_field.dart';
import 'location_search_sheet.dart';
import 'fare_display.dart';
import '../../core/constant/app_colors.dart';

class LocationSelector extends StatefulWidget {
  const LocationSelector({super.key});

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  String? _pickup;
  String? _drop;

  final Map<String, double> _fixedRouteFares = {
    'Badas_Dahican': 45.0,
    'Badas_Central': 35.0,
    'Central_Dahican': 30.0,
    'Matiao_Central': 25.0,
    'Sainz_Central': 28.0,
    'Dahican_Matiao': 48.0,
    'Badas_Matiao': 42.0,
    'Badas_Sainz': 38.0,
  };

  final List<String> _matiBarangays = [
    'Badas',
    'Babangsa',
    'Bunaan',
    'Cabuaya',
    'Central',
    'Culian',
    'Dahican',
    'Danaos',
    'Don Enrique Lopez',
    'Don Salvador Lopez',
    'Don Victoriano Chiongbian',
    'Langka',
    'Libudon',
    'Luban',
    'Lumbo',
    'Mamali',
    'Matiao',
    'Mayo',
    'Sainz',
    'Sanghay',
    'Tagabakid',
    'Taguibo',
    'Tamisan',
    'Tuatua',
  ];

  double? _calculateFare() {
    if (_pickup == null || _drop == null || _pickup == _drop) return null;
    List<String> route = [_pickup!, _drop!]..sort();
    String key = route.join('_');
    if (_fixedRouteFares.containsKey(key)) return _fixedRouteFares[key];
    int idx1 = _matiBarangays.indexOf(_pickup!);
    int idx2 = _matiBarangays.indexOf(_drop!);
    return 20.0 + ((idx1 - idx2).abs() * 6.5) + (idx1 % 5);
  }

  void _openLocationSearch(bool isPickup) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LocationSearchSheet(
        title: isPickup ? 'Select Pickup Point' : 'Select Destination',
        barangays: _matiBarangays,
        onSelected: (selection) {
          setState(() {
            if (isPickup)
              _pickup = selection;
            else
              _drop = selection;
          });
        },
      ),
    );
  }

  void _resetTrip() {
    setState(() {
      _pickup = null;
      _drop = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final fare = _calculateFare();
    final bool hasSelection = _pickup != null || _drop != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Plan your trip',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkNavy,
                  ),
                ),
                if (hasSelection)
                  TextButton(
                    onPressed: _resetTrip,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Clear',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: LocationInputField(
                    label: 'Pick-up Point',
                    value: _pickup,
                    icon: Icons.circle,
                    iconColor: AppColors.primaryBlue,
                    onTap: () => _openLocationSearch(true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: LocationInputField(
                    label: 'Drop-off Point',
                    value: _drop,
                    icon: Icons.location_on,
                    iconColor: const Color(0xFFF44336),
                    onTap: () => _openLocationSearch(false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (fare != null)
              FareDisplay(fare: fare, onArrived: _resetTrip)
            else
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      Icon(
                        Icons.route_outlined,
                        size: 48,
                        color: AppColors.darkNavy.withOpacity(0.1),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No route selected yet',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkNavy.withOpacity(0.3),
                        ),
                      ),
                      Text(
                        'Select both points to see the fare',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.darkNavy.withOpacity(0.2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
