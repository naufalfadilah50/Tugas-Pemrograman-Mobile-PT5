import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase menggunakan kredensial Web Anda
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCCNPOWAOLryxnNcy_qsCQZrObHSEbT02g",
      authDomain: "pemrograman-mobile-b82dd.firebaseapp.com",
      projectId: "pemrograman-mobile-b82dd",
      storageBucket: "pemrograman-mobile-b82dd.firebasestorage.app",
      messagingSenderId: "991828310670",
      appId: "1:991828310670:web:929a73270503e7221e67df",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pencatatan Stok Barang',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const StokBarangPage(),
    );
  }
}

class StokBarangPage extends StatefulWidget {
  const StokBarangPage({super.key});

  @override
  State<StokBarangPage> createState() => _StokBarangPageState();
}

class _StokBarangPageState extends State<StokBarangPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaBarangController = TextEditingController();
  final _tanggalMasukController = TextEditingController();
  final _tanggalKeluarController = TextEditingController();
  final _kodeBarangController = TextEditingController();
  final _jumlahStokController = TextEditingController();

  bool _isLoading = false;

  Future<void> _simpanData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        int kodeBarang = int.parse(_kodeBarangController.text);
        int jumlahStok = int.parse(_jumlahStokController.text);

        // Menyimpan data ke koleksi 'stok_barang' di Firebase Firestore
        await FirebaseFirestore.instance.collection('stok_barang').add({
          'nama_barang': _namaBarangController.text,
          'tanggal_masuk': _tanggalMasukController.text,
          'tanggal_keluar': _tanggalKeluarController.text,
          'kode_barang': kodeBarang, // Disimpan sebagai tipe number/integer
          'jumlah_stok': jumlahStok, // Disimpan sebagai tipe number/integer
          'waktu': FieldValue.serverTimestamp(),
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data barang berhasil disimpan ke Firebase!'),
              backgroundColor: Colors.green,
            ),
          );
        }

        _formKey.currentState!.reset();
        _namaBarangController.clear();
        _tanggalMasukController.clear();
        _tanggalKeluarController.clear();
        _kodeBarangController.clear();
        _jumlahStokController.clear();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _namaBarangController.dispose();
    _tanggalMasukController.dispose();
    _tanggalKeluarController.dispose();
    _kodeBarangController.dispose();
    _jumlahStokController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pencatatan Stok Barang'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // 1. Nama Barang (Diawali huruf M)
              TextFormField(
                controller: _namaBarangController,
                decoration: const InputDecoration(
                  labelText: 'Nama Barang (Diawali huruf M, cth: Meja)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama barang wajib diisi';
                  }
                  if (!value.trim().toLowerCase().startsWith('m')) {
                    return 'Nama barang harus diawali dengan inisial nama depan (Huruf M)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // 2. Tanggal Masuk
              TextFormField(
                controller: _tanggalMasukController,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Masuk (Contoh: 2026-06-09)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Tanggal masuk wajib diisi'
                    : null,
              ),
              const SizedBox(height: 12),

              // 3. Tanggal Keluar
              TextFormField(
                controller: _tanggalKeluarController,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Keluar (Contoh: 2026-06-10)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Tanggal keluar wajib diisi'
                    : null,
              ),
              const SizedBox(height: 12),

              // 4. Kode Barang (Min 6 digit, akhiran 00)
              TextFormField(
                controller: _kodeBarangController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Kode Barang (Min 6 digit, akhiran 00)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kode barang wajib diisi';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Kode barang harus berupa angka';
                  }
                  if (value.length < 6) {
                    return 'Kode barang minimal terdiri dari 6 angka';
                  }
                  if (!value.endsWith('00')) {
                    return 'Karena NIM genap (00), kode barang harus berakhiran 00';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // 5. Jumlah Stok (Integer)
              TextFormField(
                controller: _jumlahStokController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Stok (Integer)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Jumlah stok wajib diisi'
                    : int.tryParse(value) == null
                    ? 'Jumlah stok harus berupa angka bulat'
                    : int.parse(value) < 0
                    ? 'Jumlah stok tidak boleh negatif'
                    : null,
              ),
              const SizedBox(height: 24),

              // Tombol Simpan
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: _isLoading ? null : _simpanData,
                child: _isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text('Simpan Barang', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}