# tsp_travelling_salesman_problem_app

📌 Projeto 2: Problema do Caixeiro Viajante (TSP)
📖 Descrição
Este projeto implementa soluções para o Problema do Caixeiro Viajante (TSP) utilizando diferentes algoritmos. A aplicação permite gerar cidades aleatórias e visualizar a rota otimizada para visitá-las utilizando um mapa interativo do Google Maps.

📂 Estrutura do Projeto
bash
Copiar
Editar
TSP-App/
│── lib/
│   │── screens/   # Interface com o usuário
│   │── managers/  # Controle do estado (Provider)
│   │── models/    # Modelos de dados (Cidade)
│   │── utils/     # Algoritmos e funções auxiliares
│   │── tsp_compute.dart  # Processamento paralelo dos algoritmos
│── android/
│── ios/
│── main.dart      # Arquivo principal
│── pubspec.yaml   # Dependências do Flutter
│── README.md
🛠 Tecnologias Utilizadas
-Flutter (Dart)
-Google Maps API para renderização do mapa
-Provider para gerenciamento de estado
-Isolates e Compute para processamento paralelo

🔧 Como Executar
Instale as dependências do Flutter:
flutter pub get
Configure a chave da API do Google Maps no AndroidManifest.xml:

<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="SUA_CHAVE_AQUI" />
    
Execute o projeto em um emulador ou dispositivo:

flutter run