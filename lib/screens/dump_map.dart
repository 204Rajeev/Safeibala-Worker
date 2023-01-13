import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:provider/provider.dart';

import '../models/map_data.dart';
import '../models/worker.dart';
import '../providers/worker_provider.dart';

class MapScreen extends StatefulWidget {
  final long;
  final lati;
  final snap;
  const MapScreen({
    super.key,
    required this.long,
    required this.lati,
    required this.snap,
  });
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  static const _initialCameraPosition =
      CameraPosition(target: LatLng(20.296059, 85.824539), zoom: 15);
  double _originLatitude = 20.296059,
      _originLongitude = 85.824539; //20.296059, 85.824539
  double _destLatitude = 20.358824, _destLongitude = 85.833267;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyDLZ6mTp1L5UXo20Mz614ycF5_-oJU-z58";
  double distance = 0.0;
  MapData? mapdt;
  Worker? wrk;

  @override
  void initState() {
    super.initState();

    /// origin marker
    _addMarker(LatLng(widget.lati, widget.long), "origin",
        BitmapDescriptor.defaultMarker, 'Origin', 'Some Description');

    /// destination marker
    _addMarker(
      LatLng(double.parse(widget.snap['latitude']), double.parse(widget.snap['longitude'])),
        "destination",
        BitmapDescriptor.defaultMarkerWithHue(90),
        'Destination',
        'Some Description');
    _getPolyline();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text('Google Maps'),
          actions: [
            // if (_origin != null)
            TextButton(
              onPressed: () => mapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(widget.lati, widget.long),
                    zoom: 14.5,
                    tilt: 50.0,
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text('ORIGIN'),
            ),
            // if (_destination != null)
            TextButton(
              onPressed: () => mapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(
                        widget.snap['latitude'], widget.snap['longitude']),
                    zoom: 14.5,
                    tilt: 50.0,
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text('DEST'),
            )
          ],
        ),
        body: Stack(children: [
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            // CameraPosition(
            //     target: LatLng(_originLatitude, _originLongitude), zoom: 15),

            myLocationEnabled: true,
            tiltGesturesEnabled: true,
            compassEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            onMapCreated: _onMapCreated,
            markers: Set<Marker>.of(markers.values),
            polylines: Set<Polyline>.of(polylines.values),
          ),
          Positioned(
              bottom: 200,
              left: 50,
              child: Container(
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Total Distance: " + distance.toStringAsFixed(2) + " KM",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ))
        ]),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.black,
          onPressed: () => mapController.animateCamera(
              CameraUpdate.newCameraPosition(_initialCameraPosition)),
          child: const Icon(Icons.center_focus_strong),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor, String t,
      String sn) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
        markerId: markerId,
        icon: descriptor,
        position: position,
        infoWindow: InfoWindow(title: t, snippet: sn));
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 3,
      geodesic: true,
      jointType: JointType.mitered,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(_originLatitude, _originLongitude),
      PointLatLng(_destLatitude, _destLongitude),
      travelMode: TravelMode.driving,
      
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    double totalDistance = 0;
    for (var i = 0; i < polylineCoordinates.length - 1; i++) {
      totalDistance += calculateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude);
    }
    print(totalDistance);

    setState(() {
      distance = totalDistance;
    });

    _addPolyLine();
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
