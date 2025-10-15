import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:itbyte_app/main.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // Variabel untuk menyimpan status UI
  bool _isPasswordVisible = false;
  bool _isAgreed = false; // <-- Variabel untuk status checkbox

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
              top: -20,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/line_3.png', // <-- GANTI DENGAN NAMA FILE GAMBAR ATASMU
                fit: BoxFit.cover, // Memastikan gambar menutupi lebar layar
              ),
            ),
            Positioned(
              bottom: -50, // Geser ke bawah sedikit
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/line_1.png', // <-- GANTI DENGAN NAMA FILE GAMBAR BAWAHMU
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 170),

                  // --- LOGO ---
                  // Ganti dengan logo gambarmu
                  Image.asset(
                    'assets/Logo.png', // <-- GANTI DENGAN PATH LOGO KAMU
                    height: 50,
                  ),
                  const SizedBox(height: 60),

                  // --- Judul "Sign Up" ---
                  const Text(
                    'Sign Up',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // --- Text Field NRP (Hanya Angka) ---
                  TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      hintText: 'NRP',
                      filled: true,
                      fillColor: textFieldColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- Text Field Email ---
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      filled: true,
                      fillColor: textFieldColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- Text Field Password ---
                  TextField(
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      filled: true,
                      fillColor: textFieldColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- Teks Persetujuan dengan Checkbox ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: _isAgreed,
                        activeColor: primaryColor,
                        onChanged: (bool? newValue) {
                          setState(() {
                            _isAgreed = newValue!;
                          });
                        },
                      ),
                      const Expanded(
                        child: Text(
                          'Saya menyetujui Peraturan penggunaan Aplikasi ITByte Mobile',
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // --- Tombol Sign Up ---
                  ElevatedButton(
                    // Logika: jika _isAgreed true, jalankan fungsi. Jika false, set ke null (tombol nonaktif)
                    onPressed: _isAgreed
                        ? () {
                            // TODO: Tambahkan logika sign up di sini
                            print('Tombol Sign Up Ditekan!');
                          }
                        : null, // <-- Tombol akan otomatis nonaktif jika nilainya null
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      disabledBackgroundColor:
                          Colors.grey, // Warna tombol saat nonaktif
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- Link ke Sign In ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Sudah punya akun? "),
                      GestureDetector(
                        onTap: () {
                          // Kembali ke halaman sebelumnya (Login)
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 310),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
