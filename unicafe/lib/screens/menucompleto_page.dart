import 'package:flutter/material.dart';

class MenuCompletoPage extends StatefulWidget {
  const MenuCompletoPage({super.key});

  @override
  State<MenuCompletoPage> createState() => _MenuCompletoPageState();
}

class _MenuCompletoPageState extends State<MenuCompletoPage> {
  final List<CategoriaMenu> _categorias = [
    CategoriaMenu(
      nombre: 'Bebidas Calientes',
      icono: Icons.coffee,
      productos: [
        Producto(
          nombre: 'Espresso',
          descripcion: 'Café concentrado y aromático',
          precio: 35.00,
          imagen: 'assets/cafe/espresso.jpg',
          disponible: true,
        ),
        Producto(
          nombre: 'Capuchino',
          descripcion: 'Café con leche vaporizada y espuma',
          precio: 45.00,
          imagen: 'assets/cafe/capuchino.jpg',
          disponible: true,
        ),
        Producto(
          nombre: 'Latte',
          descripcion: 'Suave combinación de café y leche',
          precio: 50.00,
          imagen: 'assets/cafe/latte.jpg',
          disponible: true,
        ),
        Producto(
          nombre: 'Mocha',
          descripcion: 'Café con chocolate y leche',
          precio: 55.00,
          imagen: 'assets/cafe/mocha.jpg',
          disponible: false,
        ),
      ],
    ),
    CategoriaMenu(
      nombre: 'Bebidas Frías',
      icono: Icons.ac_unit,
      productos: [
        Producto(
          nombre: 'Frappé',
          descripcion: 'Bebida helada de café batido',
          precio: 60.00,
          imagen: 'assets/cafe/frappe.jpg',
          disponible: true,
        ),
        Producto(
          nombre: 'Iced Latte',
          descripcion: 'Latte helado con hielo',
          precio: 52.00,
          imagen: 'assets/cafe/iced_latte.jpg',
          disponible: true,
        ),
      ],
    ),
    CategoriaMenu(
      nombre: 'Repostería',
      icono: Icons.cake,
      productos: [
        Producto(
          nombre: 'Croissant',
          descripcion: 'Hojaldre francés recién horneado',
          precio: 25.00,
          imagen: 'assets/reposteria/croissant.jpg',
          disponible: true,
        ),
        Producto(
          nombre: 'Muffin de Arándanos',
          descripcion: 'Esponjoso muffin con arándanos frescos',
          precio: 30.00,
          imagen: 'assets/reposteria/muffin.jpg',
          disponible: true,
        ),
        Producto(
          nombre: 'Pay de Queso',
          descripcion: 'Delicioso cheesecake estilo New York',
          precio: 45.00,
          imagen: 'assets/reposteria/cheesecake.jpg',
          disponible: true,
        ),
      ],
    ),
    CategoriaMenu(
      nombre: 'Sandwiches',
      icono: Icons.lunch_dining,
      productos: [
        Producto(
          nombre: 'Club Sandwich',
          descripcion: 'Pollo, tocino, lechuga y tomate',
          precio: 75.00,
          imagen: 'assets/sandwiches/club.jpg',
          disponible: true,
        ),
        Producto(
          nombre: 'Panini Caprese',
          descripcion: 'Mozzarella, tomate y albahaca',
          precio: 65.00,
          imagen: 'assets/sandwiches/panini.jpg',
          disponible: true,
        ),
      ],
    ),
  ];

