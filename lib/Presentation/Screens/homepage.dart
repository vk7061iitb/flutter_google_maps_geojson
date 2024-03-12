import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:g_maps/Presentation/Widgets/appbar.dart';
import 'package:g_maps/shp.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Widgets/feature_widger.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GoogleMapController? mapController;
  String geoJsonData = '';
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylines = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
          Positioned.fill(
            child: SizedBox(
              child: GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(19.133623, 72.911895),
                    zoom: 15,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                    animateToLocation();
                  },
                  polylines: polylines),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                
                ElevatedButton(
                  onPressed: () async {
                    try {
                      geoJsonData = await loadGeoJsonFromFile();
                      setState(() {});
                    } catch (error) {
                      if (kDebugMode) {
                        print('Error loading GeoJSON file: $error');
                      }
                    }
                  },
                  child: const Text('Load GeoJson File'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (geoJsonData.isNotEmpty) {
                      plotMap();
                      setState(() {
                        animateToLocation();
                      });
                    } else {
                      if (kDebugMode) {
                        print('Please load GeoJSON data first.');
                      }
                    }
                  },
                  child: const Text('Plot Map'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void plotMap() {
    polylineCoordinates.clear();
    polylines.clear();
    Map<String, dynamic> jsonData;
    try {
      jsonData = jsonDecode(geoJsonData);
    } on FormatException catch (error) {
      if (kDebugMode) {
        print('Error parsing GeoJSON data: $error');
      }
      return;
    }
    List<dynamic> features = jsonData['features'];
    for (int i = 0; i < features.length; i++) {
      List<LatLng> points = [];
      Map<String, dynamic> feature = features[i];
      if (kDebugMode) {
        print("{feature['geometry']?.runtimeType}");
      }
      List<dynamic> coordinates = feature['geometry']['coordinates'];
      for (var data in coordinates) {
        polylineCoordinates.add(
          LatLng(data[1], data[0]),
        );
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
    LatLng target = polylineCoordinates[polylineCoordinates.length ~/ 2];
    mapController?.animateCamera(CameraUpdate.newLatLngZoom(target, 15));
  }
}
