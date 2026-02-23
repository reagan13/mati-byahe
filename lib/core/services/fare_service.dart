import 'dart:convert';
import 'package:flutter/services.dart';

class FareService {
  static List<dynamic>? _taripaData;
  static double currentGasPrice = 75.0;

  static Future<void> init() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/data/mati_master_taripa.json',
      );
      _taripaData = json.decode(response);
    } catch (e) {
      _taripaData = null;
    }
  }

  static double? calculateTripFare(
    String? pickup,
    String? drop, {
    bool isDiscounted = false,
  }) {
    if (_taripaData == null ||
        pickup == null ||
        drop == null ||
        pickup == drop) {
      return null;
    }

    for (var terminalGroup in _taripaData!) {
      String terminalName = terminalGroup['terminal'] ?? "";
      List<dynamic> fareMatrix = terminalGroup['fare_matrix'] ?? [];

      bool pickupIsTerminal =
          terminalName.toLowerCase().contains(pickup.toLowerCase()) ||
          terminalName.toLowerCase().contains("city proper");
      bool dropIsTerminal =
          terminalName.toLowerCase().contains(drop.toLowerCase()) ||
          terminalName.toLowerCase().contains("city proper");

      if (pickupIsTerminal || dropIsTerminal) {
        String searchLocation = pickupIsTerminal ? drop : pickup;

        for (var route in fareMatrix) {
          String? destination = route['destination'] ?? route['to'];
          String? fromLocation = route['from'];

          bool matchFound = false;
          if (destination != null &&
              destination.toLowerCase().contains(
                searchLocation.toLowerCase(),
              )) {
            matchFound = true;
          } else if (fromLocation != null &&
              fromLocation.toLowerCase().contains(
                searchLocation.toLowerCase(),
              )) {
            matchFound = true;
          }

          if (matchFound) {
            return _getRateFromPriceMap(route['rates'], isDiscounted);
          }
        }
      }
    }
    return isDiscounted ? 15.0 * 0.8 : 15.0;
  }

  static double _getRateFromPriceMap(
    Map<String, dynamic> rates,
    bool isDiscounted,
  ) {
    double? baseFare;

    rates.forEach((tier, price) {
      final parts = tier.split('-');
      double min = double.parse(parts[0]);
      double max = double.parse(parts[1]);

      if (currentGasPrice >= min && currentGasPrice <= max) {
        baseFare = (price is int) ? price.toDouble() : price;
      }
    });

    baseFare ??= (rates.values.first is int)
        ? rates.values.first.toDouble()
        : rates.values.first;

    return isDiscounted ? baseFare! * 0.8 : baseFare!;
  }
}
