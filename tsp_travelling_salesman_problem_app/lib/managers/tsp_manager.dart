import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/city.dart';
import '../utils/tsp_algorithms.dart';

class TspManager extends ChangeNotifier {
  List<City> cities = [];
  List<City> bestPath = [];
  Set<Marker> cityMarkers = {};
  Set<Polyline> bestPathPolyline = {};
  bool isProcessing = false;
  String _selectedAlgorithm = 'Guloso';
  double _executionTime = 0.0;

  double get executionTime => _executionTime; // Getter para UI

  GoogleMapController? _mapController;

  String get selectedAlgorithm => _selectedAlgorithm;
  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  set selectedAlgorithm(String algorithm) {
    _selectedAlgorithm = algorithm;
    notifyListeners(); //  Garante que o estado seja atualizado
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
    selectedAlgorithm = algorithm; //  Atualiza o estado antes de processar

    isProcessing = true;
    notifyListeners();

    final stopwatch = Stopwatch()..start();

    switch (algorithm) {
      case 'Guloso':
        bestPath = nearestNeighbor(cities);
        break;
      case 'Força Bruta':
        bestPath = bruteForceTSP(cities);
        break;
      case 'Simulated Annealing':
        bestPath = simulatedAnnealing(cities);
        break;
    }

    _executionTime = stopwatch.elapsedMilliseconds.toDouble(); //  Salva o tempo

    updatePathPolyline();
    isProcessing = false;
    notifyListeners();
  }

  void updatePathPolyline() {
    bestPathPolyline = {
      Polyline(
        polylineId: const PolylineId("best_path"),
        color: Colors.blue,
        width: 4,
        points: bestPath.map((c) => LatLng(c.x, c.y)).toList(),
      ),
    };
    notifyListeners();
  }

  void animatePath() async {
    if (bestPath.isEmpty || _mapController == null) return;

    for (int i = 0; i < bestPath.length; i++) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(LatLng(bestPath[i].x, bestPath[i].y)),
      );
      await Future.delayed(
          const Duration(milliseconds: 500)); // Delay para animação
      notifyListeners();
    }
  }

  double _randomLat() => -23.55052 + Random().nextDouble() * 10;
  double _randomLng() => -46.633308 + Random().nextDouble() * 10;
}
