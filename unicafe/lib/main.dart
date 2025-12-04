import 'package:flutter/material.dart';
import 'package:unicafe/screens/cartera_page.dart';
import 'package:unicafe/screens/configura_page.dart';
import 'package:unicafe/screens/contactanos_page.dart';
import 'package:unicafe/screens/historial_pedidos_page.dart';
import 'package:unicafe/screens/home_page.dart';
import 'package:unicafe/screens/inicio_page.dart';
import 'package:unicafe/screens/menucompleto_page.dart';
import 'package:unicafe/screens/mi_perfil_page.dart';
import 'package:unicafe/screens/pedidos_page.dart';
import 'package:unicafe/screens/registro_usuario.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Unicafé",
      // This property belongs directly to MaterialApp
      debugShowCheckedModeBanner: false,

      theme: ThemeData( // ThemeData starts here
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed( // fromSeed starts here
          seedColor: const Color(0xFF3E2723),
          primary: const Color(0xFF3E2723),
          secondary: const Color(0xFFD7CCC8),
          tertiary: const Color(0xFFFFAB00),
          surface: const Color(0xFFFAFAFA),
          brightness: Brightness.light,
        ),
      ),

      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/inicio': (context) => const InicioPage(),
        '/configuracion': (context) => const ConfiguraPage(),
        '/contactanos': (context) => const ContactanosPage(),
        '/cartera': (context) => const CarteraPage(),
        '/historial': (context) => const HistorialPedidosPage(),
        '/menu': (context) => const MenuCompletoPage(),
        '/perfil': (context) => const MiPerfilPage(),
        '/pedidos': (context) => const PedidosPage(),
        // It's good practice to add 'const' here if RegistroUsuario's constructor is const
        '/registro': (context) => const RegistroUsuario(),
      },
    );
  }
}

