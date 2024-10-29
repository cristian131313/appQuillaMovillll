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
        title: 'QuillaMóvil',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
          useMaterial3: true,
          primaryColor: Colors.blue,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        darkTheme: ThemeData.dark().copyWith(
          useMaterial3: true,
          primaryColor: Colors.blue,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
        ),
        themeMode: ThemeMode.system,
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
    bool isDarkMode = false;
    bool isSpanish = true;
    bool isManager = false;

    // Lista de próximos buses
    final List<Map<String, dynamic>> nextBuses = [
      {'route': 'A9-3', 'time': '2 minutos', 'distance': '500m'},
      {'route': 'A9-3', 'time': '8 minutos', 'distance': '1.5km'},
      {'route': 'A9-3', 'time': '15 minutos', 'distance': '3km'},
      {'route': 'A9-3', 'time': '20 minutos', 'distance': '4km'},
      {'route': 'A9-3', 'time': '25 minutos', 'distance': '5km'},
    ];

    final MapController _mapController = MapController();
    final List<Marker> _markers = [];
    final List<Polyline> _polylines = [];
    final LatLng barranquillaCentro = const LatLng(11.007883, -74.817127);
    bool _isLoading = true;
    LocationData? _currentLocation;
    Location location = Location();

    final List<String> routes = ['Ruta A9-3', 'Ruta U30'];

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
                const Icon(Icons.bus_alert, color: Colors.red, size: 30),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(2),
                  child: Text(
                    isSpanish ? 'Inicio A9-3' : 'Start A9-3',
                    style: const TextStyle(fontSize: 10),
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
                const Icon(Icons.bus_alert, color: Colors.green, size: 30),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(2),
                  child: Text(
                    isSpanish ? 'Final A9-3' : 'End A9-3',
                    style: const TextStyle(fontSize: 10),
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
                const Icon(Icons.bus_alert, color: Colors.red, size: 30),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(2),
                  child: Text(
                    isSpanish ? 'Inicio U30' : 'Start U30',
                    style: const TextStyle(fontSize: 10),
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
                const Icon(Icons.bus_alert, color: Colors.green, size: 30),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(2),
                  child: Text(
                    isSpanish ? 'Final U30' : 'End U30',
                    style: const TextStyle(fontSize: 10),
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
      });
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            isSpanish ? 'QuillaMóvil' : 'QuillaMobile',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: () {
                setState(() {
                  isDarkMode = !isDarkMode;
                });
              },
              tooltip: isSpanish ? 'Cambiar tema' : 'Toggle theme',
            ),
            IconButton(
              icon: const Icon(Icons.language),
              onPressed: () {
                setState(() {
                  isSpanish = !isSpanish;
                });
              },
              tooltip: isSpanish ? 'Cambiar idioma' : 'Toggle language',
            ),
            IconButton(
              icon: Icon(isManager ? Icons.logout : Icons.login),
              onPressed: () {
                if (isManager) {
                  setState(() {
                    isManager = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isSpanish ? 'Sesión cerrada' : 'Logged out'
                      ),
                    ),
                  );
                } else {
                  _showLoginDialog(context);
                }
              },
              tooltip: isManager 
                  ? (isSpanish ? 'Cerrar sesión' : 'Logout')
                  : (isSpanish ? 'Iniciar sesión' : 'Login'),
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
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.map),
              label: isSpanish ? 'Mapa' : 'Map',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.chat),
              label: isSpanish ? 'Comentarios' : 'Comments',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.newspaper),
              label: isSpanish ? 'Noticias' : 'News',
            ),
          ],
        ),
        floatingActionButton: _getFloatingActionButton(),
      );
    }

    Widget? _getFloatingActionButton() {
      if (_selectedIndex == 1) {
        return FloatingActionButton(
          onPressed: () {
            _showAddCommentDialog();
          },
          child: const Icon(Icons.add_comment),
        );
      } else if (_selectedIndex == 2 && isManager) {
        return FloatingActionButton(
          onPressed: () {
            _showAddNewsDialog();
          },
          child: const Icon(Icons.add),
        );
      }
      return null;
    }

    Widget _buildBody() {
      switch (_selectedIndex) {
        case 0:
          return _buildMapPage();
        case 1:
          return _buildCommentsPage();
        case 2:
          return _buildNewsPage();
        default:
          return _buildMapPage();
      }
    }
  Widget _buildMapPage() {
      return _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  flex: 4,
                  child: Stack(
                    children: [
                      FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: barranquillaCentro,
                          initialZoom: 13.0,
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
                        top: 16,
                        left: 16,
                        right: 16,
                        child: Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton<String>(
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
                                    _loadRouteData();
                                  });
                                }
                              },
                            ),
                          ),
                        ),
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
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  constraints: const BoxConstraints(maxHeight: 180),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Icon(Icons.directions_bus, 
                                  size: 40, 
                                  color: Colors.blue
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isSpanish ? 'Próximo Bus' : 'Next Bus',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        isSpanish 
                                            ? 'Llegará en ${nextBuses[0]['time']}'
                                            : 'Arriving in ${nextBuses[0]['time']}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  nextBuses[0]['distance'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    isSpanish ? 'Próximos Buses' : 'Next Buses',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                for (var i = 1; i < nextBuses.length; i++)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0,
                                      vertical: 2.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.directions_bus, size: 16),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Bus ${nextBuses[i]['route']}',
                                              style: const TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              nextBuses[i]['time'],
                                              style: const TextStyle(fontSize: 12),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              nextBuses[i]['distance'],
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
    }
  Widget _buildCommentsPage() {
      final routeComments = commentsByRoute[selectedRoute] ?? [];

      return routeComments.isEmpty
          ? Center(
              child: Text(
                isSpanish 
                    ? 'No hay comentarios aún'
                    : 'No comments yet',
                style: const TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: routeComments.length,
              itemBuilder: (context, index) {
                final comment = routeComments[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 4),
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
      return news.isEmpty
          ? Center(
              child: Text(
                isSpanish 
                    ? 'No hay noticias disponibles'
                    : 'No news available',
                style: const TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: news.length,
              itemBuilder: (context, index) {
                final newsItem = news[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
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
  void _showLoginDialog(BuildContext context) {
      final formKey = GlobalKey<FormState>();
      final TextEditingController userController = TextEditingController();
      final TextEditingController passwordController = TextEditingController();

      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text(isSpanish ? 'Ingreso como Gerente' : 'Manager Login'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: userController,
                    decoration: InputDecoration(
                      labelText: isSpanish ? 'Usuario' : 'Username',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return isSpanish ? 'Campo requerido' : 'Required field';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: isSpanish ? 'Contraseña' : 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return isSpanish ? 'Campo requerido' : 'Required field';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(isSpanish ? 'Cancelar' : 'Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    if (userController.text == 'quillamovil' &&
                        passwordController.text == '123') {
                      setState(() {
                        isManager = true;
                      });
                      Navigator.pop(dialogContext);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isSpanish ? 'Bienvenido, Gerente' : 'Welcome, Manager'
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        SnackBar(
                          content: Text(
                            isSpanish
                                ? 'Usuario o contraseña incorrectos'
                                : 'Invalid username or password'
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: Text(isSpanish ? 'Ingresar' : 'Login'),
              ),
            ],
          );
        },
      );
    }

    void _showAddCommentDialog() {
      final TextEditingController commentController = TextEditingController();
      final formKey = GlobalKey<FormState>();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(isSpanish ? 'Agregar Comentario' : 'Add Comment'),
            content: Form(
              key: formKey,
              child: TextFormField(
                controller: commentController,
                decoration: InputDecoration(
                  hintText: isSpanish
                      ? 'Escribe tu comentario aquí'
                      : 'Write your comment here',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return isSpanish 
                        ? 'El comentario no puede estar vacío' 
                        : 'Comment cannot be empty';
                  }
                  return null;
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(isSpanish ? 'Cancelar' : 'Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    setState(() {
                      commentsByRoute[selectedRoute] ??= [];
                      commentsByRoute[selectedRoute]!.add({
                        'user': isSpanish ? 'Usuario' : 'User',
                        'message': commentController.text,
                        'time': '${DateTime.now().hour}:${DateTime.now().minute}',
                      });
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isSpanish ? 'Comentario agregado' : 'Comment added'
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: Text(isSpanish ? 'Enviar' : 'Send'),
              ),
            ],
          );
        },
      );
    }

    void _showAddNewsDialog() {
      final TextEditingController titleController = TextEditingController();
      final TextEditingController contentController = TextEditingController();
      final formKey = GlobalKey<FormState>();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(isSpanish ? 'Agregar Noticia' : 'Add News'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: isSpanish ? 'Título' : 'Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return isSpanish ? 'El título es requerido' : 'Title is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: contentController,
                    decoration: InputDecoration(
                      labelText: isSpanish ? 'Contenido' : 'Content',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return isSpanish ? 'El contenido es requerido' : 'Content is required';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(isSpanish ? 'Cancelar' : 'Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    setState(() {
                      news.add({
                        'title': titleController.text,
                        'content': contentController.text,
                        'date': DateTime.now().toString().split(' ')[0],
                      });
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isSpanish ? 'Noticia agregada' : 'News added'
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: Text(isSpanish ? 'Guardar' : 'Save'),
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
      final formKey = GlobalKey<FormState>();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(isSpanish ? 'Editar Noticia' : 'Edit News'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: isSpanish ? 'Título' : 'Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return isSpanish ? 'El título es requerido' : 'Title is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: contentController,
                    decoration: InputDecoration(
                      labelText: isSpanish ? 'Contenido' : 'Content',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return isSpanish ? 'El contenido es requerido' : 'Content is required';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(isSpanish ? 'Cancelar' : 'Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    setState(() {
                      news[index] = {
                        'title': titleController.text,
                        'content': contentController.text,
                        'date': news[index]['date']!,
                      };
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isSpanish ? 'Noticia actualizada' : 'News updated'
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: Text(isSpanish ? 'Guardar' : 'Save'),
              ),
            ],
          );
        },
      );
    }
  }

