import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tsp_travelling_salesman_problem_app/managers/tsp_manager.dart';
import '../models/city.dart';

class TspScreen extends StatelessWidget {
  const TspScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tspProvider = Provider.of<TspManager>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Caixeiro Viajante')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              tspProvider.generateCities(10);
              tspProvider.solveTSP(); // 🔥 Agora resolve automaticamente!
            },
            child: const Text('Gerar Cidades'),
          ),
          Expanded(
            child: tspProvider.cities.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CustomPaint(
                      painter: TSPPainter(tspProvider.bestPath),
                      child: Container(),
                    ),
                  )
                : const Text('Nenhuma cidade gerada'),
          ),
          DropdownButton<String>(
            value: tspProvider.selectedAlgorithm,
            items: ['Guloso', 'Força Bruta', 'Simulated Annealing']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (alg) {
              tspProvider.setAlgorithm(alg!);
              tspProvider.solveTSP(); //  Atualiza ao trocar algoritmo!
            },
          ),
        ],
      ),
    );
  }
}

// 🎨 CustomPainter que desenha o caminho
class TSPPainter extends CustomPainter {
  final List<City> path;
  TSPPainter(this.path);

  @override
  void paint(Canvas canvas, Size size) {
    if (path.isEmpty) return;

    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final pointPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 8
      ..style = PaintingStyle.fill;

    // 🔥 Normaliza coordenadas para caber na tela
    double minX = path.map((c) => c.x).reduce((a, b) => a < b ? a : b);
    double minY = path.map((c) => c.y).reduce((a, b) => a < b ? a : b);
    double maxX = path.map((c) => c.x).reduce((a, b) => a > b ? a : b);
    double maxY = path.map((c) => c.y).reduce((a, b) => a > b ? a : b);

    double scaleX = size.width / (maxX - minX + 50);
    double scaleY = size.height / (maxY - minY + 50);

    Offset normalize(City city) => Offset(
          (city.x - minX) * scaleX + 25,
          (city.y - minY) * scaleY + 25,
        );

    // 🔵 Desenha os pontos das cidades
    for (var city in path) {
      canvas.drawCircle(normalize(city), 5, pointPaint);
    }

    // 🔷 Desenha as conexões entre cidades
    for (int i = 0; i < path.length - 1; i++) {
      canvas.drawLine(normalize(path[i]), normalize(path[i + 1]), paint);
    }

    // 🔄 Fecha o ciclo
    if (path.length > 2) {
      canvas.drawLine(normalize(path.last), normalize(path.first), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
