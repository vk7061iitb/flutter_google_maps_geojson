// ignore_for_file: avoid_print
import 'dart:convert';

import 'package:dart_shp/dart_shp.dart';
import 'package:dart_jts/dart_jts.dart';
import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

Future<String> loadGeoJsonFromFile() async {
  FilePickerResult? result =
      await FilePicker.platform.pickFiles(type: FileType.any);

  if (result != null) {
    File file = File(result.files.single.path!);
    // Do something with the picked file
    print('Picked file path: ${file.path}');
    return await file.readAsString();
  } else {
    // User canceled the picker
    print('User canceled the file picking');
    return '';
  }
}

void shp() async {
  // Generate some random lat, lon points
  final random = Random();
  final randomLats =
      List.generate(5, (index) => (random.nextDouble() * 180.0) - 90.0);
  final randomLons =
      List.generate(5, (index) => (random.nextDouble() * 360.0) - 180.0);

  // Generate the list of coordinates for the random lat lon lists
  final coordinates = List.generate(
      5, (index) => Coordinate.fromYX(randomLats[index], randomLons[index]));

  // Initialize a Geometry Factory
  final geometryFactory = GeometryFactory.defaultPrecision();

  // Convert the coordinates into points
  final points =
      coordinates.map((e) => geometryFactory.createPoint(e)).toList();

  // Initialize the writer and write the points file
  final writer = PointWriter(points, ShapeType.POINT);
  Directory? appExternalStorageDir = await getExternalStorageDirectory();

  writer.write(FileWriter(File('${appExternalStorageDir!.path}$random.shp')),
      FileWriter(File('${appExternalStorageDir.path}$random.shx')));
}

Future<void> mainPolygon() async {
  // Generate 3 random points, which guarantees as a simple/non-intersceting polygon.
  final random = Random();
  final randomLats =
      List.generate(3, (index) => (random.nextDouble() * 180.0) - 90.0);
  final randomLons =
      List.generate(3, (index) => (random.nextDouble() * 360.0) - 180.0);

  // Generate the list of coordinates for the random lat lon lists
  final coordinates = List.generate(
      3, (index) => Coordinate.fromYX(randomLats[index], randomLons[index]));

  // Close the polygon, ensure the final point is the same as the first point
  coordinates.add(coordinates.first);

  // Initialize a Geometry Factory
  final geometryFactory = GeometryFactory.defaultPrecision();

  // Convert the coordinates into points
  final poly = geometryFactory.createPolygonFromCoords(coordinates);

  // Initialize the writer and write the single polygon to file
  final writer = PolyWriter([poly], ShapeType.POLYGON);

  Directory? appExternalStorageDir = await getExternalStorageDirectory();

  writer.write(FileWriter(File('${appExternalStorageDir!.path}$random.shp')),
      FileWriter(File('${appExternalStorageDir.path}$random.shx')));
}

Map<String, dynamic> geoJson(String source) {
  Map<String, dynamic> jsonData = jsonDecode(source);
  return jsonData;
}

void readFile(String path1, String path2) async {
  print('step1');
  var shpFile = File(path1);
  FileReaderRandom(shpFile);
  var shxFile = File(path2);
  var reader =
      ShapefileReader(FileReaderRandom(shpFile), FileReaderRandom(shxFile));
  bool hasNextRecord = true;

  while (hasNextRecord) {
    var record = reader.nextRecord();
    print(record.toString());

    // Do something with the coordinates
  }
}
