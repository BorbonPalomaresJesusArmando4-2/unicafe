import 'package:flutter/material.dart';

const Color kColorPrimary = Color(0xFF3E2723); // Café oscuro
const Color kColorSecondary = Color(0xFF5D4037); // Café medio
const Color kColorAccent = Color(0xFFFFAB00); // Ámbar/Dorado
const Color kColorBackground = Color(0xFFFAFAFA); // Blanco hueso
const Color kColorText = Color(0xFF3E2723); // Texto oscuro

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> _orderItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorBackground, // Fondo general
      appBar: AppBar(
        title: const Text(
          "La Fondita del Coyote",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: kColorPrimary, // CAMBIO: Azul a Café
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
            _buildFeaturedProducts(),
            _buildPromotionsSection(),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showOrderPage(context);
        },
        backgroundColor: kColorAccent, // CAMBIO: Botón dorado
        child: Badge(
          label: Text(
            _orderItems.length.toString(),
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: kColorPrimary, // Badge café
          isLabelVisible: _orderItems.isNotEmpty,
          child: const Icon(
            Icons.shopping_cart,
            color: kColorPrimary, // Icono café sobre fondo dorado
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          // CAMBIO: Gradiente de cafés
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              kColorPrimary,
              kColorSecondary,
              Color(0xFF8D6E63),
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
                    color: kColorPrimary, // Texto café
                  ),
                ),
              ),
              decoration: const BoxDecoration(
                color: Colors.transparent, // Transparente para ver el gradiente
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
          color: isLogout ? Colors.red[200] : Colors.white,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isLogout ? Colors.red[200] : Colors.white,
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
            backgroundColor: kColorPrimary, // CAMBIO
            foregroundColor: Colors.white,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.coffee_maker, size: 80, color: kColorSecondary), // CAMBIO: Icono
                const SizedBox(height: 20),
                const Text(
                  'Funcionalidad en Desarrollo',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: kColorPrimary),
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
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4E342E), // Café claro
            Color(0xFF3E2723), // Café oscuro
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
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
              Icons.dining,
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
                  'La mejor comida de UTH al alcance de tu mano',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Desayunos, comidas, postres, bebidas, snacks y helados',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 16),
                Chip(
                  backgroundColor: kColorAccent,
                  side: const BorderSide(color: Colors.black, width: 1.5),

                  label: Text(
                    'Ordena hoy y obten 30 pesos de descuento',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kColorPrimary,
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
      {'icon': Icons.local_cafe, 'name': 'Bebidas', 'color': Colors.brown},
      {'icon': Icons.fastfood, 'name': 'Snacks', 'color': Colors.amber},
      {'icon': Icons.icecream, 'name': 'Helados', 'color': Colors.purple}, // Agregué uno extra para ejemplo de llenado
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Alineado a la izquierda se ve más ordenado si son muchos
        children: [
          const Center( // <--- Agrega esto
            child: Text(
              'Categorías',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: kColorText,
              ),
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6, // 4 Columnas: Las hace más pequeñas automáticamente
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.0, // 1.0 = Cuadrado perfecto (altura normal)
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return _buildCategoryCard(categories[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12), // Bordes menos redondeados para ahorrar espacio visual
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: category['color'].withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          // Acción al tocar
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              category['icon'],
              size: 30, // Icono de tamaño estándar
              color: category['color'],
            ),
            const SizedBox(height: 6), // Menos espacio entre icono y texto
            Text(
              category['name'],
              textAlign: TextAlign.center,
              maxLines: 1, // Asegura que no crezca verticalmente
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11, // Texto compacto
                fontWeight: FontWeight.w600,
                color: Color(0xFF3E2723),
              ),
            ),
          ],
        ),
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
        'color': Colors.orange[50]!,
      },
      {
        'name': 'Ensalada César',
        'description': 'Ensalada fresca con pollo y aderezo césar',
        'price': '\$95',
        'category': 'Comidas',
        'color': Colors.green[50]!,
      },
      {
        'name': 'Cheesecake',
        'description': 'Delicioso cheesecake de fresa',
        'price': '\$65',
        'category': 'Postres',
        'color': Colors.pink[50]!,
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'Productos Destacados',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: kColorText,
              ),
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
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          // Fondo sutil según el producto
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
                  color: kColorPrimary, // CAMBIO: Icono café
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
                      style: TextStyle(
                          fontSize: 14, color: Colors.grey[800]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: kColorPrimary.withOpacity(0.1), // Fondo café suave
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        product['category'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: kColorPrimary, // Texto café
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
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
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
                      backgroundColor: kColorAccent, // CAMBIO: Dorado
                      foregroundColor: kColorPrimary, // Texto café para contraste
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
          const Center(
            child: Text(
              'Productos Destacados',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: kColorText,
              ),
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
                          'Café Gratis en la compra del desayuno',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE65100),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text('Todos los días de 8 AM a 10 AM'),
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

  void _showOrderPage(BuildContext context) {
    double total = 0.0;
    for (var item in _orderItems) {
      try {
        String priceString = item['price'].replaceAll('\$', '');
        total += double.parse(priceString);
      } catch (e) {
        // Ignorar error de parseo
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Mi Pedido'),
            backgroundColor: kColorPrimary, // CAMBIO
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
                leading: Icon(Icons.coffee, color: kColorSecondary),
                title: Text(item['name']),
                subtitle: Text(item['description']),
                trailing: Text(
                  item['price'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
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
                      color: kColorPrimary, // CAMBIO
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        _orderItems.clear();
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
              child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
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
                foregroundColor: Colors.white,
              ),
              child: const Text("Cerrar Sesión"),
            ),
          ],
        );
      },
    );
  }
}