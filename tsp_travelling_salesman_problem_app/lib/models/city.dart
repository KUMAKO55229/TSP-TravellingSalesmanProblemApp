import 'dart:math';

class City {
  final double x;
  final double y;

  City(this.x, this.y);

  /// Calcula a distância euclidiana entre duas cidades
  double distanceTo(City other) {
    return sqrt(pow(x - other.x, 2) + pow(y - other.y, 2));
  }
}
