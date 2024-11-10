import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:user_tracking/consts.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  Location _locationController = Location();

  static const LatLng _googlePlex = LatLng(24.5902019, 73.8154624);
  static const LatLng _applePark = LatLng(24.5902019, 73.7054624);

  LatLng? _currentLocation;

  GoogleMapController? _mapController;

  bool _isTracking = false;
  List<LatLng> _routeCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Future<void> getLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

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
      CameraPosition _newCameraPosition = CameraPosition(
        target: position,
        zoom: 14,
      );
      await _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(_newCameraPosition),
      );
    }
  }


  void updatePolyline() {
    PolylineId id = PolylineId("tracking");
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
    });
  }

  void stopTracking() {
    setState(() {
      _isTracking = false;
      // Optionally, do something with _routeCoordinates
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentLocation == null
          ? Center(
        child: Text("Loading...."),
      )
          : Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: _currentLocation!,
              zoom: 14,
            ),
            markers: {
              Marker(
                markerId: MarkerId('_currentLocation'),
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
                  child: Icon(Icons.my_location),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    startTracking();
                  },
                  child: Text("Start Tracking"),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    stopTracking();
                  },
                  child: Text("End Tracking"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
