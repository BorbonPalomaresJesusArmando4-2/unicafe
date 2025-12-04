import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// DEFINICIÓN DE COLORES (Misma paleta global)
const Color kColorPrimary = Color(0xFF3E2723); // Café oscuro
const Color kColorSecondary = Color(0xFF5D4037); // Café medio
const Color kColorAccent = Color(0xFFFFAB00); // Ámbar/Dorado
const Color kColorBackground = Color(0xFFFAFAFA); // Blanco hueso
const Color kColorText = Color(0xFF3E2723); // Texto oscuro

class ContactanosPage extends StatefulWidget {
  const ContactanosPage({super.key});

  @override
  State<ContactanosPage> createState() => _ContactanosPageState();
}

class _ContactanosPageState extends State<ContactanosPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _asuntoController = TextEditingController();
  final TextEditingController _mensajeController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _asuntoController.dispose();
    _mensajeController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> _enviarFormulario() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulación de envío
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      _mostrarDialogoExito();
    }
  }

  void _mostrarDialogoExito() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green[700]),
              const SizedBox(width: 8),
              const Text('Mensaje Enviado'),
            ],
          ),
          content: const Text('Tu mensaje ha sido enviado exitosamente. Te contactaremos pronto.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _limpiarFormulario();
              },
              child: const Text('Aceptar', style: TextStyle(color: kColorPrimary)),
            ),
          ],
        );
      },
    );
  }

  void _limpiarFormulario() {
    _nombreController.clear();
    _emailController.clear();
    _asuntoController.clear();
    _mensajeController.clear();
  }

  Future<void> _hacerLlamada(String telefono) async {
    final Uri url = Uri.parse('tel:$telefono');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      _mostrarError('No se pudo realizar la llamada');
    }
  }

  Future<void> _enviarWhatsApp(String mensaje) async {
    // Nota: El esquema universal es mejor usarlo sin wa.me para compatibilidad en algunos dispositivos,
    // pero wa.me suele funcionar bien.
    final Uri url = Uri.parse('https://wa.me/5215512345678?text=${Uri.encodeComponent(mensaje)}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      _mostrarError('No se pudo abrir WhatsApp');
    }
  }

  Future<void> _abrirUbicacion() async {
    final Uri url = Uri.parse('https://maps.google.com/?q=Unicafé+Ciudad+de+México');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      _mostrarError('No se pudo abrir el mapa');
    }
  }

  Future<void> _enviarEmail() async {
    final Uri url = Uri.parse(
        'mailto:contacto@unicafe.com?subject=Consulta%20Unicafé&body=Hola,%20me%20gustaría%20obtener%20más%20información...'
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      _mostrarError('No se pudo abrir la aplicación de email');
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red[700],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorBackground, // Fondo hueso
      appBar: AppBar(
        title: const Text(
          'Contáctanos',
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
            _buildInfoContacto(),
            const SizedBox(height: 24),
            _buildFormularioContacto(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoContacto() {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Información de Contacto',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kColorPrimary, // CAMBIO: Texto café
              ),
            ),
            const SizedBox(height: 16),

            _buildItemContacto(
              icon: Icons.phone,
              title: 'Teléfono',
              subtitle: '+52 (55) 1234 5678',
              color: Colors.green[700]!, // Verde un poco más oscuro
              onTap: () => _hacerLlamada('+525512345678'),
            ),

            const SizedBox(height: 12),

            _buildItemContacto(
              icon: Icons.chat,
              title: 'WhatsApp',
              subtitle: 'Envíanos un mensaje',
              color: Colors.green[600]!,
              onTap: () => _enviarWhatsApp('Hola, me gustaría obtener información sobre Unicafé'),
            ),

            const SizedBox(height: 12),

            _buildItemContacto(
              icon: Icons.email,
              title: 'Email',
              subtitle: 'contacto@unicafe.com',
              color: kColorPrimary, // CAMBIO: Email en color corporativo (Café)
              onTap: _enviarEmail,
            ),

            const SizedBox(height: 12),

            _buildItemContacto(
              icon: Icons.location_on,
              title: 'Ubicación',
              subtitle: 'Av. Principal #123, Ciudad de México',
              color: Colors.red[800]!, // Rojo más elegante
              onTap: _abrirUbicacion,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemContacto({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      splashColor: color.withOpacity(0.2),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08), // Fondo muy sutil del color del icono
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: kColorText,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormularioContacto() {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Envíanos un Mensaje',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kColorPrimary, // CAMBIO: Texto café
                ),
              ),
              const SizedBox(height: 20),

              _buildTextField(
                controller: _nombreController,
                label: 'Nombre Completo',
                icon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Por favor ingresa tu nombre';
                  return null;
                },
              ),

              const SizedBox(height: 16),

              _buildTextField(
                controller: _emailController,
                label: 'Correo Electrónico',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Por favor ingresa tu correo';
                  if (!_isValidEmail(value)) return 'Ingresa un correo válido';
                  return null;
                },
              ),

              const SizedBox(height: 16),

              _buildTextField(
                controller: _asuntoController,
                label: 'Asunto',
                icon: Icons.subject,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Por favor ingresa el asunto';
                  return null;
                },
              ),

              const SizedBox(height: 16),

              _buildTextField(
                controller: _mensajeController,
                label: 'Mensaje',
                icon: Icons.message, // Icono opcional para mensaje
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Por favor ingresa tu mensaje';
                  return null;
                },
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _enviarFormulario,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kColorAccent, // CAMBIO: Botón dorado
                    foregroundColor: kColorPrimary, // Texto café para contraste
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(kColorPrimary),
                    ),
                  )
                      : const Text(
                    'Enviar Mensaje',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método auxiliar para estilizar los inputs uniformemente con el tema café
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      cursorColor: kColorPrimary, // Cursor color café
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[700]),
        prefixIcon: Icon(icon, color: kColorPrimary), // Icono café
        alignLabelWithHint: maxLines > 1,
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[400]!),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: kColorPrimary, width: 2), // Borde café al seleccionar
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: validator,
    );
  }
}