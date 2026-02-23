import '../models/trip_model.dart';

class FareService {
  static double? calculateTripFare(String? pickup, String? drop) {
    if (pickup == null || drop == null || pickup == drop) return null;

    List<String> route = [pickup, drop]..sort();
    String key = route.join('_');

    if (TripConstants.fixedRouteFares.containsKey(key)) {
      return TripConstants.fixedRouteFares[key];
    }

    int idx1 = TripConstants.matiBarangays.indexOf(pickup);
    int idx2 = TripConstants.matiBarangays.indexOf(drop);

    if (idx1 == -1 || idx2 == -1) return null;

    return 20.0 + ((idx1 - idx2).abs() * 6.5) + (idx1 % 5);
  }
}
