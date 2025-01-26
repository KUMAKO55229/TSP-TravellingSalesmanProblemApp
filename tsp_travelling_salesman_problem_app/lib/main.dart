import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tsp_travelling_salesman_problem_app/managers/tsp_manager.dart';
import 'screens/tsp_screen.dart';

void main() {
  runApp(const TSPApp());
}

class TSPApp extends StatelessWidget {
  const TSPApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TspManager()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const TspScreen(),
      ),
    );
  }
}
