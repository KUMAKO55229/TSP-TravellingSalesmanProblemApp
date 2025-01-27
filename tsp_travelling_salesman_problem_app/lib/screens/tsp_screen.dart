import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../managers/tsp_manager.dart';

class TspScreen extends StatelessWidget {
  const TspScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bem vindo Franck!'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Text(
            "Quais cidades você gostaria de visitar hoje?",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: () => Provider.of<TspManager>(context, listen: false)
                .generateCities(20),
            child: const Text('Gerar Cidades'),
          ),
          Text(
            "Qual algoritmo deseja usar? ",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Consumer<TspManager>(
            builder: (context, tspProvider, child) {
              return DropdownButton<String>(
                value: tspProvider.selectedAlgorithm,
                items: ['Guloso', 'Força Bruta', 'Simulated Annealing']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (alg) => tspProvider.solveTSP(alg!),
              );
            },
          ),
          Expanded(
            child: Consumer<TspManager>(
              builder: (context, tspProvider, child) {
                return GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                        -23.55052, -48.3317), // Posição inicial (São Paulo)
                    zoom: 5,
                  ),
                  markers: tspProvider
                      .cityMarkers, //  Atualiza automaticamente os marcadores
                  polylines: tspProvider
                      .bestPathPolyline, // Atualiza a rota automaticamente
                  onMapCreated: tspProvider.onMapCreated,
                );
              },
            ),
          ),
          Consumer<TspManager>(
            builder: (context, tspProvider, child) {
              if (!tspProvider.hasAnimationFinished) {
                return SizedBox.shrink();
              } else {
                return Text(
                    "Tempo de execução: ${tspProvider.executionTime.toStringAsFixed(2)} ms");
              }
            },
          ),
        ],
      ),
    );
  }
}
