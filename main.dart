/*
🔐 CREDENCIALES DE PRUEBA:

SUPERVISOR:
- Usuario: admin
- Contraseña: admin123

REPARTIDORES:
- Usuario: juan
  Contraseña: juan123

- Usuario: maria
  Contraseña: maria123
*/

import 'package:flutter/material.dart';

void main() {
  runApp(const GreenGoApp());
}

class GreenGoApp extends StatelessWidget {
  const GreenGoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GreenGo Logistics',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

// DATOS DE USUARIOS
class UserData {
  static const Map<String, Map<String, dynamic>> usuarios = {
    'admin': {
      'password': 'admin123',
      'tipo': 'supervisor',
      'nombre': 'Administrador',
    },
    'juan': {
      'password': 'juan123',
      'tipo': 'repartidor',
      'nombre': 'Juan Pérez',
    },
    'maria': {
      'password': 'maria123',
      'tipo': 'repartidor',
      'nombre': 'María García',
    },
  };
}

// DATOS SIMULADOS (nuestra "base de datos")
class DeliveryData {
  static List<Map<String, dynamic>> entregas = [
    {
      'id': 1,
      'cliente': 'María González',
      'direccion': 'Calle 45 #23-10',
      'entregado': false,
      'repartidor': 'juan',
      'hora': '10:30 AM',
    },
    {
      'id': 2,
      'cliente': 'Pedro Martínez',
      'direccion': 'Carrera 27 #18-45',
      'entregado': false,
      'repartidor': 'juan',
      'hora': '11:00 AM',
    },
    {
      'id': 3,
      'cliente': 'Ana López',
      'direccion': 'Avenida 33 #12-67',
      'entregado': false,
      'repartidor': 'maria',
      'hora': '10:45 AM',
    },
    {
      'id': 4,
      'cliente': 'Carlos Ruiz',
      'direccion': 'Calle 52 #8-34',
      'entregado': true,
      'repartidor': 'juan',
      'hora': '09:30 AM',
    },
    {
      'id': 5,
      'cliente': 'Laura Díaz',
      'direccion': 'Carrera 15 #28-90',
      'entregado': false,
      'repartidor': 'maria',
      'hora': '11:30 AM',
    },
    {
      'id': 6,
      'cliente': 'Roberto Silva',
      'direccion': 'Calle 38 #15-22',
      'entregado': true,
      'repartidor': 'maria',
      'hora': '09:00 AM',
    },
    {
      'id': 7,
      'cliente': 'Sofia Torres',
      'direccion': 'Carrera 42 #30-11',
      'entregado': false,
      'repartidor': 'juan',
      'hora': '12:00 PM',
    },
  ];

  static int get totalEntregas => entregas.length;
  static int get entregasCompletadas =>
      entregas.where((e) => e['entregado'] == true).length;
  static double get porcentajeCompletado =>
      (entregasCompletadas / totalEntregas) * 100;

  static List<Map<String, dynamic>> getEntregasPorRepartidor(String repartidor) {
    return entregas
        .where((e) => e['repartidor'] == repartidor && e['entregado'] == false)
        .toList();
  }
}

// PANTALLA DE LOGIN REAL
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _usuarioController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool _isLoading = false;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _usuarioController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _login() {
    setState(() => _isLoading = true);

    // Simulamos un pequeño delay para que se vea el loading
    Future.delayed(const Duration(seconds: 1), () {
      final usuario = _usuarioController.text.toLowerCase();
      final password = _passwordController.text;

      if (UserData.usuarios.containsKey(usuario)) {
        final userData = UserData.usuarios[usuario]!;
        if (userData['password'] == password) {
          // Login exitoso
          if (userData['tipo'] == 'supervisor') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SupervisorScreen(nombre: userData['nombre']),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => RepartidorScreen(
                  usuario: usuario,
                  nombre: userData['nombre'],
                ),
              ),
            );
          }
        } else {
          _mostrarError('Contraseña incorrecta 🔒');
        }
      } else {
        _mostrarError('Usuario no encontrado 🤔');
      }

