import 'package:flutter/material.dart';

// DEFINICIÓN DE COLORES (Misma paleta global)
const Color kColorPrimary = Color(0xFF3E2723); // Café oscuro
const Color kColorSecondary = Color(0xFF5D4037); // Café medio
const Color kColorAccent = Color(0xFFFFAB00); // Ámbar/Dorado
const Color kColorBackground = Color(0xFFFAFAFA); // Blanco hueso
const Color kColorText = Color(0xFF3E2723); // Texto oscuro

class RegistroUsuario extends StatefulWidget {
  const RegistroUsuario({super.key});

  @override
  State<RegistroUsuario> createState() => _RegistroUsuarioState();
}

class _RegistroUsuarioState extends State<RegistroUsuario> {
  final _formKey = GlobalKey<FormState>();

  // Controladores
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Variables de estado
  bool _acceptTerms = false;
  bool _obscurePassword = true; // Para ocultar/mostrar contraseña

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorBackground, // Fondo hueso
      appBar: AppBar(
        title: const Text(
          'Registro de Usuario',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: kColorPrimary, // AppBar Café
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Título o Imagen
                      const Text(
                        'Crear Cuenta',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: kColorPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Imagen de registro (Mantenemos tu asset)
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.asset(
                          'assets/images/12345.jpg',
                          fit: BoxFit.contain,
                          // Si no tienes la imagen aún, mostramos un icono por defecto
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.person_add, size: 80, color: kColorSecondary);
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Campo Nombre
                      _buildTextField(
                        controller: _nameController,
                        label: 'Nombre',
                        hint: 'Ingresa tu nombre completo',
                        icon: Icons.person,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Por favor, ingresa tu nombre';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Campo Correo
                      _buildTextField(
                        controller: _emailController,
                        label: 'Correo electrónico',
                        hint: 'ejemplo@correo.com',
                        icon: Icons.email,
                        inputType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Ingresa tu correo';
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Correo inválido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Campo Teléfono
                      _buildTextField(
                        controller: _phoneController,
                        label: 'Teléfono',
                        hint: '10 dígitos',
                        icon: Icons.phone,
                        inputType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Ingresa tu teléfono';
                          if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                            return 'Debe tener 10 dígitos';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Campo Contraseña (con toggle de visibilidad)
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        cursorColor: kColorPrimary,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          hintText: 'Mínimo 8 caracteres',
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
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: kColorPrimary, width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Ingresa tu contraseña';
                          if (value.length < 8) return 'Mínimo 8 caracteres';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Checkbox términos
                      Row(
                        children: [
                          Checkbox(
                            value: _acceptTerms,
                            activeColor: kColorPrimary, // Checkbox Café
                            onChanged: (bool? value) {
                              setState(() {
                                _acceptTerms = value ?? false;
                              });
                            },
                          ),
                          const Expanded(
                            child: Text(
                              'Acepto los términos y condiciones',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Botón de enviar
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (!_acceptTerms) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Debes aceptar los términos'),
                                    backgroundColor: Colors.red[800],
                                  ),
                                );
                                return;
                              }

                              // Éxito
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('¡Registro exitoso!'),
                                  backgroundColor: Colors.green[800],
                                ),
                              );

                              // Logs para debug
                              print('Nombre: ${_nameController.text}');
                              print('Email: ${_emailController.text}');
                              // Navigator.pop(context); // Opcional: regresar al login
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kColorAccent, // Botón Dorado
                            foregroundColor: kColorPrimary, // Texto Café
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: const Text(
                            'REGISTRARSE',
                            style: TextStyle(
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
            ),
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para no repetir código de estilo en los Inputs
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: kColorPrimary), // Icono café
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kColorPrimary, width: 2), // Borde café
        ),
      ),
      cursorColor: kColorPrimary,
      keyboardType: inputType,
      validator: validator,
    );
  }
}