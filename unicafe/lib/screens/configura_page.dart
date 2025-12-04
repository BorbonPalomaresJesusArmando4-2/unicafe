import 'package:flutter/material.dart';

// DEFINICIÓN DE COLORES (Misma paleta global)
const Color kColorPrimary = Color(0xFF3E2723); // Café oscuro
const Color kColorSecondary = Color(0xFF5D4037); // Café medio
const Color kColorAccent = Color(0xFFFFAB00); // Ámbar/Dorado
const Color kColorBackground = Color(0xFFFAFAFA); // Blanco hueso
const Color kColorText = Color(0xFF3E2723); // Texto oscuro

class ConfiguraPage extends StatefulWidget {
  const ConfiguraPage({super.key});

  @override
  State<ConfiguraPage> createState() => _ConfiguraPageState();
}

class _ConfiguraPageState extends State<ConfiguraPage> {
  bool _notificacionesActivas = true;
  bool _modoOscuro = false;
  bool _recordarSesion = true;
  bool _marketingEmails = false;
  String _idiomaSeleccionado = 'Español';
  String _temaSeleccionado = 'Automático';

  final List<String> _idiomas = ['Español', 'English', 'Français', 'Deutsch'];
  final List<String> _temas = ['Automático', 'Claro', 'Oscuro'];

