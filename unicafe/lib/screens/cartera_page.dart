import 'package:flutter/material.dart';

class CarteraPage extends StatefulWidget {
  const CarteraPage({super.key});

  @override
  State<CarteraPage> createState() => _CarteraPageState();
}

class _CarteraPageState extends State<CarteraPage> {
  double _saldo = 1250.50;
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
      'color': Colors.blue,
    },
    {
      'tipo': 'MasterCard',
      'numero': '**** 5678',
      'vencimiento': '08/26',
      'principal': false,
      'color': Colors.red,
    },
  ];

  void _mostrarDialogoRecarga() {
    final TextEditingController montoController = TextEditingController();
    String _metodoSeleccionado = _tarjetas.isNotEmpty ? _tarjetas[0]['numero'] : 'Efectivo';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.account_balance_wallet, color: Colors.blue),
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
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _metodoSeleccionado,
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
                    _metodoSeleccionado = value!;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                // Monto
                const Text(
                  'Monto a Recargar:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: montoController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Monto',
                    prefixText: '\$',
                    border: OutlineInputBorder(),
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
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [50, 100, 200, 500].map((monto) {
                    return ChoiceChip(
                      label: Text('\$$monto'),
                      selected: montoController.text == monto.toString(),
                      onSelected: (selected) {
                        montoController.text = monto.toString();
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
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final monto = double.tryParse(montoController.text);
                if (monto != null && monto > 0) {
                  _recargarSaldo(monto, _metodoSeleccionado);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
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
        backgroundColor: Colors.green,
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
    String _tipoTarjetaSeleccionada = 'Visa';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.credit_card, color: Colors.blue),
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
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _tipoTarjetaSeleccionada,
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
                    _tipoTarjetaSeleccionada = value!;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
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
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (numeroController.text.isNotEmpty &&
                    nombreController.text.isNotEmpty &&
                    vencimientoController.text.isNotEmpty &&
                    cvvController.text.isNotEmpty) {
                  _agregarTarjeta(
                    _tipoTarjetaSeleccionada,
                    numeroController.text,
                    vencimientoController.text,
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
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
        backgroundColor: Colors.green,
      ),
    );
  }

  Color _obtenerColorTarjeta(String tipo) {
    switch (tipo) {
      case 'Visa':
        return Colors.blue;
      case 'MasterCard':
        return Colors.red;
      case 'American Express':
        return Colors.green;
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
        backgroundColor: Colors.blue,
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
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _tarjetas.removeAt(index);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tarjeta eliminada'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
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
        appBar: AppBar(
          title: const Text(
            'Mi Cartera',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.blue[700],
          foregroundColor: Colors.white,
          elevation: 0,
          bottom: const TabBar(
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
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue[600]!,
                    Colors.blue[800]!,
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
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _mostrarDialogoRecarga,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue[700],
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
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 16),

          if (_recargas.isEmpty)
            const Card(
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
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.add_circle, color: Colors.green),
                  title: Text(
                    '+\$${recarga['monto']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(recarga['metodo']),
                      Text('${recarga['fecha']} ${recarga['hora']}'),
                    ],
                  ),
                  trailing: Chip(
                    label: Text(
                      recarga['estado'],
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    backgroundColor: Colors.green,
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
            child: ListTile(
              leading: const Icon(Icons.add_circle, color: Colors.blue),
              title: const Text(
                'Agregar Nueva Tarjeta',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Visa, MasterCard, American Express'),
              trailing: const Icon(Icons.arrow_forward_ios),
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
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 16),

          if (_tarjetas.isEmpty)
            const Card(
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
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Icon(
                    Icons.credit_card,
                    color: tarjeta['color'],
                    size: 32,
                  ),
                  title: Text(
                    '${tarjeta['tipo']} ${tarjeta['numero']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Vence: ${tarjeta['vencimiento']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (tarjeta['principal'])
                        Chip(
                          label: const Text(
                            'Principal',
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                          backgroundColor: Colors.blue,
                        )
                      else
                        IconButton(
                          icon: const Icon(Icons.star_border, color: Colors.blue),
                          onPressed: () => _establecerComoPrincipal(index),
                          tooltip: 'Establecer como principal',
                        ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
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