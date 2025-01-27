import '../models/city.dart';
import 'tsp_algorithms.dart'; // Importa os algoritmos

///  Função de nível superior para ser usada com `compute()`
Future<List<City>> computeTSP(List<dynamic> args) async {
  String algorithm = args[0];
  List<City> cities = args[1];

  switch (algorithm) {
    case 'Guloso':
      return nearestNeighbor(cities);
    case 'Força Bruta':
      return bruteForceTSP(cities);
    case 'Simulated Annealing':
      return simulatedAnnealing(cities);
    default:
      return [];
  }
}