  void _mostrarDialogoEliminarCuenta() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning, color: Colors.orange),
              SizedBox(width: 8),
              Text('Eliminar Cuenta'),
            ],
          ),
          content: const Text(
            '¿Estás seguro de que quieres eliminar tu cuenta? '
                'Esta acción no se puede deshacer y se perderán todos tus datos.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _mostrarConfirmacionEliminacion();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[800], // Rojo más oscuro
                foregroundColor: Colors.white,
              ),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarConfirmacionEliminacion() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cuenta eliminada exitosamente'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _mostrarDialogoCerrarSesion() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar Sesión'),
          content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _cerrarSesion();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kColorPrimary, // Botón Café
                foregroundColor: Colors.white,
              ),
              child: const Text('Cerrar Sesión'),
            ),
          ],
        );
      },
    );
  }

  void _cerrarSesion() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sesión cerrada exitosamente'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorBackground, // Fondo hueso
      appBar: AppBar(
        title: const Text(
          'Configuración',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: kColorPrimary, // AppBar Café
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de Cuenta
            _buildSeccion(
              titulo: 'Cuenta',
              icono: Icons.person,
              color: kColorPrimary,
              children: [
                _buildItemConfiguracion(
                  icono: Icons.edit,
                  titulo: 'Editar Perfil',
                  subtitulo: 'Actualiza tu información personal',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Redirigiendo a edición de perfil')),
                    );
                  },
                ),
                _buildItemConfiguracion(
                  icono: Icons.security,
                  titulo: 'Privacidad y Seguridad',
                  subtitulo: 'Gestiona tu privacidad',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Abriendo configuración de privacidad')),
                    );
                  },
                ),
                _buildItemConfiguracion(
                  icono: Icons.credit_card,
                  titulo: 'Métodos de Pago',
                  subtitulo: 'Gestiona tus tarjetas y pagos',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Abriendo métodos de pago')),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Sección de Preferencias
            _buildSeccion(
              titulo: 'Preferencias',
              icono: Icons.settings,
              color: kColorPrimary,
              children: [
                _buildItemConfiguracion(
                  icono: Icons.notifications,
                  titulo: 'Notificaciones',
                  subtitulo: 'Gestiona tus notificaciones',
                  trailing: Switch(
                    value: _notificacionesActivas,
                    onChanged: (value) {
                      setState(() {
                        _notificacionesActivas = value;
                      });
                    },
                    activeColor: kColorAccent, // Switch Dorado
                    activeTrackColor: kColorAccent.withOpacity(0.4),
                  ),
                ),
                _buildItemConfiguracion(
                  icono: Icons.dark_mode,
                  titulo: 'Modo Oscuro',
                  subtitulo: 'Activar tema oscuro',
                  trailing: Switch(
                    value: _modoOscuro,
                    onChanged: (value) {
                      setState(() {
                        _modoOscuro = value;
                      });
                    },
                    activeColor: kColorAccent,
                    activeTrackColor: kColorAccent.withOpacity(0.4),
                  ),
                ),
                _buildItemConfiguracion(
                  icono: Icons.language,
                  titulo: 'Idioma',
                  subtitulo: _idiomaSeleccionado,
                  onTap: () {
                    _mostrarSelectorIdioma();
                  },
                ),
                _buildItemConfiguracion(
                  icono: Icons.palette,
                  titulo: 'Tema',
                  subtitulo: _temaSeleccionado,
                  onTap: () {
                    _mostrarSelectorTema();
                  },
                ),
                _buildItemConfiguracion(
                  icono: Icons.save,
                  titulo: 'Recordar Sesión',
                  subtitulo: 'Mantener sesión iniciada',
                  trailing: Switch(
                    value: _recordarSesion,
                    onChanged: (value) {
                      setState(() {
                        _recordarSesion = value;
                      });
                    },
                    activeColor: kColorAccent,
                    activeTrackColor: kColorAccent.withOpacity(0.4),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Sección de Comunicaciones
            _buildSeccion(
              titulo: 'Comunicaciones',
              icono: Icons.email,
              color: kColorPrimary,
              children: [
                _buildItemConfiguracion(
                  icono: Icons.mark_email_read,
                  titulo: 'Emails de Marketing',
                  subtitulo: 'Recibir promociones y ofertas',
                  trailing: Switch(
                    value: _marketingEmails,
                    onChanged: (value) {
                      setState(() {
                        _marketingEmails = value;
                      });
                    },
                    activeColor: kColorAccent,
                    activeTrackColor: kColorAccent.withOpacity(0.4),
                  ),
                ),
                _buildItemConfiguracion(
                  icono: Icons.local_offer,
                  titulo: 'Ofertas Especiales',
                  subtitulo: 'Notificaciones de descuentos',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Configurando notificaciones de ofertas')),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Sección de Soporte
            _buildSeccion(
              titulo: 'Soporte',
              icono: Icons.help,
              color: kColorPrimary,
              children: [
                _buildItemConfiguracion(
                  icono: Icons.help_center,
                  titulo: 'Centro de Ayuda',
                  subtitulo: 'Preguntas frecuentes y soporte',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Abriendo centro de ayuda')),
                    );
                  },
                ),
                _buildItemConfiguracion(
                  icono: Icons.assignment,
                  titulo: 'Términos y Condiciones',
                  subtitulo: 'Lee nuestros términos de servicio',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Mostrando términos y condiciones')),
                    );
                  },
                ),
                _buildItemConfiguracion(
                  icono: Icons.privacy_tip,
                  titulo: 'Política de Privacidad',
                  subtitulo: 'Cómo manejamos tus datos',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Mostrando política de privacidad')),
                    );
                  },
                ),
                _buildItemConfiguracion(
                  icono: Icons.info,
                  titulo: 'Acerca de Unicafé',
                  subtitulo: 'Versión 1.0.0',
                  onTap: () {
                    _mostrarDialogoAcercaDe();
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Sección de Cuenta - Acciones Peligrosas
            _buildSeccion(
              titulo: 'Acciones de Cuenta',
              icono: Icons.warning,
              color: Colors.orange[800]!, // Naranja quemado para combinar mejor
              children: [
                _buildItemConfiguracion(
                  icono: Icons.exit_to_app,
                  titulo: 'Cerrar Sesión',
                  subtitulo: 'Salir de tu cuenta',
                  color: kColorPrimary, // Icono café
                  onTap: _mostrarDialogoCerrarSesion,
                ),
                _buildItemConfiguracion(
                  icono: Icons.delete_forever,
                  titulo: 'Eliminar Cuenta',
                  subtitulo: 'Eliminar permanentemente tu cuenta',
                  color: Colors.red[800]!, // Rojo oscuro
                  onTap: _mostrarDialogoEliminarCuenta,
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSeccion({
    required String titulo,
    required IconData icono,
    required List<Widget> children,
    Color color = kColorPrimary,
  }) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icono, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  titulo,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildItemConfiguracion({
    required IconData icono,
    required String titulo,
    required String subtitulo,
    Widget? trailing,
    VoidCallback? onTap,
    Color color = kColorSecondary, // Color por defecto para los iconos de items
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icono, color: color),
          title: Text(
            titulo,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: kColorText,
            ),
          ),
          subtitle: Text(
            subtitulo,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        ),
        Divider(height: 1, color: Colors.grey[200]),
      ],
    );
  }

  void _mostrarSelectorIdioma() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccionar Idioma'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _idiomas.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_idiomas[index]),
                  trailing: _idiomaSeleccionado == _idiomas[index]
                      ? const Icon(Icons.check, color: kColorPrimary) // Check café
                      : null,
                  onTap: () {
                    setState(() {
                      _idiomaSeleccionado = _idiomas[index];
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Idioma cambiado a ${_idiomas[index]}')),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _mostrarSelectorTema() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccionar Tema'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _temas.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_temas[index]),
                  trailing: _temaSeleccionado == _temas[index]
                      ? const Icon(Icons.check, color: kColorPrimary)
                      : null,
                  onTap: () {
                    setState(() {
                      _temaSeleccionado = _temas[index];
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Tema cambiado a ${_temas[index]}')),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _mostrarDialogoAcercaDe() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.coffee, color: kColorPrimary), // Icono café
              SizedBox(width: 8),
              Text('Acerca de Unicafé'),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Unicafé v1.0.0',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Tu cafetería de confianza'),
              SizedBox(height: 8),
              Text(
                'Desarrollado con ❤️ para los amantes del café.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar', style: TextStyle(color: kColorPrimary)),
            ),
          ],
        );
      },
    );
  }
}