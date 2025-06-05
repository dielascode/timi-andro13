import 'package:flutter/material.dart';
import 'loginGuru.dart';
import 'package:get/get.dart';
import 'loginSiswa.dart';

void main() {
  runApp(
    GetMaterialApp(
    title: 'Simple Flutter App',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    debugShowCheckedModeBanner: false,
    home: ChoosePage(),
  )); 
}

class ChoosePage extends StatelessWidget {
  const ChoosePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              '../assets/logoTimi.png',
              height: 200,
            ),
            const SizedBox(height: 0),
            const Text(
              'Pilih metode login ke akun TIMI',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginGuruPage()),
                );
              },
              child: const Text(
                'Guru',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Warna teks hitam
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50), backgroundColor: const Color(0xFFDDEBEB), // Atur warna tombol
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0), // Sudut halus
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginSiswaPage()),
                );
              },
              child: const Text(
                'Siswa',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Warna teks hitam
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50), backgroundColor: const Color(0xFFDDEBEB), // Atur warna tombol
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0), // Sudut halus
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
