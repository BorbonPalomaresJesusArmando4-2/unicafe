import 'package:flutter/material.dart';

// DEFINICIÓN DE COLORES (Misma paleta que en Home)
const Color kColorPrimary = Color(0xFF3E2723); // Café oscuro
const Color kColorSecondary = Color(0xFF5D4037); // Café medio
const Color kColorAccent = Color(0xFFFFAB00); // Ámbar/Dorado
const Color kColorBackground = Color(0xFFFAFAFA); // Blanco hueso
const Color kColorText = Color(0xFF3E2723); // Texto oscuro

class CarteraPage extends StatefulWidget {
  const CarteraPage({super.key});

  @override
  State<CarteraPage> createState() => _CarteraPageState();
}

class _CarteraPageState extends State<CarteraPage> {
  double _saldo = 1000;
  final List<Map<String, dynamic>> _recargas = [
    {
      'fecha': '15 Ene 2024',
      'hora': '14:30',
      'monto': 500.00,
      'metodo': 'Tarjeta ****1234',
      'estado': 'Completada',
    },
    {
      'fecha': '10 Ene 2024',
      'hora': '09:15',
      'monto': 300.00,
      'metodo': 'Tarjeta ****5678',
      'estado': 'Completada',
    },
    {
      'fecha': '05 Ene 2024',
      'hora': '16:45',
      'monto': 200.00,
      'metodo': 'Efectivo',
      'estado': 'Completada',
    },
  ];

  final List<Map<String, dynamic>> _tarjetas = [
    {
      'tipo': 'Visa',
      'numero': '**** 1234',
      'vencimiento': '12/25',
      'principal': true,
      'color': Colors.blue[900], // Mantenemos azul oscuro para Visa
    },
    {
      'tipo': 'MasterCard',
      'numero': '**** 5678',
      'vencimiento': '08/26',
      'principal': false,
      'color': Colors.red[800], // Rojo oscuro para Mastercard
    },
  ];

