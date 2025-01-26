import 'package:flutter/material.dart';
import '../models/city.dart';
import '../utils/tsp_algorithms.dart';

class TspManager extends ChangeNotifier {
  List<City> cities = [];
  List<City> bestPath = [];
  bool isProcessing = false;

  // 🔥 Adiciona a variável para armazenar o algoritmo selecionado
  String selectedAlgorithm = 'Guloso';

  void generateCities(int count) {
    cities = List.generate(
        count, (_) => City(100 + (300 * _random()), 100 + (300 * _random())));
    print("Cidades geradas: ${cities.length}");
    for (var city in cities) {
      print("Cidade em: (${city.x}, ${city.y})");
    }

    notifyListeners();
  }

  // 🔥 Método para atualizar o algoritmo selecionado
  void setAlgorithm(String algorithm) {
    selectedAlgorithm = algorithm;
    notifyListeners();
  }

  Future<void> solveTSP() async {
    if (cities.isEmpty) return;

    isProcessing = true;
    notifyListeners();

    switch (selectedAlgorithm) {
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

    isProcessing = false;
    notifyListeners();
  }

  double _random() =>
      (100 + 300 * (DateTime.now().millisecondsSinceEpoch % 100) / 100);
}
