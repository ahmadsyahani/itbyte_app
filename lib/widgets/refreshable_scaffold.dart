import 'package:flutter/material.dart';

class RefreshableScaffold extends StatelessWidget {
  /// Widget yang akan ditampilkan di dalam body.
  final Widget child;

  /// Fungsi yang akan dijalankan saat refresh ditarik.
  /// Harus berupa Future untuk menandakan kapan proses refresh selesai.
  final Future<void> Function() onRefresh;

  /// Properti opsional untuk AppBar.
  final AppBar? appBar;

  /// Properti opsional untuk warna background.
  final Color? backgroundColor;

  const RefreshableScaffold({
    super.key,
    required this.child,
    required this.onRefresh,
    this.appBar,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: backgroundColor,
      body: RefreshIndicator(
        onRefresh: onRefresh,
        // Penting: RefreshIndicator hanya bekerja pada child yang bisa di-scroll.
        // Kita bungkus child-nya dengan LayoutBuilder dan SingleChildScrollView
        // agar halaman yang kontennya pendek pun tetap bisa ditarik.
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: child,
              ),
            );
          },
        ),
      ),
    );
  }
}
