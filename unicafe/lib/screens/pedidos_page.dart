import 'package:flutter/material.dart';

class PedidosPage extends StatefulWidget {
  const PedidosPage({super.key});

  @override
  State<PedidosPage> createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  final List<EstadoPedido> _estados = [
    EstadoPedido(nombre: 'Todos', icono: Icons.list_alt),
    EstadoPedido(nombre: 'Pendientes', icono: Icons.access_time),
    EstadoPedido(nombre: 'En Proceso', icono: Icons.coffee),
    EstadoPedido(nombre: 'Completados', icono: Icons.check_circle),
    EstadoPedido(nombre: 'Cancelados', icono: Icons.cancel),
  ];

  final List<Pedido> _pedidos = [
    Pedido(
      id: 'UNI-001',
      productos: [
        ProductoPedido(
          nombre: 'Capuchino',
          cantidad: 2,
          precio: 45.00,
          personalizaciones: ['Leche deslactosada', 'Extra caliente'],
        ),
        ProductoPedido(
          nombre: 'Croissant',
          cantidad: 1,
          precio: 25.00,
          personalizaciones: [],
        ),
      ],
      estado: 'En Proceso',
      fecha: DateTime.now().subtract(const Duration(minutes: 15)),
      total: 115.00,
      notas: 'Para llevar',
    ),
    Pedido(
      id: 'UNI-002',
      productos: [
        ProductoPedido(
          nombre: 'Iced Latte',
          cantidad: 1,
          precio: 52.00,
          personalizaciones: ['Sin azúcar'],
        ),
        ProductoPedido(
          nombre: 'Muffin de Arándanos',
          cantidad: 1,
          precio: 30.00,
          personalizaciones: [],
        ),
      ],
      estado: 'Pendientes',
      fecha: DateTime.now().subtract(const Duration(minutes: 5)),
      total: 82.00,
      notas: '',
    ),
    Pedido(
      id: 'UNI-003',
      productos: [
        ProductoPedido(
          nombre: 'Espresso',
          cantidad: 1,
          precio: 35.00,
          personalizaciones: ['Doble shot'],
        ),
        ProductoPedido(
          nombre: 'Club Sandwich',
          cantidad: 1,
          precio: 75.00,
          personalizaciones: ['Sin mayonesa'],
        ),
      ],
      estado: 'Completados',
      fecha: DateTime.now().subtract(const Duration(hours: 2)),
      total: 110.00,
      notas: 'Mesa 4',
    ),
    Pedido(
      id: 'UNI-004',
      productos: [
        ProductoPedido(
          nombre: 'Mocha',
          cantidad: 1,
          precio: 55.00,
          personalizaciones: ['Crema batida extra'],
        ),
      ],
      estado: 'Cancelados',
      fecha: DateTime.now().subtract(const Duration(days: 1)),
      total: 55.00,
      notas: 'Cliente no llegó a recoger',
    ),
  ];

