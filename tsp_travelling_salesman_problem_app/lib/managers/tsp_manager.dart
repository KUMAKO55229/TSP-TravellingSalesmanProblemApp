import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tsp_travelling_salesman_problem_app/utils/tsp_compute.dart';
import '../models/city.dart';

class TspManager extends ChangeNotifier {
  List<City> cities = [];
  List<City> bestPath = [];
  Set<Marker> cityMarkers = {};
  Set<Polyline> bestPathPolyline = {};
  bool isProcessing = false;
  String _selectedAlgorithm = 'Guloso';
  double _executionTime = 0.0;

  double get executionTime => _executionTime;

  GoogleMapController? _mapController;

  String get selectedAlgorithm => _selectedAlgorithm;

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  set selectedAlgorithm(String algorithm) {
    _selectedAlgorithm = algorithm;
    notifyListeners();
  }

  void generateCities(int count) {
    cities = List.generate(count, (_) => City(_randomLat(), _randomLng()));

    cityMarkers = cities
        .map((city) => Marker(
              markerId: MarkerId("${city.x},${city.y}"),
              position: LatLng(city.x, city.y),
            ))
        .toSet();

    solveTSP(selectedAlgorithm);
    notifyListeners();
  }

  Future<void> solveTSP(String algorithm) async {
    selectedAlgorithm = algorithm;
    isProcessing = true;
    notifyListeners();

    final stopwatch = Stopwatch()..start();

    bestPath = await compute(computeTSP, [algorithm, cities]);

    _executionTime = stopwatch.elapsedMilliseconds.toDouble();

    await animateAndDrawPath();
    isProcessing = false;
    notifyListeners();
  }

  ///  **Anima e desenha gradualmente a linha do caminho no mapa**
  Future<void> animateAndDrawPath() async {
    if (bestPath.isEmpty || _mapController == null) return;

    List<LatLng> animatedPath = [];
    for (int i = 0; i < bestPath.length; i++) {
      animatedPath.add(LatLng(bestPath[i].x, bestPath[i].y));

      bestPathPolyline = {
        Polyline(
          polylineId: const PolylineId("best_path"),
          color: Colors.blue,
          width: 4,
          points: List.from(animatedPath), //  Atualiza gradualmente
        ),
      };

      notifyListeners();

      _mapController!.animateCamera(
        CameraUpdate.newLatLng(LatLng(bestPath[i].x, bestPath[i].y)),
      );

      await Future.delayed(
          const Duration(milliseconds: 300)); //  Delay para animação
    }
  }

  double _randomLat() => -23.55052 + Random().nextDouble() * 10;
  double _randomLng() => -46.633308 + Random().nextDouble() * 10;
}
