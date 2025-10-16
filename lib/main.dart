import 'package:flutter/material.dart';
import 'package:itbyte_app/auth/login_page.dart';
import 'package:itbyte_app/auth/register_page.dart';
import 'package:flutter/services.dart';
import 'package:itbyte_app/feature/bayar_kas.dart';
import 'package:itbyte_app/screens/cek_kas.dart';
import 'package:itbyte_app/screens/home_screen.dart';
import 'package:itbyte_app/screens/jadwal_kuliah.dart';
import 'package:itbyte_app/screens/tugas.dart';
import 'package:itbyte_app/main_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:itbyte_app/splash_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  // Pastikan semua widget sudah siap sebelum menjalankan kode fullscreen
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://axmnahlweqtgviyfqrqt.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF4bW5haGx3ZXF0Z3ZpeWZxcnF0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjAxNzQ2NzksImV4cCI6MjA3NTc1MDY3OX0.LzmuWHFaHKgJEEvTRZ02_KbrDtQV5WOuj8c8jH0sMO4',
  );

  // Perintah untuk masuk ke mode fullscreen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  await initializeDateFormatting('id_ID', null);

  runApp(const MyApp());
}

// Definisikan warna utama agar konsisten
const Color primaryColor = Color(0xFF4361EE);
const Color backgroundColor = Color(0xFFF8F8F8);
const Color textFieldColor = Color(0xFFEFEFEF);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Informatics Engineering Auth',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Atur warna background default untuk semua scaffold/halaman
        scaffoldBackgroundColor: backgroundColor,
        fontFamily:
            'Plus Jakarta Sans', // Kamu bisa ganti font sesuai selera di pubspec.yaml
      ),
      // Atur halaman awal dan rute navigasi
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/main': (context) => const MainScreen(),
        '/signup': (context) => const SignupPage(),
        '/homescreen': (context) => const HomeScreen(),
        '/bayarkas': (context) => const BayarKasScreen(),
        '/cekkas': (context) => const CekKasScreen(),
        '/tugas': (context) => const TugasScreen(),
        '/jadwalkuliah': (context) => const JadwalKuliahScreen(),
      },
    );
  }
}