  int _estadoSeleccionado = 0;
  final TextEditingController _busquedaController = TextEditingController();
  String _terminoBusqueda = '';

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }

  List<Pedido> _getPedidosFiltrados() {
    List<Pedido> pedidosFiltrados = _pedidos;

    // Filtrar por estado
    if (_estadoSeleccionado > 0) {
      final estadoFiltro = _estados[_estadoSeleccionado].nombre;
      pedidosFiltrados = pedidosFiltrados
          .where((pedido) => pedido.estado == estadoFiltro)
          .toList();
    }

    // Filtrar por búsqueda
    if (_terminoBusqueda.isNotEmpty) {
      pedidosFiltrados = pedidosFiltrados
          .where((pedido) =>
      pedido.id.toLowerCase().contains(_terminoBusqueda.toLowerCase()) ||
          pedido.productos.any((producto) =>
              producto.nombre.toLowerCase().contains(_terminoBusqueda.toLowerCase())) ||
          pedido.notas.toLowerCase().contains(_terminoBusqueda.toLowerCase()))
          .toList();
    }

    // Ordenar por fecha (más reciente primero)
    pedidosFiltrados.sort((a, b) => b.fecha.compareTo(a.fecha));

    return pedidosFiltrados;
  }

  void _mostrarDetallesPedido(Pedido pedido) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildBottomSheetPedido(pedido),
    );
  }

  Widget _buildBottomSheetPedido(Pedido pedido) {
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
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _getColorEstado(pedido.estado).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getIconoEstado(pedido.estado),
                  color: _getColorEstado(pedido.estado),
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pedido ${pedido.id}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        _formatearFecha(pedido.fecha),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildBadgeEstado(pedido.estado),
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
                  // Productos
                  const Text(
                    'Productos:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Expanded(
                    child: ListView.builder(
                      itemCount: pedido.productos.length,
                      itemBuilder: (context, index) {
                        final producto = pedido.productos[index];
                        return _buildItemProductoPedido(producto);
                      },
                    ),
                  ),

                  // Notas
                  if (pedido.notas.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Notas:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        pedido.notas,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),

                  // Total
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          '\$${pedido.total.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Botones de acción
                  if (pedido.estado == 'Pendientes' || pedido.estado == 'En Proceso')
                    Row(
                      children: [
                        if (pedido.estado == 'Pendientes')
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _cambiarEstadoPedido(pedido, 'En Proceso'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Comenzar'),
                            ),
                          ),
                        if (pedido.estado == 'Pendientes') const SizedBox(width: 8),
                        if (pedido.estado == 'En Proceso')
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _cambiarEstadoPedido(pedido, 'Completados'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Completar'),
                            ),
                          ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _cambiarEstadoPedido(pedido, 'Cancelados'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Cancelar'),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemProductoPedido(ProductoPedido producto) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
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
                    ),
                  ),
                ),
                Text(
                  '${producto.cantidad}x',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '\$${(producto.precio * producto.cantidad).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
            if (producto.personalizaciones.isNotEmpty) ...[
              const SizedBox(height: 4),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: producto.personalizaciones.map((personalizacion) {
                  return Chip(
                    label: Text(
                      personalizacion,
                      style: const TextStyle(fontSize: 10),
                    ),
                    backgroundColor: Colors.amber[50],
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _cambiarEstadoPedido(Pedido pedido, String nuevoEstado) {
    setState(() {
      pedido.estado = nuevoEstado;
    });
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text('Pedido ${pedido.id} $nuevoEstado'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Color _getColorEstado(String estado) {
    switch (estado) {
      case 'Pendientes':
        return Colors.orange;
      case 'En Proceso':
        return Colors.blue;
      case 'Completados':
        return Colors.green;
      case 'Cancelados':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getIconoEstado(String estado) {
    switch (estado) {
      case 'Pendientes':
        return Icons.access_time;
      case 'En Proceso':
        return Icons.coffee;
      case 'Completados':
        return Icons.check_circle;
      case 'Cancelados':
        return Icons.cancel;
      default:
        return Icons.list_alt;
    }
  }

  Widget _buildBadgeEstado(String estado) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getColorEstado(estado).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getColorEstado(estado),
          width: 1,
        ),
      ),
      child: Text(
        estado,
        style: TextStyle(
          color: _getColorEstado(estado),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year} ${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mis Pedidos',
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

          // Estados
          _buildEstados(),

          // Lista de pedidos
          Expanded(
            child: _buildListaPedidos(),
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
          hintText: 'Buscar pedidos...',
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

  Widget _buildEstados() {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _estados.length,
        itemBuilder: (context, index) {
          final estado = _estados[index];
          final isSelected = index == _estadoSeleccionado;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                setState(() {
                  _estadoSeleccionado = index;
                });
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      estado.icono,
                      color: isSelected ? Colors.white : Colors.blue[700],
                      size: 20,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      estado.nombre,
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

  Widget _buildListaPedidos() {
    final pedidos = _getPedidosFiltrados();

    if (pedidos.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No se encontraron pedidos',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: pedidos.length,
      itemBuilder: (context, index) {
        final pedido = pedidos[index];
        return _buildItemPedido(pedido);
      },
    );
  }

  Widget _buildItemPedido(Pedido pedido) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _mostrarDetallesPedido(pedido),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header del pedido
              Row(
                children: [
                  Icon(
                    _getIconoEstado(pedido.estado),
                    color: _getColorEstado(pedido.estado),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Pedido ${pedido.id}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  _buildBadgeEstado(pedido.estado),
                ],
              ),

              const SizedBox(height: 8),

              // Fecha
              Text(
                _formatearFecha(pedido.fecha),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 12),

              // Productos resumen
              Column(
                children: pedido.productos.take(2).map((producto) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Text(
                          '• ${producto.nombre}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${producto.cantidad}x',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

              if (pedido.productos.length > 2) ...[
                Text(
                  '+ ${pedido.productos.length - 2} productos más',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],

              const SizedBox(height: 12),

              // Total y notas
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (pedido.notas.isNotEmpty)
                          Text(
                            'Nota: ${pedido.notas}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange[700],
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  Text(
                    'Total: \$${pedido.total.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EstadoPedido {
  final String nombre;
  final IconData icono;

  EstadoPedido({
    required this.nombre,
    required this.icono,
  });
}

class Pedido {
  String id;
  List<ProductoPedido> productos;
  String estado;
  DateTime fecha;
  double total;
  String notas;

  Pedido({
    required this.id,
    required this.productos,
    required this.estado,
    required this.fecha,
    required this.total,
    required this.notas,
  });
}

class ProductoPedido {
  final String nombre;
  final int cantidad;
  final double precio;
  final List<String> personalizaciones;

  ProductoPedido({
    required this.nombre,
    required this.cantidad,
    required this.precio,
    required this.personalizaciones,
  });
}