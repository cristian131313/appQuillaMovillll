import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuillaMovil',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  String selectedRoute = 'Ruta A9-3';
  bool isManager = false;

  // Variables para el mapa
  final MapController _mapController = MapController();
  final List<Marker> _markers = [];
  final List<Polyline> _polylines = [];
  final LatLng barranquillaCentro = const LatLng(11.007883, -74.817127);
  bool _isLoading = true;
  LocationData? _currentLocation;
  Location location = Location();

  // Lista de rutas disponibles
  final List<String> routes = ['Ruta A9-3', 'Ruta U30'];

  // Lista de noticias de ejemplo
  final List<Map<String, String>> news = [
    {
      'title': 'Aumento de Pasaje',
      'content': 'La próxima semana se aumentará el pasaje en 300 pesos para todas las rutas.',
      'date': '2024-02-20'
    },
    {
      'title': 'Cambio Ruta A9-3',
      'content': 'A9-3: Cambio de ruta de la 43 y 54.',
      'date': '2024-02-19'
    },
    {
      'title': 'Mejora U30',
      'content': 'U30: Se espera una mejora en el servicio a partir de la próxima semana.',
      'date': '2024-02-18'
    },
  ];

  // Lista de comentarios por ruta
  final Map<String, List<Map<String, String>>> commentsByRoute = {
    'Ruta A9-3': [
      {
        'user': 'Usuario1',
        'message': 'El bus está demorando mucho hoy',
        'time': '10:30'
      },
    ],
    'Ruta U30': [
      {
        'user': 'Usuario2',
        'message': 'Bus llegando a la parada de la 43',
        'time': '10:35'
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _loadRouteData();
  }

  Future<void> _requestPermissions() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      _getCurrentLocation();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      var currentLocation = await location.getLocation();
      if (mounted) {
        setState(() {
          _currentLocation = currentLocation;
          _isLoading = false;
          
          _markers.add(
            Marker(
              point: LatLng(
                currentLocation.latitude!,
                currentLocation.longitude!,
              ),
              child: const Icon(
                Icons.location_on,
                color: Colors.blue,
                size: 40,
              ),
            ),
          );
        });
      }
    } catch (e) {
      print("Error getting location: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _loadRouteData() {
    if (selectedRoute == 'Ruta A9-3') {
      _loadRouteA93();
    } else if (selectedRoute == 'Ruta U30') {
      _loadRouteU30();
    }
  }

  void _loadRouteA93() {
    List<LatLng> routePoints = [
      LatLng(10.995447, -74.807745),
      LatLng(10.998452, -74.805302),
      LatLng(11.000471, -74.802891),
      LatLng(11.002443, -74.804167),
      LatLng(11.003763, -74.806566),
      LatLng(11.005257, -74.810969),
      LatLng(11.0052520, -74.8110798),
      LatLng(11.0063021, -74.8137038),
      LatLng(11.006955, -74.815234),
      LatLng(11.007883, -74.817127),
      LatLng(11.010660, -74.819444),
      LatLng(11.012248, -74.822100),
      LatLng(11.013387, -74.822621),
      LatLng(11.014995, -74.821180),
      LatLng(11.017639, -74.819739),
      LatLng(11.018461, -74.821960),
      LatLng(11.016403, -74.824770),
      LatLng(11.015440, -74.826669),
      LatLng(11.013230, -74.828410),
      LatLng(11.010519, -74.827407),
    ];

    setState(() {
      _markers.clear();
      _polylines.clear();
      
      _markers.addAll([
        Marker(
          point: routePoints.first,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.bus_alert,
                color: Colors.red,
                size: 30,
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(2),
                child: const Text(
                  'Inicio A9-3',
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ],
          ),
        ),
        Marker(
          point: routePoints.last,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.bus_alert,
                color: Colors.green,
                size: 30,
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(2),
                child: const Text(
                  'Final A9-3',
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ],
          ),
        ),
      ]);

      _polylines.add(
        Polyline(
          points: routePoints,
          color: Colors.blue,
          strokeWidth: 4.0,
        ),
      );

    });
  }

  void _loadRouteU30() {
    List<LatLng> routePoints = [
      LatLng(11.018832224735863, -74.86406528854319),
      LatLng(11.020978554683031, -74.87357392190157),
      LatLng(11.019198607583643, -74.87683078727594),
      LatLng(11.017179546896376, -74.87724579717417),
      LatLng(11.01426605469791, -74.8764428400634),
      LatLng(11.01712637201364, -74.85392823576741),
      LatLng(11.01689477325726, -74.85103149785947),
      LatLng(10.995498048347294, -74.80780954280341),
    ];

    setState(() {
      _markers.clear();
      _polylines.clear();
      
      _markers.addAll([
        Marker(
          point: routePoints.first,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.bus_alert,
                color: Colors.red,
                size: 30,
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(2),
                child: const Text(
                  'Inicio U30',
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ],
          ),
        ),
        Marker(
          point: routePoints.last,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.bus_alert,
                color: Colors.green,
                size: 30,
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(2),
                child: const Text(
                  'Final U30',
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ],
          ),
        ),
      ]);

      _polylines.add(
        Polyline(
          points: routePoints,
          color: Colors.red,
          strokeWidth: 4.0,
        ),
      );

      _mapController.move(
        LatLng(
          routePoints.map((p) => p.latitude).reduce((a, b) => a + b) / routePoints.length,
          routePoints.map((p) => p.longitude).reduce((a, b) => a + b) / routePoints.length,
        ),
        13.0,
      );
    });
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('QuillaMovil'),
        actions: [
          IconButton(
            icon: Icon(isManager ? Icons.logout : Icons.login),
            onPressed: () {
              if (isManager) {
                setState(() {
                  isManager = false;
                });
              } else {
                _showLoginDialog();
              }
            },
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Comentarios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'Noticias',
          ),
        ],
      ),
      floatingActionButton: _getFloatingActionButton(),
    );
  }

  Widget? _getFloatingActionButton() {
    if (_selectedIndex == 2) {
      return FloatingActionButton(
        onPressed: () {
          _showAddCommentDialog();
        },
        child: const Icon(Icons.add_comment),
      );
    } else if (_selectedIndex == 3 && isManager) {
      return FloatingActionButton(
        onPressed: () {
          _showAddNewsDialog();
        },
        child: const Icon(Icons.add),
      );
    }
    return null;
  }

  Widget _buildMapPage() {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: const LatLng(11.007883, -74.817127),
                  initialZoom: 13.0,
                  interactionOptions: const InteractionOptions(
                    enableScrollWheel: true,
                    enableMultiFingerGestureRace: true,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                    maxZoom: 19,
                  ),
                  PolylineLayer(
                    polylines: _polylines,
                  ),
                  MarkerLayer(
                    markers: _markers,
                  ),
                ],
              ),
              Positioned(
                right: 16,
                bottom: 16,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FloatingActionButton(
                      heroTag: "btn1",
                      onPressed: () {
                        if (_currentLocation != null) {
                          _mapController.move(
                            LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
                            15.0,
                          );
                        }
                      },
                      child: const Icon(Icons.my_location),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton(
                      heroTag: "btn2",
                      onPressed: _loadRouteData,
                      child: const Icon(Icons.refresh),
                    ),
                  ],
                ),
              ),
            ],
          );
  }

  void _showLoginDialog() {
    final TextEditingController userController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ingreso como Gerente'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: userController,
                decoration: const InputDecoration(
                  labelText: 'Usuario',
                ),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (userController.text == 'quillamovil' &&
                    passwordController.text == '123') {
                  setState(() {
                    isManager = true;
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Bienvenido, Gerente'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Usuario o contraseña incorrectos'),
                    ),
                  );
                }
              },
              child: const Text('Ingresar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomePage();
      case 1:
        return _buildMapPage();
      case 2:
        return _buildCommentsPage();
      case 3:
        return _buildNewsPage();
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selecciona una Ruta',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<String>(
                    value: selectedRoute,
                    isExpanded: true,
                    items: routes.map((String route) {
                      return DropdownMenuItem(
                        value: route,
                        child: Text(route),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedRoute = newValue;
                          _markers.clear();
                          _polylines.clear();
                          _loadRouteData();
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Información de la Ruta',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: const Icon(Icons.directions_bus),
              title: Text(selectedRoute),
              subtitle: const Text('Próximo bus en 5 minutos'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsPage() {
    final routeComments = commentsByRoute[selectedRoute] ?? [];

    return ListView.builder(
      itemCount: routeComments.length,
      itemBuilder: (context, index) {
        final comment = routeComments[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: Text(comment['message']!),
            subtitle: Text('${comment['user']} - ${comment['time']}'),
          ),
        );
      },
    );
  }

  Widget _buildNewsPage() {
    return ListView.builder(
      itemCount: news.length,
      itemBuilder: (context, index) {
        final newsItem = news[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  newsItem['title']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(newsItem['content']!),
                const SizedBox(height: 8),
                Text(
                  'Fecha: ${newsItem['date']}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                if (isManager) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showEditNewsDialog(index);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            news.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddCommentDialog() {
    final TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar Comentario'),
          content: TextField(
            controller: commentController,
            decoration: const InputDecoration(
              hintText: 'Escribe tu comentario aquí',
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (commentController.text.isNotEmpty) {
                  setState(() {
                    commentsByRoute[selectedRoute] ??= [];
                    commentsByRoute[selectedRoute]!.add({
                      'user': 'Usuario',
                      'message': commentController.text,
                      'time': '${DateTime.now().hour}:${DateTime.now().minute}',
                    });
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Enviar'),
            ),
          ],
        );
      },
    );
  }

  void _showAddNewsDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar Noticia'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                ),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'Contenido',
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    contentController.text.isNotEmpty) {
                  setState(() {
                    news.add({
                      'title': titleController.text,
                      'content': contentController.text,
                      'date': DateTime.now().toString().split(' ')[0],
                    });
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _showEditNewsDialog(int index) {
    final TextEditingController titleController =
        TextEditingController(text: news[index]['title']);
    final TextEditingController contentController =
        TextEditingController(text: news[index]['content']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Noticia'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                ),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'Contenido',
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    contentController.text.isNotEmpty) {
                  setState(() {
                    news[index] = {
                      'title': titleController.text,
                      'content': contentController.text,
                      'date': news[index]['date']!,
                    };
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}