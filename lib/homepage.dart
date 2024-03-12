// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:g_maps/shp.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'feature_widger.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GoogleMapController mapController;
  String filePath = '';
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylines = {};
  String path1 = '';
  String path2 = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 0.9 * MediaQuery.of(context).size.height,
          child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(73.706873398188804, 16.779382137176),
                zoom: 15,
              ),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
                animateToLocation();
              },
              polylines: polylines),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton(
              onPressed: () async {
                filePath = await loadGeoJsonFromFile();
                setState(() {});
              },
              child: const Text('GeoJson'),
            ),
            OutlinedButton(
              onPressed: () async {
                plotMap();
                setState(() {
                  animateToLocation();
                });
              },
              child: const Text('Plot Map'),
            ),
          ],
        )
      ],
    );
  }

  void plotMap() {
    polylineCoordinates.clear();
    polylines.clear();
    // Decode the GeoJSON string
    Map<String, dynamic> jsonData = jsonDecode(filePath);
    // Access the features list
    List<dynamic> features = jsonData['features'];
    for (int i = 0; i < features.length; i++) {
      List<LatLng>points = [];
      Map<String, dynamic> jsonPolyline = features[i];
      print('${jsonPolyline['geometry']['coordinates'][0]}');
      List<dynamic> coordinates = jsonPolyline['geometry']['coordinates'];
      for (var data in coordinates) {
        polylineCoordinates.add( LatLng(data[1], data[0]),);
        points.add(
          LatLng(data[1], data[0]),
        );
      }
      Polyline tempPolyline = Polyline(
          consumeTapEvents: true,
          polylineId: PolylineId('$i'),
          color: Colors.blue,
          width: 5,
          points: points,
          onTap: () {
            // Handle tap on the polyline
            if (kDebugMode) {
              print('Polyline tapped!');
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return const SampleModalBottomSheet();
                  });
            }
          });

      polylines.add(tempPolyline);
    }

    setState(() {});
  }

  void animateToLocation() async {
    // Define the target location
    LatLng target = polylineCoordinates[polylineCoordinates.length ~/ 2];

    // Zoom the camera to the target location
    mapController.animateCamera(CameraUpdate.newLatLngZoom(target, 15));
  }
}
