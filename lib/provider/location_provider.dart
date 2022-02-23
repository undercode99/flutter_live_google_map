import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationProvider with ChangeNotifier {

  Location? _location;
  Location? get location => _location;
  LatLng? _locationPosition;
  LatLng? get locationPosition => _locationPosition;

  LocationProvider() {
    _location = Location();
  }

  initialization() async {
    await getUserLocation();
  }

  getUserLocation() async {
    bool _serviceEnable;
    PermissionStatus _permissionGranted;

    _serviceEnable = await location!.serviceEnabled();
    if (!_serviceEnable) {
      _serviceEnable = await location!.requestService();

      if (!_serviceEnable) {
        return;
      }
    }

    _permissionGranted = await location!.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location!.requestPermission();

      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    location!.onLocationChanged.listen((LocationData currentLocation) {
      _locationPosition =
          LatLng(currentLocation.latitude!, currentLocation.longitude!);
      notifyListeners();
    });
  }
}