  void _mostrarDialogoRecarga() {
    final TextEditingController montoController = TextEditingController();
    String metodoSeleccionado = _tarjetas.isNotEmpty ? _tarjetas[0]['numero'] : 'Efectivo';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.account_balance_wallet, color: kColorPrimary), // CAMBIO: Icono Café
              SizedBox(width: 8),
              Text('Recargar Saldo'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Selecciona el monto y método de pago:'),
                const SizedBox(height: 16),

                // Método de pago
                const Text(
                  'Método de Pago:',
                  style: TextStyle(fontWeight: FontWeight.bold, color: kColorText),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: metodoSeleccionado,
                  items: [
                    ..._tarjetas.map((tarjeta) => DropdownMenuItem(
                      value: tarjeta['numero'],
                      child: Row(
                        children: [
                          Icon(
                            Icons.credit_card,
                            color: tarjeta['color'],
                          ),
                          const SizedBox(width: 8),
                          Text('Tarjeta ${tarjeta['numero']}'),
                        ],
                      ),
                    )),
                    const DropdownMenuItem(
                      value: 'Efectivo',
                      child: Row(
                        children: [
                          Icon(Icons.money, color: Colors.green),
                          SizedBox(width: 8),
                          Text('Efectivo'),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    metodoSeleccionado = value!;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kColorPrimary),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Monto
                const Text(
                  'Monto a Recargar:',
                  style: TextStyle(fontWeight: FontWeight.bold, color: kColorText),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: montoController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Monto',
                    prefixText: '\$',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kColorPrimary),
                    ),
                    hintText: '0.00',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa un monto';
                    }
                    final monto = double.tryParse(value);
                    if (monto == null || monto <= 0) {
                      return 'Monto inválido';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Montos rápidos
                const Text(
                  'Monto Rápido:',
                  style: TextStyle(fontWeight: FontWeight.bold, color: kColorText),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [50, 100, 200, 500].map((monto) {
                    return ChoiceChip(
                      label: Text('\$$monto'),
                      selected: montoController.text == monto.toString(),
                      selectedColor: kColorAccent, // CAMBIO: Dorado al seleccionar
                      labelStyle: TextStyle(
                        color: montoController.text == monto.toString()
                            ? kColorPrimary
                            : Colors.black,
                        fontWeight: montoController.text == monto.toString()
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      onSelected: (selected) {
                        montoController.text = monto.toString();
                        // Forzar reconstrucción para actualizar color del chip
                        (context as Element).markNeedsBuild();
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                final monto = double.tryParse(montoController.text);
                if (monto != null && monto > 0) {
                  _recargarSaldo(monto, metodoSeleccionado);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kColorAccent, // CAMBIO: Botón dorado
                foregroundColor: kColorPrimary, // Texto café
              ),
              child: const Text('Recargar'),
            ),
          ],
        );
      },
    );
  }

  void _recargarSaldo(double monto, String metodo) {
    setState(() {
      _saldo += monto;
      _recargas.insert(0, {
        'fecha': _obtenerFechaActual(),
        'hora': _obtenerHoraActual(),
        'monto': monto,
        'metodo': metodo,
        'estado': 'Completada',
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Recarga exitosa: \$$monto'),
        backgroundColor: Colors.green[700],
        duration: const Duration(seconds: 3),
      ),
    );
  }

  String _obtenerFechaActual() {
    final now = DateTime.now();
    return '${now.day} ${_obtenerMes(now.month)} ${now.year}';
  }

  String _obtenerHoraActual() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  String _obtenerMes(int mes) {
    const meses = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    return meses[mes - 1];
  }

  void _mostrarDialogoAgregarTarjeta() {
    final TextEditingController numeroController = TextEditingController();
    final TextEditingController nombreController = TextEditingController();
    final TextEditingController vencimientoController = TextEditingController();
    final TextEditingController cvvController = TextEditingController();
    String tipoTarjetaSeleccionada = 'Visa';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.credit_card, color: kColorPrimary), // CAMBIO
              SizedBox(width: 8),
              Text('Agregar Tarjeta'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tipo de tarjeta
                const Text(
                  'Tipo de Tarjeta:',
                  style: TextStyle(fontWeight: FontWeight.bold, color: kColorText),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: tipoTarjetaSeleccionada,
                  items: const [
                    DropdownMenuItem(
                      value: 'Visa',
                      child: Row(
                        children: [
                          Icon(Icons.credit_card, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('Visa'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'MasterCard',
                      child: Row(
                        children: [
                          Icon(Icons.credit_card, color: Colors.red),
                          SizedBox(width: 8),
                          Text('MasterCard'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'American Express',
                      child: Row(
                        children: [
                          Icon(Icons.credit_card, color: Colors.green),
                          SizedBox(width: 8),
                          Text('American Express'),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    tipoTarjetaSeleccionada = value!;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kColorPrimary),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Número de tarjeta
                TextFormField(
                  controller: numeroController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Número de Tarjeta',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kColorPrimary),
                    ),
                    hintText: '1234 5678 9012 3456',
                  ),
                  maxLength: 19,
                ),

                const SizedBox(height: 16),

                // Nombre en la tarjeta
                TextFormField(
                  controller: nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre en la Tarjeta',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kColorPrimary),
                    ),
                    hintText: 'JUAN PEREZ',
                  ),
                ),

                const SizedBox(height: 16),

                // Fecha de vencimiento y CVV
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: vencimientoController,
                        decoration: const InputDecoration(
                          labelText: 'MM/AA',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: kColorPrimary),
                          ),
                          hintText: '12/25',
                        ),
                        maxLength: 5,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: cvvController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'CVV',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: kColorPrimary),
                          ),
                          hintText: '123',
                        ),
                        maxLength: 3,
                        obscureText: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                if (numeroController.text.isNotEmpty &&
                    nombreController.text.isNotEmpty &&
                    vencimientoController.text.isNotEmpty &&
                    cvvController.text.isNotEmpty) {
                  _agregarTarjeta(
                    tipoTarjetaSeleccionada,
                    numeroController.text,
                    vencimientoController.text,
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kColorAccent, // CAMBIO: Botón dorado
                foregroundColor: kColorPrimary,
              ),
              child: const Text('Agregar Tarjeta'),
            ),
          ],
        );
      },
    );
  }

  void _agregarTarjeta(String tipo, String numero, String vencimiento) {
    // Simular el procesamiento de la tarjeta
    final ultimosCuatro = numero.length > 4 ? numero.substring(numero.length - 4) : numero;

    setState(() {
      _tarjetas.add({
        'tipo': tipo,
        'numero': '**** $ultimosCuatro',
        'vencimiento': vencimiento,
        'principal': false,
        'color': _obtenerColorTarjeta(tipo),
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tarjeta $tipo agregada exitosamente'),
        backgroundColor: Colors.green[700],
      ),
    );
  }

  Color _obtenerColorTarjeta(String tipo) {
    switch (tipo) {
      case 'Visa':
        return Colors.blue[900]!;
      case 'MasterCard':
        return Colors.red[800]!;
      case 'American Express':
        return Colors.green[800]!;
      default:
        return Colors.grey;
    }
  }

  void _establecerComoPrincipal(int index) {
    setState(() {
      for (int i = 0; i < _tarjetas.length; i++) {
        _tarjetas[i]['principal'] = (i == index);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tarjeta establecida como principal'),
        backgroundColor: kColorPrimary, // CAMBIO: Café
      ),
    );
  }

  void _eliminarTarjeta(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Tarjeta'),
          content: const Text('¿Estás seguro de que quieres eliminar esta tarjeta?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _tarjetas.removeAt(index);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Tarjeta eliminada'),
                    backgroundColor: Colors.red[700],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
                foregroundColor: Colors.white,
              ),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: kColorBackground, // CAMBIO: Fondo hueso
        appBar: AppBar(
          title: const Text(
            'Mi Cartera',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: kColorPrimary, // CAMBIO: Café oscuro
          foregroundColor: Colors.white,
          elevation: 0,
          // Color del indicador de la pestaña (la línea debajo)
          bottom: const TabBar(
            indicatorColor: kColorAccent, // CAMBIO: Indicador dorado
            labelColor: kColorAccent, // Icono seleccionado dorado
            unselectedLabelColor: Colors.white70, // No seleccionado blanco suave
            tabs: [
              Tab(text: 'Saldo', icon: Icon(Icons.account_balance_wallet)),
              Tab(text: 'Tarjetas', icon: Icon(Icons.credit_card)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Pestaña de Saldo
            _buildSaldoTab(),
            // Pestaña de Tarjetas
            _buildTarjetasTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildSaldoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tarjeta de saldo
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                // CAMBIO: Gradiente de cafés para simular el "Café"
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    kColorSecondary, // Café medio
                    kColorPrimary,   // Café oscuro
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Saldo Disponible',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$$_saldo',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Color Accent
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _mostrarDialogoRecarga,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kColorAccent, // CAMBIO: Botón dorado
                      foregroundColor: kColorPrimary, // Texto café
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add),
                        SizedBox(width: 8),
                        Text(
                          'Recargar Saldo',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Historial de recargas
          const Text(
            'Historial de Recargas',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: kColorText, // CAMBIO: Café
            ),
          ),
          const SizedBox(height: 16),

          if (_recargas.isEmpty)
            const Card(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(Icons.history, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No hay recargas recientes',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          else
            ..._recargas.map((recarga) {
              return Card(
                color: Colors.white,
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Icon(Icons.add_circle, color: Colors.green[700]),
                  title: Text(
                    '+\$${recarga['monto']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(recarga['metodo'], style: TextStyle(color: Colors.grey[800])),
                      Text('${recarga['fecha']} ${recarga['hora']}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    ],
                  ),
                  trailing: Chip(
                    label: Text(
                      recarga['estado'],
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                    padding: const EdgeInsets.all(0),
                    backgroundColor: Colors.green[700],
                  ),
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildTarjetasTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Botón para agregar tarjeta
          Card(
            color: Colors.white,
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.add_circle, color: kColorPrimary), // CAMBIO
              title: const Text(
                'Agregar Nueva Tarjeta',
                style: TextStyle(fontWeight: FontWeight.bold, color: kColorText),
              ),
              subtitle: const Text('Visa, MasterCard, American Express'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _mostrarDialogoAgregarTarjeta,
            ),
          ),

          const SizedBox(height: 24),

          // Lista de tarjetas
          const Text(
            'Mis Tarjetas',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: kColorText, // CAMBIO
            ),
          ),
          const SizedBox(height: 16),

          if (_tarjetas.isEmpty)
            const Card(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(Icons.credit_card_off, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No hay tarjetas registradas',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          else
            ..._tarjetas.asMap().entries.map((entry) {
              final index = entry.key;
              final tarjeta = entry.value;
              return Card(
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Icon(
                    Icons.credit_card,
                    color: tarjeta['color'], // Mantenemos el color de la marca (rojo/azul)
                    size: 32,
                  ),
                  title: Text(
                    '${tarjeta['tipo']} ${tarjeta['numero']}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: kColorText),
                  ),
                  subtitle: Text('Vence: ${tarjeta['vencimiento']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (tarjeta['principal'])
                        const Chip(
                          label: Text(
                            'Principal',
                            style: TextStyle(fontSize: 10, color: kColorPrimary),
                          ),
                          backgroundColor: kColorAccent, // CAMBIO: Dorado
                        )
                      else
                        IconButton(
                          icon: const Icon(Icons.star_border, color: kColorAccent), // Estrella dorada
                          onPressed: () => _establecerComoPrincipal(index),
                          tooltip: 'Establecer como principal',
                        ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.grey),
                        onPressed: () => _eliminarTarjeta(index),
                        tooltip: 'Eliminar tarjeta',
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
        ],
      ),
    );
  }
}