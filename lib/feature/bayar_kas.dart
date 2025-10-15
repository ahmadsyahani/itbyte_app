import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BayarKasScreen extends StatefulWidget {
  const BayarKasScreen({super.key});

  @override
  State<BayarKasScreen> createState() => _BayarKasScreenState();
}

class _BayarKasScreenState extends State<BayarKasScreen> {
  // Controller untuk mengelola teks di dalam TextField
  final _nominalController = TextEditingController();
  // Variabel untuk melacak nominal mana yang sedang dipilih
  String _selectedNominal = '10.000';

  // Daftar nominal untuk tombol pilihan
  final List<String> _nominals = [
    '10.000',
    '20.000',
    '30.000',
    '40.000',
    '50.000',
    '100.000',
  ];

  @override
  void initState() {
    super.initState();
    _nominalController.text = 'Rp 10.000';
  }

  @override
  void dispose() {
    _nominalController.dispose();
    super.dispose();
  }

  // Fungsi untuk update TextField dan state saat tombol nominal ditekan
  void _updateNominal(String nominal) {
    setState(() {
      _selectedNominal = nominal;
      _nominalController.text = 'Rp $nominal';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: const Text(
            'Bayar Kas',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label "Nominal"
            const Text(
              'Nominal',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 12),

            // TextField untuk input nominal
            TextField(
              controller: _nominalController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A4EFE),
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFF4A4EFE),
                    width: 2,
                  ),
                ),
                helperText: 'Minimal Rp 10.000',
                helperStyle: const TextStyle(color: Colors.black87),
                prefixStyle: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A4EFE),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Grid tombol pilihan nominal
            Wrap(
              spacing: 12.0,
              runSpacing: 12.0,
              alignment: WrapAlignment.center,
              children: _nominals.map((nominal) {
                final isSelected = _selectedNominal == nominal;
                return _buildNominalButton(nominal, isSelected);
              }).toList(),
            ),

            // --- PERUBAHAN DI SINI ---
            // Tombol bayar sekarang ada di dalam Column
            const SizedBox(height: 48), // Beri jarak dari atasnya
            ElevatedButton(
              onPressed: () {
                // TODO: Tambahkan logika pembayaran di sini
                print('Tombol Bayar ditekan!');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A4EFE), // Warna biru
                minimumSize: const Size(
                  double.infinity,
                  56,
                ), // Tombol jadi full-width
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Bayar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            // -------------------------
          ],
        ),
      ),
      // bottomNavigationBar Dihapus dari sini
    );
  }

  // Widget helper untuk membuat satu tombol pilihan nominal
  Widget _buildNominalButton(String nominal, bool isSelected) {
    return GestureDetector(
      onTap: () => _updateNominal(nominal),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F0FE) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF4A4EFE)
                : const Color(0xFFE0E0E0),
            width: 1.5,
          ),
        ),
        child: Text(
          'Rp$nominal',
          style: TextStyle(
            color: isSelected ? const Color(0xFF4A4EFE) : Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
