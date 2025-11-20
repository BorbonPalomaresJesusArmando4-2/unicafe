import 'package:flutter/material.dart';

class MiPerfilPage extends StatefulWidget {
  const MiPerfilPage({super.key});

  @override
  State<MiPerfilPage> createState() => _MiPerfilPageState();
}

class _MiPerfilPageState extends State<MiPerfilPage> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();

  Usuario _usuario = Usuario(
    nombre: 'Admin',  // Solo "Admin"
    email: 'Admin@gmail.com',
    telefono: '+52 55 1234 5678',
    direccion: 'Av. Reforma #123, Col. Centro, CDMX',
    fechaRegistro: DateTime(2024, 1, 1),
    preferencias: PreferenciasUsuario(
      notificaciones: true,
      newsletter: false,
      temaOscuro: false,
    ),
  );

  @override
  void initState() {
    super.initState();
    _cargarDatosUsuario();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    _direccionController.dispose();
    super.dispose();
  }

  void _cargarDatosUsuario() {
    _nombreController.text = _usuario.nombre;
    _emailController.text = _usuario.email;
    _telefonoController.text = _usuario.telefono;
    _direccionController.text = _usuario.direccion;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mi Perfil',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header del perfil
            _buildHeaderPerfil(),

            const SizedBox(height: 24),

            // Información personal
            _buildSeccionInformacionPersonal(),

            const SizedBox(height: 24),

            // Preferencias
            _buildSeccionPreferencias(),

            const SizedBox(height: 24),

            // Estadísticas
            _buildSeccionEstadisticas(),

            const SizedBox(height: 24),

            // Acciones de cuenta
            _buildSeccionAcciones(),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderPerfil() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar y nombre
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue[100],
              backgroundImage: const NetworkImage(
                'https://images.unsplash.com/photo-1494790108755-2616b612b786?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=100&q=80',
              ),
            ),

            const SizedBox(height: 16),

            Text(
              _usuario.nombre,  // Mostrará "Admin"
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              _usuario.email,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(height: 16),

            // Badge de miembro
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.amber!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.local_cafe, size: 16, color: Colors.blue[700]),
                  const SizedBox(width: 6),
                  Text(
                    'Miembro desde ${_formatearFecha(_usuario.fechaRegistro)}',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeccionInformacionPersonal() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.person, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Información Personal',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _buildCampoEditable(
              label: 'Nombre Completo',
              controller: _nombreController,
              icon: Icons.person_outline,
            ),

            const SizedBox(height: 16),

            _buildCampoEditable(
              label: 'Correo Electrónico',
              controller: _emailController,
              icon: Icons.email_outlined,
              tipoTeclado: TextInputType.emailAddress,
            ),

            const SizedBox(height: 16),

            _buildCampoEditable(
              label: 'Teléfono',
              controller: _telefonoController,
              icon: Icons.phone_outlined,
              tipoTeclado: TextInputType.phone,
            ),

            const SizedBox(height: 16),

            _buildCampoEditable(
              label: 'Dirección',
              controller: _direccionController,
              icon: Icons.location_on_outlined,
              maxLines: 2,
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _guardarCambios,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Guardar Cambios'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeccionPreferencias() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.settings, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Preferencias',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _buildSwitchPreferencia(
              titulo: 'Notificaciones',
              subtitulo: 'Recibir notificaciones sobre mis pedidos',
              valor: _usuario.preferencias.notificaciones,
              onChanged: (valor) {
                setState(() {
                  _usuario = _usuario.copyWith(
                    preferencias: _usuario.preferencias.copyWith(
                      notificaciones: valor,
                    ),
                  );
                });
              },
            ),

            const SizedBox(height: 16),

            _buildSwitchPreferencia(
              titulo: 'Newsletter',
              subtitulo: 'Recibir ofertas y promociones especiales',
              valor: _usuario.preferencias.newsletter,
              onChanged: (valor) {
                setState(() {
                  _usuario = _usuario.copyWith(
                    preferencias: _usuario.preferencias.copyWith(
                      newsletter: valor,
                    ),
                  );
                });
              },
            ),

            const SizedBox(height: 16),

            _buildSwitchPreferencia(
              titulo: 'Modo Oscuro',
              subtitulo: 'Activar el tema oscuro en la app',
              valor: _usuario.preferencias.temaOscuro,
              onChanged: (valor) {
                setState(() {
                  _usuario = _usuario.copyWith(
                    preferencias: _usuario.preferencias.copyWith(
                      temaOscuro: valor,
                    ),
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeccionEstadisticas() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.analytics, color: Colors.blue),  // Corregido: Icons.analytics
                SizedBox(width: 8),
                Text(
                  'Mis Estadísticas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _buildTarjetaEstadistica(
                    titulo: 'Pedidos Totales',
                    valor: '24',
                    icono: Icons.shopping_bag,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTarjetaEstadistica(
                    titulo: 'Favoritos',
                    valor: '8',
                    icono: Icons.favorite,
                    color: Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildTarjetaEstadistica(
                    titulo: 'Puntos',
                    valor: '1,250',
                    icono: Icons.loyalty,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTarjetaEstadistica(
                    titulo: 'Ahorrado',
                    valor: '\$480',
                    icono: Icons.savings,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeccionAcciones() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Acciones de Cuenta',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 16),

            _buildBotonAccion(
              icono: Icons.history,
              titulo: 'Historial de Pedidos',
              subtitulo: 'Revisa tus pedidos anteriores',
              onTap: _verHistorialPedidos,
            ),

            const SizedBox(height: 12),

            _buildBotonAccion(
              icono: Icons.favorite_border,
              titulo: 'Mis Favoritos',
              subtitulo: 'Tus productos preferidos',
              onTap: _verFavoritos,
            ),

            const SizedBox(height: 12),

            _buildBotonAccion(
              icono: Icons.card_giftcard,
              titulo: 'Mis Puntos',
              subtitulo: 'Canjea tus puntos por recompensas',
              onTap: _verPuntos,
            ),

            const SizedBox(height: 12),

            _buildBotonAccion(
              icono: Icons.help_outline,
              titulo: 'Ayuda y Soporte',
              subtitulo: 'Centro de ayuda y contacto',
              onTap: _verAyuda,
            ),

            const SizedBox(height: 20),

            _buildLineaDivisoria(),

            const SizedBox(height: 16),

            _buildBotonAccion(
              icono: Icons.exit_to_app,
              titulo: 'Cerrar Sesión',
              subtitulo: 'Salir de tu cuenta',
              onTap: _cerrarSesion,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCampoEditable({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? tipoTeclado,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: tipoTeclado,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue!),
        ),
      ),
    );
  }

  Widget _buildSwitchPreferencia({
    required String titulo,
    required String subtitulo,
    required bool valor,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitulo,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: valor,
          onChanged: onChanged,
          activeColor: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildTarjetaEstadistica({
    required String titulo,
    required String valor,
    required IconData icono,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icono, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            valor,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            titulo,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBotonAccion({
    required IconData icono,
    required String titulo,
    required String subtitulo,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: (color ?? Colors.blue).withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icono, color: color ?? Colors.blue),
      ),
      title: Text(
        titulo,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: color ?? Colors.black87,
        ),
      ),
      subtitle: Text(subtitulo),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildLineaDivisoria() {
    return Divider(color: Colors.grey[300]);
  }

  // Métodos de ayuda
  String _formatearFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }

  // Métodos de acción
  void _guardarCambios() {
    setState(() {
      _usuario = _usuario.copyWith(
        nombre: _nombreController.text,
        email: _emailController.text,
        telefono: _telefonoController.text,
        direccion: _direccionController.text,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cambios guardados exitosamente'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _verHistorialPedidos() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navegando al historial de pedidos')),
    );
  }

  void _verFavoritos() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navegando a favoritos')),
    );
  }

  void _verPuntos() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navegando a puntos y recompensas')),
    );
  }

  void _verAyuda() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navegando a ayuda y soporte')),
    );
  }

  void _cerrarSesion() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que deseas cerrar tu sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sesión cerrada exitosamente'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

// Modelos
class Usuario {
  final String nombre;
  final String email;
  final String telefono;
  final String direccion;
  final DateTime fechaRegistro;
  final PreferenciasUsuario preferencias;

  Usuario({
    required this.nombre,
    required this.email,
    required this.telefono,
    required this.direccion,
    required this.fechaRegistro,
    required this.preferencias,
  });

  Usuario copyWith({
    String? nombre,
    String? email,
    String? telefono,
    String? direccion,
    PreferenciasUsuario? preferencias,
  }) {
    return Usuario(
      nombre: nombre ?? this.nombre,
      email: email ?? this.email,
      telefono: telefono ?? this.telefono,
      direccion: direccion ?? this.direccion,
      fechaRegistro: fechaRegistro,
      preferencias: preferencias ?? this.preferencias,
    );
  }
}

class PreferenciasUsuario {
  final bool notificaciones;
  final bool newsletter;
  final bool temaOscuro;

  PreferenciasUsuario({
    required this.notificaciones,
    required this.newsletter,
    required this.temaOscuro,
  });

  PreferenciasUsuario copyWith({
    bool? notificaciones,
    bool? newsletter,
    bool? temaOscuro,
  }) {
    return PreferenciasUsuario(
      notificaciones: notificaciones ?? this.notificaciones,
      newsletter: newsletter ?? this.newsletter,
      temaOscuro: temaOscuro ?? this.temaOscuro,
    );
  }
}