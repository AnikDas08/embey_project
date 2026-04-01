import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  static inti() async {
    bool isEnabled = await checkLocationEnabled();
    if (isEnabled) {
      locationPermission();
    }
  }

  static Future<bool> checkLocationEnabled() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (kDebugMode) {
      print(serviceEnabled);
    }
    return serviceEnabled;
  }
  static Future<bool> locationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (kDebugMode) {
      print(permission);
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (kDebugMode) {
        print(permission);
      }
      if (permission == LocationPermission.denied) {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  static Future<Position?> getCurrentPosition() async {
    Position? positions;
    try {
      bool isEnabled = await checkLocationEnabled();
      if (!isEnabled) {
        isEnabled = await Geolocator.openLocationSettings();
      }
      if (isEnabled) {
        bool isPermission = await locationPermission();
        if (isPermission) {
          positions = await Geolocator.getCurrentPosition();
          print(positions);

          return positions;
        }
      }
      return positions;
    } catch (e) {
      return positions;
    }
  }

  static Future<List> addressToCoordinate(String address) async {
    try {
      bool isEnabled = await checkLocationEnabled();
      if (!isEnabled) {
        isEnabled = await Geolocator.openLocationSettings();
      }
      if (isEnabled) {
        bool isPermission = await locationPermission();
        if (isPermission) {
          List<Location> locations = await locationFromAddress(address);
          if (kDebugMode) {
            print(locations.first.longitude);
          }
          return locations;
        }
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<List> coordinateToAddress({
    required double lat,
    required double long,
  }) async {
    try {
      bool isEnabled = await checkLocationEnabled();
      if (!isEnabled) {
        isEnabled = await Geolocator.openLocationSettings();
      }
      if (isEnabled) {
        bool isPermission = await locationPermission();
        if (isPermission) {
          List<Placemark> placeMarks = await placemarkFromCoordinates(
            lat,
            long,
          );
          print(placeMarks.first.street);
          print(placeMarks.first.country);
          print(placeMarks.first.administrativeArea);
          print(placeMarks.first.subLocality);
          print(placeMarks.first.isoCountryCode);
          print(placeMarks);
          return placeMarks;
        }
      }
      //

      return [];
    } catch (e) {
      return [];
    }
  }
}