  int _categoriaSeleccionada = 0;
  final TextEditingController _busquedaController = TextEditingController();
  String _terminoBusqueda = '';

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }

  List<Producto> _getProductosFiltrados() {
    if (_terminoBusqueda.isEmpty) {
      return _categorias[_categoriaSeleccionada].productos;
    }

    return _categorias[_categoriaSeleccionada].productos
        .where((producto) =>
    producto.nombre.toLowerCase().contains(_terminoBusqueda.toLowerCase()) ||
        producto.descripcion.toLowerCase().contains(_terminoBusqueda.toLowerCase()))
        .toList();
  }

  void _mostrarDetallesProducto(Producto producto) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildBottomSheetProducto(producto),
    );
  }

  Widget _buildBottomSheetProducto(Producto producto) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Header con imagen
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              image: DecorationImage(
                image: NetworkImage(producto.imagen),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '\$${producto.precio.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Contenido
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          producto.nombre,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      _buildDisponibilidadBadge(producto.disponible),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Text(
                    producto.descripcion,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Ingredientes (simulado)
                  const Text(
                    'Ingredientes:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _buildIngredienteChip('Café Premium'),
                      _buildIngredienteChip('Leche Entera'),
                      _buildIngredienteChip('Vainilla Natural'),
                      if (producto.nombre.toLowerCase().contains('mocha'))
                        _buildIngredienteChip('Chocolate Belga'),
                    ],
                  ),

                  const Spacer(),

                  // Botón de acción
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: producto.disponible
                          ? () {
                        Navigator.pop(context);
                        _mostrarAgregadoCarrito(producto);
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[700],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        producto.disponible
                            ? 'Agregar al Carrito - \$${producto.precio.toStringAsFixed(2)}'
                            : 'No Disponible',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  Widget _buildIngredienteChip(String ingrediente) {
    return Chip(
      label: Text(
        ingrediente,
        style: const TextStyle(fontSize: 12),
      ),
      backgroundColor: Colors.amber[50],
      visualDensity: VisualDensity.compact,
    );
  }

  void _mostrarAgregadoCarrito(Producto producto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text('${producto.nombre} agregado al carrito'),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildDisponibilidadBadge(bool disponible) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: disponible ? Colors.green[50] : Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: disponible ? Colors.green : Colors.red,
          width: 1,
        ),
      ),
      child: Text(
        disponible ? 'Disponible' : 'Agotado',
        style: TextStyle(
          color: disponible ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Menú Unicafé',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          _buildBarraBusqueda(),

          // Categorías
          _buildCategorias(),

          // Lista de productos
          Expanded(
            child: _buildListaProductos(),
          ),
        ],
      ),
    );
  }

  Widget _buildBarraBusqueda() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _busquedaController,
        decoration: InputDecoration(
          hintText: 'Buscar en el menú...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _terminoBusqueda.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _busquedaController.clear();
              setState(() {
                _terminoBusqueda = '';
              });
            },
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        onChanged: (value) {
          setState(() {
            _terminoBusqueda = value;
          });
        },
      ),
    );
  }

  Widget _buildCategorias() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categorias.length,
        itemBuilder: (context, index) {
          final categoria = _categorias[index];
          final isSelected = index == _categoriaSeleccionada;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () {
                setState(() {
                  _categoriaSeleccionada = index;
                });
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue[700] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? Colors.blue[700]! : Colors.grey[300]!,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      categoria.icono,
                      color: isSelected ? Colors.white : Colors.blue[700],
                      size: 20,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      categoria.nombre,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildListaProductos() {
    final productos = _getProductosFiltrados();

    if (productos.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No se encontraron productos',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: productos.length,
      itemBuilder: (context, index) {
        final producto = productos[index];
        return _buildItemProducto(producto);
      },
    );
  }

  Widget _buildItemProducto(Producto producto) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _mostrarDetallesProducto(producto),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Imagen del producto
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(producto.imagen),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Información del producto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            producto.nombre,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Text(
                          '\$${producto.precio.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Text(
                      producto.descripcion,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    _buildDisponibilidadBadge(producto.disponible),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoriaMenu {
  final String nombre;
  final IconData icono;
  final List<Producto> productos;

  CategoriaMenu({
    required this.nombre,
    required this.icono,
    required this.productos,
  });
}


class Producto {
  final String nombre;
  final String descripcion;
  final double precio;
  final String imagen;
  final bool disponible;

  Producto({
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.imagen,
    required this.disponible,
  });
}