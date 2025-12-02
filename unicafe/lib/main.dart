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
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
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
        '/registro': (context) => RegistroUsuario(),
      },
    );
  }
}
