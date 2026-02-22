import 'package:flutter/material.dart';
import 'location_input_field.dart';
import 'location_search_sheet.dart';
import '../../core/constant/app_colors.dart';

class LocationSelector extends StatefulWidget {
  final String? initialPickup;
  final String? initialDrop;

  const LocationSelector({super.key, this.initialPickup, this.initialDrop});

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  String? _pickup;
  String? _drop;

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

  @override
  void initState() {
    super.initState();
    _pickup = widget.initialPickup;
    _drop = widget.initialDrop;
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Plan your trip',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.darkNavy,
            ),
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
        ],
      ),
    );
  }
}
