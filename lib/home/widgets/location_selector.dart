import 'package:flutter/material.dart';
import 'location_input_field.dart';
import 'location_search_sheet.dart';
import 'fare_display.dart';
import '../../core/models/trip_model.dart';
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

  void _resetTrip() => setState(() {
    _pickup = null;
    _drop = null;
  });

  @override
  Widget build(BuildContext context) {
    final fare = FareService.calculateTripFare(_pickup, _drop);
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
        barangays: TripConstants.matiBarangays,
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
