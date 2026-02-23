import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'location_input_field.dart';
import 'location_search_sheet.dart';
import 'fare_display.dart';
import '../../core/services/fare_service.dart';
import '../../core/constant/app_colors.dart';

class LocationSelector extends StatefulWidget {
  final Function(double) onFareCalculated;

  const LocationSelector({super.key, required this.onFareCalculated});

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  String? _pickup;
  String? _drop;
  List<String> _allLocations = [];

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/data/mati_master_taripa.json',
      );
      final List<dynamic> data = json.decode(response);
      final Set<String> locations = {};

      for (var section in data) {
        if (section.containsKey('terminal')) {
          locations.add(
            section['terminal']
                .toString()
                .replaceAll('FARE RATE MATRIX (TARIPA)', '')
                .trim(),
          );
        }

        final List<dynamic> matrix = section['fare_matrix'] ?? [];
        for (var route in matrix) {
          if (route.containsKey('from')) {
            locations.add(route['from'].toString().trim());
          }
          if (route.containsKey('to')) {
            List<String> toParts = route['to'].toString().split(',');
            for (var part in toParts) {
              if (part.trim().isNotEmpty) {
                locations.add(part.trim());
              }
            }
          }
          if (route.containsKey('destination')) {
            locations.add(route['destination'].toString().trim());
          }
        }
      }

      setState(() {
        _allLocations = locations.where((s) => s.isNotEmpty).toList()..sort();
      });
    } catch (e) {
      debugPrint("Error loading locations: $e");
    }
  }

  void _resetTrip() => setState(() {
    _pickup = null;
    _drop = null;
  });

  @override
  Widget build(BuildContext context) {
    final double? fare = (_pickup != null && _drop != null)
        ? FareService.calculateTripFare(_pickup, _drop)
        : null;

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
                    onTap: () => _showPicker(true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: LocationInputField(
                    label: 'Drop-off Point',
                    value: _drop,
                    icon: Icons.location_on,
                    iconColor: const Color(0xFFF44336),
                    onTap: () => _showPicker(false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (fare != null)
              FareDisplay(
                fare: fare,
                onArrived: () {
                  widget.onFareCalculated(fare);
                  _resetTrip();
                },
              )
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

  void _showPicker(bool isPickup) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LocationSearchSheet(
        title: isPickup ? 'Select Pickup Point' : 'Select Destination',
        barangays: _allLocations,
        onSelected: (val) {
          setState(() {
            if (isPickup) {
              _pickup = val;
            } else {
              _drop = val;
            }
          });
        },
      ),
    );
  }
}
