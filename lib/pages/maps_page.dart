import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  final Location _locationController = Location();

  static LatLng _initialPosition = const LatLng(0, 0);

  LatLng? _currentLocation;

  GoogleMapController? _mapController;

  bool _isTracking = false;
  final List<LatLng> _routeCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Future<void> getLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _initialPosition = await _locationController.getLocation().then((value) {
      return LatLng(value.latitude!, value.longitude!);
    });

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentLocation =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);

          if (_isTracking) {
            _routeCoordinates.add(_currentLocation!);
            updatePolyline();
          }
        });
        if (_mapController != null) {
          cameraToPosition(_currentLocation!);
        }
      }
    });
  }

  Future<void> cameraToPosition(LatLng position) async {
    if (_mapController != null) {
      CameraPosition newCameraPosition = CameraPosition(
        target: position,
        zoom: 14,
      );
      await _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(newCameraPosition),
      );
    }
  }

  void updatePolyline() {
    PolylineId id = const PolylineId("tracking");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: _routeCoordinates,
      width: 5,
    );
    setState(() {
      polylines[id] = polyline;
    });
  }

  void startTracking() {
    setState(() {
      _isTracking = true;
      _routeCoordinates.clear();
      polylines.clear();
      _initialPosition = _currentLocation!;
    });
  }

  void stopTracking() {
    setState(() {
      _isTracking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentLocation == null
          ? const Center(
              child: Text("Loading...."),
            )
          : Stack(
              children: [
                GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: _initialPosition,
                    zoom: 14,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId('_initialPosition'),
                      position: _initialPosition,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueGreen),
                    ),
                    Marker(
                      markerId: const MarkerId('_currentLocation'),
                      position: _currentLocation!,
                      icon: BitmapDescriptor.defaultMarker,
                    ),
                  },
                  polylines: Set<Polyline>.of(polylines.values),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloatingActionButton(
                        onPressed: () {
                          cameraToPosition(_currentLocation!);
                        },
                        child: const Icon(Icons.my_location),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          startTracking();
                        },
                        child: const Text("Start Tracking"),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          stopTracking();
                        },
                        child: const Text("End Tracking"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
