import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:itbyte_app/main.dart'; // Sesuaikan path jika perlu
import 'package:supabase_flutter/supabase_flutter.dart';

// Definisikan client Supabase agar mudah diakses
final supabase = Supabase.instance.client;

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // Controller untuk setiap input field
  final _fullNameController = TextEditingController();
  final _nrpController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Variabel untuk menyimpan status UI
  bool _isPasswordVisible = false;
  bool _isAgreed = false;
  bool _isLoading = false;

  // --- FUNGSI UNTUK PROSES SIGN UP ---
  Future<void> _signUp() async {
    // Validasi sederhana
    if (_fullNameController.text.isEmpty ||
        _nrpController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua field wajib diisi!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authResponse = await supabase.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Setelah user terdaftar, langsung buat profilnya di tabel 'profiles'
      await supabase.from('profiles').insert({
        'id': authResponse.user!.id,
        'full_name': _fullNameController.text.trim(),
        'nrp': _nrpController.text.trim(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Pendaftaran berhasil! Silakan cek email Anda untuk verifikasi.',
            ),
            duration: Duration(seconds: 5), // Tampilkan lebih lama
          ),
        );
        Navigator.of(context).pop(); // Kembali ke halaman login
      }
    } on AuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message), backgroundColor: Colors.red),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan tidak terduga.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    // Selalu dispose controller untuk mencegah memory leak
    _fullNameController.dispose();
    _nrpController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
              child: Image.asset('assets/line_3.png', fit: BoxFit.cover),
            ),
            Positioned(
              bottom: -50,
              left: 0,
              right: 0,
              child: Image.asset('assets/line_1.png', fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 180),
                  Image.asset('assets/Logo.png', height: 50),
                  const SizedBox(height: 40),
                  const Text(
                    'Sign Up',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // --- Text Field Nama Lengkap ---
                  TextField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      hintText: 'Nama Lengkap',
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

                  // --- Text Field NRP (Hanya Angka) ---
                  TextField(
                    controller: _nrpController,
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
                    controller: _emailController,
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
                    controller: _passwordController,
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
                    onPressed: _isAgreed && !_isLoading ? _signUp : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      disabledBackgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
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
                  const SizedBox(height: 260),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
