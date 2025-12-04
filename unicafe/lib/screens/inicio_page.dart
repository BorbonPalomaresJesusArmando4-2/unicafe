import 'package:flutter/material.dart';
import 'package:unicafe/screens/registro_usuario.dart';
// Asegúrate de importar tu HomePage si vas a navegar a él
// import 'package:unicafe/screens/home_page.dart';

// DEFINICIÓN DE COLORES (Misma paleta global)
const Color kColorPrimary = Color(0xFF3E2723); // Café oscuro
const Color kColorSecondary = Color(0xFF5D4037); // Café medio
const Color kColorAccent = Color(0xFFFFAB00); // Ámbar/Dorado
const Color kColorBackground = Color(0xFFFAFAFA); // Blanco hueso
const Color kColorText = Color(0xFF3E2723); // Texto oscuro

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    );
    return emailRegex.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.length >= 6; // Ajustado a 6 para pruebas rápidas, o mantenlo en 8
  }

  Future<void> _iniciarSesion() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simular proceso de autenticación
      await Future.delayed(const Duration(seconds: 2));

      // Credenciales de prueba: usuario@ejemplo.com / 12345678
      if (_emailController.text == "usuario@ejemplo.com" &&
          _passwordController.text == "12345678") {

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Bienvenido ${_emailController.text}'),
              backgroundColor: Colors.green[700],
              duration: const Duration(seconds: 3),
            ),
          );

          // Navegar a la pantalla principal
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
        }

      } else {
        _mostrarErrorAutenticacion();
      }
    } catch (error) {
      _mostrarErrorConexion();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _mostrarErrorAutenticacion() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error de Autenticación', style: TextStyle(color: kColorPrimary)),
          content: const Text('El correo electrónico o la contraseña son incorrectos.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _passwordController.clear();
                setState(() {});
              },
              child: const Text('Intentar de nuevo', style: TextStyle(color: kColorPrimary)),
            ),
          ],
        );
      },
    );
  }

  void _mostrarErrorConexion() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Error de conexión. Verifica tu internet.'),
        backgroundColor: Colors.red[800],
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorBackground, // Fondo hueso
      appBar: AppBar(
        title: const Text('Inicio', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: kColorPrimary, // AppBar Café
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo o ícono de la app
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: const Icon(
                    Icons.coffee,
                    size: 80,
                    color: kColorPrimary, // Icono café
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  'Unicafé',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: kColorPrimary, // Título café
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Tu café favorito, donde estés',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),

                const SizedBox(height: 40),

                // Campo de email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  cursorColor: kColorPrimary,
                  decoration: InputDecoration(
                    labelText: 'Correo electrónico',
                    hintText: 'ejemplo@correo.com',
                    prefixIcon: const Icon(Icons.email, color: kColorPrimary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: kColorPrimary, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    filled: true,
                    fillColor: Colors.white,
                    labelStyle: TextStyle(color: Colors.grey[700]),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Ingresa tu correo';
                    if (!_isValidEmail(value)) return 'Correo inválido';
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Campo de contraseña
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  cursorColor: kColorPrimary,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    hintText: '********',
                    prefixIcon: const Icon(Icons.lock, color: kColorPrimary),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: kColorPrimary, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    filled: true,
                    fillColor: Colors.white,
                    labelStyle: TextStyle(color: Colors.grey[700]),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Ingresa tu contraseña';
                    if (!_isValidPassword(value)) return 'Mínimo 8 caracteres';
                    return null;
                  },
                  onFieldSubmitted: (_) => _iniciarSesion(),
                ),

                const SizedBox(height: 12),

                // Recordarme y olvidé contraseña
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          activeColor: kColorPrimary, // Checkbox café
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value!;
                            });
                          },
                        ),
                        const Text('Recordarme'),
                      ],
                    ),
                    TextButton(
                      onPressed: _isLoading ? null : () => _mostrarDialogoRecuperacion(context),
                      child: Text(
                        '¿Olvidaste tu contraseña?',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Botón de iniciar sesión
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _iniciarSesion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kColorAccent, // Botón Dorado
                      foregroundColor: kColorPrimary, // Texto Café
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 2,
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
                      'INICIAR SESIÓN',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Separador
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey[400])),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('O', style: TextStyle(color: Colors.grey[500])),
                    ),
                    Expanded(child: Divider(color: Colors.grey[400])),
                  ],
                ),

                const SizedBox(height: 24),

                // Enlace de registro
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("¿No tienes cuenta? "),
                    InkWell(
                      onTap: _isLoading ? null : () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegistroUsuario())
                        );
                      },
                      borderRadius: BorderRadius.circular(4),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                        child: Text(
                          'Regístrate',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kColorPrimary, // Enlace café
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Credenciales de prueba
                const SizedBox(height: 32),
                Card(
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.grey[300]!)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Text(
                          'Credenciales de prueba:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'usuario@ejemplo.com / 12345678',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Diálogo para recuperación de contraseña
  void _mostrarDialogoRecuperacion(BuildContext context) {
    final emailRecuperacionController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Recuperar Contraseña', style: TextStyle(color: kColorPrimary)),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Ingresa tu correo para restablecer tu contraseña:'),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailRecuperacionController,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: kColorPrimary,
                  decoration: const InputDecoration(
                    labelText: 'Correo electrónico',
                    prefixIcon: Icon(Icons.email, color: kColorPrimary),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kColorPrimary),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Ingresa tu correo';
                    if (!_isValidEmail(value)) return 'Correo inválido';
                    return null;
                  },
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
                if (formKey.currentState!.validate()) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Enlace enviado a ${emailRecuperacionController.text}'),
                      backgroundColor: Colors.green[800],
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kColorPrimary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Enviar'),
            ),
          ],
        );
      },
    );
  }
}