import 'package:flutter/material.dart';

class HistorialPedidosPage extends StatefulWidget {
  const HistorialPedidosPage({super.key});

  @override
  State<HistorialPedidosPage> createState() => _HistorialPedidosPageState();
}

class _HistorialPedidosPageState extends State<HistorialPedidosPage> {
  final List<Pedido> _pedidos = [
    Pedido(
      id: 'UNI-2024-001',
      fecha: DateTime(2024, 1, 15, 14, 30),
      estado: EstadoPedido.entregado,
      total: 185.00,
      items: [
        ItemPedido(
          nombre: 'Capuchino Mediano',
          cantidad: 2,
          precio: 45.00,
          personalizaciones: ['Leche de almendra', 'Extra caliente'],
        ),
        ItemPedido(
          nombre: 'Croissant de Jamón',
          cantidad: 1,
          precio: 35.00,
          personalizaciones: [],
        ),
        ItemPedido(
          nombre: 'Muffin de Arándanos',
          cantidad: 1,
          precio: 30.00,
          personalizaciones: [],
        ),
      ],
      direccionEntrega: 'Av. Reforma #123, Col. Centro',
      metodoPago: 'Tarjeta terminada en 4567',
      notas: 'Dejar en recepción',
    ),
    Pedido(
      id: 'UNI-2024-002',
      fecha: DateTime(2024, 1, 14, 9, 15),
      estado: EstadoPedido.entregado,
      total: 95.00,
      items: [
        ItemPedido(
          nombre: 'Latte Grande',
          cantidad: 1,
          precio: 50.00,
          personalizaciones: ['Sin azúcar', 'Leche deslactosada'],
        ),
        ItemPedido(
          nombre: 'Bagel con Qeso Crema',
          cantidad: 1,
          precio: 45.00,
          personalizaciones: ['Queso extra'],
        ),
      ],
      direccionEntrega: 'Oficina - Piso 5',
      metodoPago: 'Efectivo',
      notas: '',
    ),
    Pedido(
      id: 'UNI-2024-003',
      fecha: DateTime(2024, 1, 13, 16, 45),
      estado: EstadoPedido.cancelado,
      total: 120.00,
      items: [
        ItemPedido(
          nombre: 'Frappé Vainilla',
          cantidad: 1,
          precio: 60.00,
          personalizaciones: ['Crema batida extra'],
        ),
        ItemPedido(
          nombre: 'Club Sandwich',
          cantidad: 1,
          precio: 60.00,
          personalizaciones: ['Sin mayonesa'],
        ),
      ],
      direccionEntrega: 'Av. Insurgentes #456',
      metodoPago: 'Tarjeta terminada en 8910',
      notas: 'Cancelado por el cliente',
    ),
    Pedido(
      id: 'UNI-2024-004',
      fecha: DateTime(2024, 1, 12, 11, 20),
      estado: EstadoPedido.entregado,
      total: 75.00,
      items: [
        ItemPedido(
          nombre: 'Espresso Doble',
          cantidad: 1,
          precio: 40.00,
          personalizaciones: [],
        ),
        ItemPedido(
          nombre: 'Galleta de Chocolate',
          cantidad: 1,
          precio: 35.00,
          personalizaciones: [],
        ),
      ],
      direccionEntrega: 'Recoger en tienda',
      metodoPago: 'Apple Pay',
      notas: '',
    ),
    Pedido(
      id: 'UNI-2024-005',
      fecha: DateTime(2024, 1, 10, 8, 0),
      estado: EstadoPedido.entregado,
      total: 210.00,
      items: [
        ItemPedido(
          nombre: 'Iced Latte',
          cantidad: 3,
          precio: 52.00,
          personalizaciones: ['Dulce extra'],
        ),
        ItemPedido(
          nombre: 'Panini Caprese',
          cantidad: 2,
          precio: 65.00,
          personalizaciones: ['Albahaca extra'],
        ),
      ],
      direccionEntrega: 'Oficina - Sala de juntas',
      metodoPago: 'Tarjeta terminada en 4567',
      notas: 'Para reunión de 9:00 AM',
    ),
  ];

