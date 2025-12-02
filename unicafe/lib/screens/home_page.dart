import 'package:flutter/material.dart';

//cambiado por AngelPro99

// 1. Convertido a StatefulWidget
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 2. Lista para almacenar los artículos del pedido
  final List<Map<String, dynamic>> _orderItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Unicafé",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[700],
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      drawer: _buildDrawer(context),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBanner(),
            _buildCategoriesSection(),
            _buildFeaturedProducts(), // Ya no necesita 'context'
            _buildPromotionsSection(),
          ],
        ),
      ),

      // 1. Botón Flotante (FAB) agregado
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 3. Llama a la página del pedido
          _showOrderPage(context);
        },
        backgroundColor: Colors.blue[700],
        child: Badge(
          // 2. Badge para el contador
          label: Text(_orderItems.length.toString()),
          isLabelVisible: _orderItems.isNotEmpty,
          child: const Icon(
            Icons.shopping_cart,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue[800]!,
              Colors.blue[600]!,
              Colors.blue[400]!,
            ],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: const Text(
                "Admin",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              accountEmail: const Text(
                "Admin@gmail.com",
                style: TextStyle(fontSize: 14),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  "Ad",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blue[700],
              ),
            ),
            _buildDrawerItem(
              context,
              Icons.home,
              'Inicio',
              '/inicio',
              isSelected: true,
            ),
            _buildDrawerItem(
              context,
              Icons.restaurant_menu,
              'Menú Completo',
              '/menu',
            ),
            _buildDrawerItem(
              context,
              Icons.account_balance_wallet,
              'Mi Cartera',
              '/cartera',
            ),
            _buildDrawerItem(
              context,
              Icons.history,
              'Historial de Pedidos',
              '/historial',
            ),
            _buildDrawerItem(
              context,
              Icons.person,
              'Mi Perfil',
              '/perfil',
            ),
            _buildDrawerItem(
              context,
              Icons.contacts,
              'Contáctanos',
              '/contactanos',
            ),
            _buildDrawerItem(
              context,
              Icons.settings,
              'Configuración',
              '/configuracion',
            ),
            const Divider(color: Colors.white54),
            _buildDrawerItem(
              context,
              Icons.exit_to_app,
              'Cerrar Sesión',
              '/logout',
              isLogout: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context,
      IconData icon,
      String title,
      String route, {
        bool isSelected = false,
        bool isLogout = false,
      }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isLogout ? Colors.red[300] : Colors.white,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isLogout ? Colors.red[300] : Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.white54,
        ),
        onTap: () {
          Navigator.pop(context);
          if (!isLogout) {
            _navigateToRoute(context, route);
          } else {
            _showLogoutDialog(context);
          }
        },
      ),
    );
  }

  void _navigateToRoute(BuildContext context, String route) {
    final implementedRoutes = [
      '/inicio',
      '/configuracion',
      '/contactanos',
      '/cartera',
      '/historial',
      '/menu',
      '/perfil'
    ];

    if (implementedRoutes.contains(route)) {
      Navigator.pushNamed(context, route);
    } else {
      _showComingSoonPage(context, route);
    }
  }

  void _showComingSoonPage(BuildContext context, String routeName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Próximamente'),
            backgroundColor: Colors.blue[700],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.build, size: 80, color: Colors.blue[300]),
                const SizedBox(height: 20),
                const Text(
                  'Funcionalidad en Desarrollo',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  '¡Estamos trabajando en esta funcionalidad!',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      height: 200,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue[600]!,
            Colors.blue[800]!,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -50,
            top: -20,
            child: Icon(
              Icons.coffee,
              size: 200,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'UNICAFE',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Desayunos, comidas, postres y snacks',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 16),
                Chip(
                  backgroundColor: Colors.amber,
                  label: Text(
                    '¡20% de descuento en tu primer pedido!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection() {
    final categories = [
      {'icon': Icons.breakfast_dining, 'name': 'Desayunos', 'color': Colors.orange},
      {'icon': Icons.lunch_dining, 'name': 'Comidas', 'color': Colors.green},
      {'icon': Icons.cake, 'name': 'Postres', 'color': Colors.pink},
      {'icon': Icons.local_cafe, 'name': 'Bebidas', 'color': Colors.blue},
      {'icon': Icons.fastfood, 'name': 'Snacks', 'color': Colors.amber},
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Categorías',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return _buildCategoryCard(categories[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: category['color'].withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: category['color'].withOpacity(0.3)),
            ),
            child: Icon(
              category['icon'],
              size: 30,
              color: category['color'],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category['name'],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedProducts() {
    final products = [
      {
        'name': 'Huevos con Jamón',
        'description': 'Huevos revueltos con jamón, jugo de frutas y café',
        'price': '\$120',
        'category': 'Desayunos',
        'color': Colors.orange[100]!,
      },
      {
        'name': 'Ensalada César',
        'description': 'Ensalada fresca con pollo y aderezo césar',
        'price': '\$95',
        'category': 'Comidas',
        'color': Colors.green[100]!,
      },
      {
        'name': 'Cheesecake',
        'description': 'Delicioso cheesecake de fresa',
        'price': '\$65',
        'category': 'Postres',
        'color': Colors.pink[100]!,
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Productos Destacados',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 16),
          ...products.map((product) => _buildProductCard(product)).toList(),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              product['color'],
              Colors.white,
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.restaurant,
                  color: Colors.blue[600],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product['description'],
                      style: const TextStyle(fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        product['category'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    product['price'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      // 3. Lógica actualizada del botón
                      setState(() {
                        _orderItems.add(product);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product['name']} agregado al pedido'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Ordenar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromotionsSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Promociones Especiales',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.amber[100]!,
                    Colors.orange[100]!,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.local_offer, size: 40, color: Colors.orange),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '2x1 en Cafés Especiales',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text('Todos los días de 3:00 PM a 6:00 PM'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 3. Función _showOrderPage RESTAURADA
  void _showOrderPage(BuildContext context) {
    // Calcular el total
    double total = 0.0;
    for (var item in _orderItems) {
      try {
        // Extraer el número del string de precio (ej. "$120")
        String priceString = item['price'].replaceAll('\$', '');
        total += double.parse(priceString);
      } catch (e) {
        print('Error al parsear el precio: ${item['price']}');
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Mi Pedido'),
            backgroundColor: Colors.blue[700],
            iconTheme: const IconThemeData(color: Colors.white),
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          body: _orderItems.isEmpty
              ? const Center(
            child: Text(
              'No hay artículos en tu pedido.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          )
              : ListView.builder(
            itemCount: _orderItems.length,
            itemBuilder: (context, index) {
              final item = _orderItems[index];
              return ListTile(
                title: Text(item['name']),
                subtitle: Text(item['description']),
                trailing: Text(
                  item['price'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontSize: 16,
                  ),
                ),
              );
            },
          ),
          bottomNavigationBar: _orderItems.isNotEmpty
              ? BottomAppBar(
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: \$${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Lógica de pago (simulación)
                      Navigator.pop(context); // Cierra la página del pedido
                      setState(() {
                        _orderItems.clear(); // Limpia el carrito
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('¡Pedido realizado con éxito!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Pagar'),
                  ),
                ],
              ),
            ),
          )
              : null,
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Cerrar Sesión"),
          content: const Text("¿Estás seguro de que quieres cerrar sesión?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sesión cerrada exitosamente'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text("Cerrar Sesión"),
            ),
          ],
        );
      },
    );
  }
}