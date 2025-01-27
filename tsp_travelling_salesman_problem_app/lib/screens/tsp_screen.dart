import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../managers/tsp_manager.dart';

class TspScreen extends StatelessWidget {
  const TspScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Caixeiro Viajante')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => Provider.of<TspManager>(context, listen: false)
                .generateCities(10),
            child: const Text('Gerar Cidades'),
          ),
          Expanded(
            child: Consumer<TspManager>(
              builder: (context, tspProvider, child) {
                return GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                        -23.55052, -46.633308), // Posição inicial (São Paulo)
                    zoom: 4,
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
              return DropdownButton<String>(
                value: tspProvider.selectedAlgorithm,
                items: ['Guloso', 'Força Bruta', 'Simulated Annealing']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (alg) => tspProvider.solveTSP(alg!),
              );
            },
          ),
          Consumer<TspManager>(
            builder: (context, tspProvider, child) {
              return Text(
                  "Tempo de execução: ${tspProvider.executionTime.toStringAsFixed(2)} ms");
            },
          ),
        ],
      ),
    );
  }
}