  FiltroPedido _filtroActual = FiltroPedido.todos;
  final TextEditingController _busquedaController = TextEditingController();
  String _terminoBusqueda = '';

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }

  List<Pedido> _getPedidosFiltrados() {
    var pedidosFiltrados = _pedidos;

    // Aplicar filtro por estado
    if (_filtroActual != FiltroPedido.todos) {
      pedidosFiltrados = pedidosFiltrados.where((pedido) {
        switch (_filtroActual) {
          case FiltroPedido.entregados:
            return pedido.estado == EstadoPedido.entregado;
          case FiltroPedido.cancelados:
            return pedido.estado == EstadoPedido.cancelado;
          default:
            return true;
        }
      }).toList();
    }

    // Aplicar búsqueda
    if (_terminoBusqueda.isNotEmpty) {
      pedidosFiltrados = pedidosFiltrados.where((pedido) =>
      pedido.id.toLowerCase().contains(_terminoBusqueda.toLowerCase()) ||
          pedido.items.any((item) =>
              item.nombre.toLowerCase().contains(_terminoBusqueda.toLowerCase()))).toList();
    }

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
      height: MediaQuery.of(context).size.height * 0.9,
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
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.receipt_long,
                  color: Colors.blue[700],
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pedido ${pedido.id}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        _formatearFechaCompleta(pedido.fecha),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildEstadoChip(pedido.estado),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Resumen del pedido
                  _buildSeccion(
                    titulo: 'Resumen del Pedido',
                    icono: Icons.shopping_bag,
                    child: Column(
                      children: [
                        ...pedido.items.map((item) => _buildItemResumen(item)),
                        const SizedBox(height: 16),
                        _buildLineaDivisoria(),
                        const SizedBox(height: 16),
                        _buildTotalPedido(pedido.total),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Información de entrega
                  _buildSeccion(
                    titulo: 'Información de Entrega',
                    icono: Icons.location_on,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoItem(
                          'Dirección:',
                          pedido.direccionEntrega,
                        ),
                        const SizedBox(height: 8),
                        _buildInfoItem(
                          'Método de Pago:',
                          pedido.metodoPago,
                        ),
                        if (pedido.notas.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          _buildInfoItem(
                            'Notas:',
                            pedido.notas,
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Acciones
                  if (pedido.estado == EstadoPedido.entregado)
                    _buildAccionesPedido(pedido),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeccion({
    required String titulo,
    required IconData icono,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icono, color: Colors.blue[700], size: 20),
            const SizedBox(width: 8),
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildItemResumen(ItemPedido item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.amber[700],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.cantidad}x ${item.nombre}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                if (item.personalizaciones.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.personalizaciones.join(', '),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ),
          Text(
            '\$${(item.precio * item.cantidad).toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalPedido(double total) {
    return Row(
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
          '\$${total.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue[700],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String titulo, String valor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          valor,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildAccionesPedido(Pedido pedido) {
    return Column(
      children: [
        _buildLineaDivisoria(),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _repetirPedido(pedido),
                icon: const Icon(Icons.replay),
                label: const Text('Repetir Pedido'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue[700],
                  side: BorderSide(color: Colors.blue[700]!),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _contactarSoporte(pedido),
                icon: const Icon(Icons.support_agent),
                label: const Text('Soporte'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLineaDivisoria() {
    return Divider(
      color: Colors.grey[300],
      height: 1,
    );
  }

  void _repetirPedido(Pedido pedido) {
    Navigator.pop(context); // Cerrar el bottom sheet
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.add_shopping_cart, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text('Pedido ${pedido.id} agregado al carrito'),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _contactarSoporte(Pedido pedido) {
    Navigator.pop(context); // Cerrar el bottom sheet
    // Aquí podrías navegar a la página de contacto
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Contactando soporte para el pedido ${pedido.id}'),
        backgroundColor: Colors.blue[700],
      ),
    );
  }

  Widget _buildEstadoChip(EstadoPedido estado) {
    final config = _getConfigEstado(estado);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: config.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: config.color, width: 1),
      ),
      child: Text(
        config.texto,
        style: TextStyle(
          color: config.color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  EstadoConfig _getConfigEstado(EstadoPedido estado) {
    switch (estado) {
      case EstadoPedido.entregado:
        return EstadoConfig(Colors.green, 'Entregado');
      case EstadoPedido.cancelado:
        return EstadoConfig(Colors.red, 'Cancelado');
    }
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }

  String _formatearFechaCompleta(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year} ${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final pedidosFiltrados = _getPedidosFiltrados();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Historial de Pedidos',
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
          // Filtros
          _buildFiltros(),

          // Barra de búsqueda
          _buildBarraBusqueda(),

          // Contador de resultados
          _buildContadorResultados(pedidosFiltrados.length),

          // Lista de pedidos
          Expanded(
            child: _buildListaPedidos(pedidosFiltrados),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltros() {
    return SizedBox(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildFiltroBoton('Todos', FiltroPedido.todos),
          _buildFiltroBoton('Entregados', FiltroPedido.entregados),
          _buildFiltroBoton('Cancelados', FiltroPedido.cancelados),
        ],
      ),
    );
  }

  Widget _buildFiltroBoton(String texto, FiltroPedido filtro) {
    final isSelected = _filtroActual == filtro;

    return Padding(
      padding: const EdgeInsets.only(right: 8, top: 12, bottom: 12),
      child: FilterChip(
        label: Text(texto),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _filtroActual = filtro;
          });
        },
        selectedColor: Colors.blue[700],
        checkmarkColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildBarraBusqueda() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _busquedaController,
        decoration: InputDecoration(
          hintText: 'Buscar por ID o producto...',
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

  Widget _buildContadorResultados(int cantidad) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            '$cantidad ${cantidad == 1 ? 'pedido encontrado' : 'pedidos encontrados'}',
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListaPedidos(List<Pedido> pedidos) {
    if (pedidos.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey),
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
        return _buildTarjetaPedido(pedido);
      },
    );
  }

  Widget _buildTarjetaPedido(Pedido pedido) {
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
              // Header con ID y estado
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    pedido.id,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  _buildEstadoChip(pedido.estado),
                ],
              ),

              const SizedBox(height: 12),

              // Fecha y total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatearFecha(pedido.fecha),
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '\$${pedido.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Items del pedido
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final item in pedido.items.take(2))
                    Text(
                      '${item.cantidad}x ${item.nombre}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  if (pedido.items.length > 2)
                    Text(
                      '+ ${pedido.items.length - 2} productos más...',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
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

// Enums y Modelos
enum EstadoPedido { entregado, cancelado }

enum FiltroPedido { todos, entregados, cancelados }

class EstadoConfig {
  final Color color;
  final String texto;

  EstadoConfig(this.color, this.texto);
}

class Pedido {
  final String id;
  final DateTime fecha;
  final EstadoPedido estado;
  final double total;
  final List<ItemPedido> items;
  final String direccionEntrega;
  final String metodoPago;
  final String notas;

  Pedido({
    required this.id,
    required this.fecha,
    required this.estado,
    required this.total,
    required this.items,
    required this.direccionEntrega,
    required this.metodoPago,
    required this.notas,
  });
}

class ItemPedido {
  final String nombre;
  final int cantidad;
  final double precio;
  final List<String> personalizaciones;

  ItemPedido({
    required this.nombre,
    required this.cantidad,
    required this.precio,
    required this.personalizaciones,
  });
}