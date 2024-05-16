import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';

class PermissionHandlerModel extends ChangeNotifier {
  Location location = Location();

  bool isLocationPerGiven = false;
  bool isLocationSerGiven = false;

  PermissionHandlerModel() {
    location.changeSettings(accuracy: LocationAccuracy.high);
    location.hasPermission().then((status) {
      if (status == PermissionStatus.granted) {
        isLocationPerGiven = true;
        location.serviceEnabled().then((isEnabled) {
          if (isEnabled) {
            isLocationSerGiven = true;
          } else {
            isLocationSerGiven = false;
          }
          notifyListeners();
        });
      } else {
        isLocationPerGiven = false;
      }
      notifyListeners();
    });
  }

  Future<bool> checkAppLocationGranted() async {
    final permission = await location.hasPermission();
    return permission == PermissionStatus.granted;
  }

  requestAppLocationPermission() {
    location.requestPermission().then((status) {
      isLocationPerGiven = status == PermissionStatus.granted;
      notifyListeners();
    });
  }

  Future<bool> checkLocationServiceEnabled() {
    return location.serviceEnabled();
  }

  requestLocationServiceToEnable() {
    location.requestService().then((isGiven) {
      isLocationSerGiven = isGiven;
      notifyListeners();
    });
  }
}