      setState(() => _isLoading = false);
    });
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.green[700]!, Colors.green[400]!],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo con Hero animation
                    Hero(
                      tag: 'logo',
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.pedal_bike,
                          size: 80,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    // Título
                    const Text(
                      'GreenGo Logistics',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '🌱 Entregas sostenibles',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 50),
                    
                    // Formulario
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: _usuarioController,
                            decoration: InputDecoration(
                              labelText: 'Usuario',
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _passwordController,
                            obscureText: !_passwordVisible,
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onSubmitted: (_) => _login(),
                          ),
                          const SizedBox(height: 25),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[700],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Iniciar Sesión',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    // Ayuda
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('💡 Usuarios de Prueba'),
                            content: const Text(
                              'Supervisor:\n• Usuario: admin\n• Contraseña: admin123\n\nRepartidores:\n• Usuario: juan\n  Contraseña: juan123\n\n• Usuario: maria\n  Contraseña: maria123',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Entendido'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text(
                        '¿Necesitas ayuda? Ver usuarios de prueba',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RepartidorScreen extends StatefulWidget {
  final String usuario;
  final String nombre;

  const RepartidorScreen({
    Key? key,
    required this.usuario,
    required this.nombre,
  }) : super(key: key);

  @override
  State<RepartidorScreen> createState() => _RepartidorScreenState();
}

class _RepartidorScreenState extends State<RepartidorScreen> {
  int _puntos = 0;

  @override
  Widget build(BuildContext context) {
    final pendientes = DeliveryData.getEntregasPorRepartidor(widget.usuario);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text('Hola, ${widget.nombre.split(' ')[0]}! 👋'),
            Text(
              '⭐ $_puntos puntos',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        backgroundColor: Colors.green[700],
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Hero(
                tag: 'badge_${widget.usuario}',
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${pendientes.length} 📦',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: pendientes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'logo',
                    child: Icon(Icons.celebration, size: 100, color: Colors.green[300]),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '¡Todo entregado! 🎉',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'No tienes entregas pendientes',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pendientes.length,
              itemBuilder: (context, index) {
                final entrega = pendientes[index];
                return Hero(
                  tag: 'entrega_${entrega['id']}',
                  child: Material(
                    color: Colors.transparent,
                    child: _buildEntregaCard(entrega),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildEntregaCard(Map<String, dynamic> entrega) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.location_on, color: Colors.green[700]),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entrega['cliente'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        entrega['direccion'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            entrega['hora'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    entrega['entregado'] = true;
                    _puntos += 10; // Ganamos puntos!
                  });
                  
                  // Mostrar celebración
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 80,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            '¡Entrega completada!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '+10 puntos ⭐',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('¡Genial!'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.check_circle),
                label: const Text('Marcar como Entregado', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SupervisorScreen extends StatefulWidget {
  final String nombre;

  const SupervisorScreen({Key? key, required this.nombre}) : super(key: key);

  @override
  State<SupervisorScreen> createState() => _SupervisorScreenState();
}

class _SupervisorScreenState extends State<SupervisorScreen> {
  String _filtro = 'Todas'; // 'Todas', 'Completadas', 'Pendientes'

  @override
  Widget build(BuildContext context) {
    final porcentaje = DeliveryData.porcentajeCompletado;
    
    List<Map<String, dynamic>> entregasFiltradas = DeliveryData.entregas;
    if (_filtro == 'Completadas') {
      entregasFiltradas = DeliveryData.entregas.where((e) => e['entregado'] == true).toList();
    } else if (_filtro == 'Pendientes') {
      entregasFiltradas = DeliveryData.entregas.where((e) => e['entregado'] == false).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Panel - ${widget.nombre}', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[700],
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {}); // Refresca
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Actualizado ✓'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Tarjeta de estadísticas con Hero
          Hero(
            tag: 'stats_card',
            child: Material(
              color: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green[700]!, Colors.green[500]!],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Progreso del Día 🚴',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCard(
                          'Total',
                          '${DeliveryData.totalEntregas}',
                          Icons.inventory,
                        ),
                        _buildStatCard(
                          'Completadas',
                          '${DeliveryData.entregasCompletadas}',
                          Icons.check_circle,
                        ),
                        _buildStatCard(
                          'Pendientes',
                          '${DeliveryData.totalEntregas - DeliveryData.entregasCompletadas}',
                          Icons.pending,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        Text(
                          '${porcentaje.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: porcentaje / 100,
                            minHeight: 10,
                            backgroundColor: Colors.white.withOpacity(0.3),
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Filtros
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text(
                  'Filtrar:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                _buildChipFiltro('Todas'),
                const SizedBox(width: 8),
                _buildChipFiltro('Completadas'),
                const SizedBox(width: 8),
                _buildChipFiltro('Pendientes'),
              ],
            ),
          ),
          const SizedBox(height: 10),
          
          // Lista de entregas
          Expanded(
            child: entregasFiltradas.isEmpty
                ? const Center(
                    child: Text(
                      'No hay entregas en esta categoría',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: entregasFiltradas.length,
                    itemBuilder: (context, index) {
                      final entrega = entregasFiltradas[index];
                      final entregado = entrega['entregado'];
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: entregado ? Colors.green[50] : Colors.orange[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              entregado ? Icons.check_circle : Icons.access_time,
                              color: entregado ? Colors.green : Colors.orange,
                            ),
                          ),
                          title: Text(
                            entrega['cliente'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: entregado ? TextDecoration.lineThrough : null,
                              color: entregado ? Colors.grey : Colors.black,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(entrega['direccion']),
                              Text(
                                'Repartidor: ${entrega['repartidor']} | ${entrega['hora']}',
                                style: const TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: entregado ? Colors.green : Colors.orange,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              entregado ? '✓' : '⏳',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 30),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChipFiltro(String label) {
    final isSelected = _filtro == label;
    return InkWell(
      onTap: () {
        setState(() {
          _filtro = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green[700] : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
