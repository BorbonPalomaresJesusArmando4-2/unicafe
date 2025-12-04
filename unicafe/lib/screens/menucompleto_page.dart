import 'package:flutter/material.dart';

// DEFINICIÓN DE COLORES
const Color kColorPrimary = Color(0xFF3E2723); // Café oscuro
const Color kColorSecondary = Color(0xFF5D4037); // Café medio
const Color kColorAccent = Color(0xFFFFAB00); // Ámbar/Dorado
const Color kColorBackground = Color(0xFFFAFAFA); // Blanco hueso
const Color kColorText = Color(0xFF3E2723); // Texto oscuro

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
          imagen: 'assets/images/cafe/espresso.jpg',
          disponible: true,
        ),
        Producto(
          nombre: 'Capuchino',
          descripcion: 'Café con leche vaporizada y espuma',
          precio: 45.00,
          imagen: 'assets/images/cafe/capuchino.jpg',
          disponible: true,
        ),
        Producto(
          nombre: 'Latte',
          descripcion: 'Suave combinación de café y leche',
          precio: 50.00,
          imagen: 'assets/images/cafe/latte.jpg',
          disponible: true,
        ),
        Producto(
          nombre: 'Mocha',
          descripcion: 'Café con chocolate y leche',
          precio: 55.00,
          imagen: 'assets/images/cafe/mocha.jpg',
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
          imagen: 'assets/images/cafe/frappe.jpg',
          disponible: true,
        ),
        Producto(
          nombre: 'Iced Latte',
          descripcion: 'Latte helado con hielo',
          precio: 52.00,
          imagen: 'assets/images/cafe/iced-latte.jpg',
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
          imagen: 'assets/images/reposteria/croissant.jpg',
          disponible: true,
        ),
        Producto(
          nombre: 'Muffin de Arándanos',
          descripcion: 'Esponjoso muffin con arándanos frescos',
          precio: 30.00,
          imagen: 'assets/images/reposteria/muffin.jpg',
          disponible: true,
        ),
        Producto(
          nombre: 'Pay de Queso',
          descripcion: 'Delicioso cheesecake estilo New York',
          precio: 45.00,
          imagen: 'assets/images/reposteria/pay-queso.jpg',
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
          imagen: 'assets/images/sandwiches/club-sandwich.jpg',
          disponible: true,
        ),
        Producto(
          nombre: 'Panini Caprese',
          descripcion: 'Mozzarella, tomate y albahaca',
          precio: 65.00,
          imagen: 'assets/images/sandwiches/panini.jpg',
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
        color: kColorBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Header con imagen (PROTEGIDO CONTRA ERRORES)
          Stack(
            children: [
              SizedBox(
                height: 250,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  child: Image.asset(
                    producto.imagen,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Si falla la imagen, muestra esto:
                      return Container(
                        color: Colors.grey[300],
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                            Text("Imagen no disponible", style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Botón de cerrar
              Positioned(
                top: 16,
                left: 16,
                child: CircleAvatar(
                  backgroundColor: Colors.black45,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              // Precio flotante
              Positioned(
                bottom: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: kColorPrimary.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    '\$${producto.precio.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Contenido
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          producto.nombre,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: kColorText,
                          ),
                        ),
                      ),
                      _buildDisponibilidadBadge(producto.disponible),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Text(
                    producto.descripcion,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Ingredientes
                  const Text(
                    'Ingredientes:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kColorText,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
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
                        backgroundColor: kColorAccent,
                        foregroundColor: kColorPrimary,
                        disabledBackgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        producto.disponible
                            ? 'AGREGAR AL CARRITO'
                            : 'NO DISPONIBLE',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
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
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
      backgroundColor: Colors.white,
      side: BorderSide(color: kColorAccent.withOpacity(0.5)),
      elevation: 0,
      visualDensity: VisualDensity.compact,
    );
  }

  void _mostrarAgregadoCarrito(Producto producto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('¡Agregado al carrito!', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('${producto.nombre} se añadió correctamente'),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green[800],
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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: disponible ? Colors.green[700]! : Colors.red[700]!,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            disponible ? Icons.check_circle : Icons.cancel,
            size: 14,
            color: disponible ? Colors.green[700] : Colors.red[700],
          ),
          const SizedBox(width: 4),
          Text(
            disponible ? 'Disponible' : 'Agotado',
            style: TextStyle(
              color: disponible ? Colors.green[700] : Colors.red[700],
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorBackground,
      appBar: AppBar(
        title: const Text(
          'Menú Unicafé',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: kColorPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildBarraBusqueda(),
          _buildCategorias(),
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
        cursorColor: kColorPrimary,
        decoration: InputDecoration(
          hintText: 'Buscar en el menú...',
          prefixIcon: const Icon(Icons.search, color: kColorPrimary),
          suffixIcon: _terminoBusqueda.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear, color: Colors.grey),
            onPressed: () {
              _busquedaController.clear();
              setState(() {
                _terminoBusqueda = '';
              });
            },
          )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: kColorPrimary, width: 1.5),
          ),
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
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? kColorPrimary : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? kColorPrimary : Colors.grey[300]!,
                    width: 1.5,
                  ),
                  boxShadow: isSelected
                      ? [BoxShadow(color: kColorPrimary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]
                      : [],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      categoria.icono,
                      color: isSelected ? kColorAccent : kColorPrimary,
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      categoria.nombre,
                      style: TextStyle(
                        color: isSelected ? Colors.white : kColorText,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No se encontraron productos',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
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
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _mostrarDetallesProducto(producto),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Imagen del producto (PROTEGIDO CONTRA ERRORES)
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[200],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    producto.imagen,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Icono de respaldo si falla la imagen
                      return Center(
                        child: Icon(
                          Icons.coffee, // Icono de café
                          color: kColorPrimary.withOpacity(0.5),
                          size: 40,
                        ),
                      );
                    },
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            producto.nombre,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: kColorText,
                            ),
                          ),
                        ),
                        Text(
                          '\$${producto.precio.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kColorPrimary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Text(
                      producto.descripcion,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 12),

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