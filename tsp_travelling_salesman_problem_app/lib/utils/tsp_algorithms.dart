import 'dart:math';
import '../models/city.dart';

///  Algoritmo Guloso (Nearest Neighbor)
List<City> nearestNeighbor(List<City> cities) {
  if (cities.isEmpty) return [];

  List<City> unvisited = List.from(cities);
  List<City> path = [];
  City current = unvisited.removeAt(0);
  path.add(current);

  while (unvisited.isNotEmpty) {
    City nearest = unvisited.reduce(
        (a, b) => current.distanceTo(a) < current.distanceTo(b) ? a : b);
    unvisited.remove(nearest);
    path.add(nearest);
    current = nearest;
  }

  return path;
}

///  Força Bruta (Exaustivo) - SOMENTE PARA CASOS PEQUENOS
List<City> bruteForceTSP(List<City> cities) {
  if (cities.length > 10) return []; // Evita explosão combinatória

  List<City> bestPath = [];
  double bestDistance = double.infinity;

  void permute(List<City> list, int start) {
    if (start == list.length - 1) {
      double dist = totalDistance(list);
      if (dist < bestDistance) {
        bestDistance = dist;
        bestPath = List.from(list);
      }
    } else {
      for (int i = start; i < list.length; i++) {
        list.swap(start, i);
        permute(list, start + 1);
        list.swap(start, i);
      }
    }
  }

  permute(cities, 0);
  return bestPath;
}

///  Simulated Annealing (Metaheurística)
List<City> simulatedAnnealing(List<City> cities) {
  if (cities.isEmpty) return [];
  Random rand = Random();
  List<City> currentPath = List.from(cities);
  double currentDistance = totalDistance(currentPath);
  double temperature = 1000.0;
  double coolingRate = 0.995;

  while (temperature > 1) {
    int i = rand.nextInt(cities.length);
    int j = rand.nextInt(cities.length);
    currentPath.swap(i, j);
    double newDistance = totalDistance(currentPath);

    if (newDistance < currentDistance ||
        exp((currentDistance - newDistance) / temperature) >
            rand.nextDouble()) {
      currentDistance = newDistance;
    } else {
      currentPath.swap(i, j);
    }

    temperature *= coolingRate;
  }

  return currentPath;
}

///  Calcula a distância total do caminho
double totalDistance(List<City> path) {
  double distance = 0;
  for (int i = 0; i < path.length - 1; i++) {
    distance += path[i].distanceTo(path[i + 1]);
  }
  return distance;
}

///  Função de troca para listas
extension SwapList<T> on List<T> {
  void swap(int i, int j) {
    final temp = this[i];
    this[i] = this[j];
    this[j] = temp;
  }
}
