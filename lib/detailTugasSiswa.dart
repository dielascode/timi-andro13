import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'homeSiswa.dart'; // Pastikan untuk mengimpor homeSiswa.dart
import 'ambil_tugassiswaController.dart';

class PengumpulanPage extends StatefulWidget {
  final int id;
  final int idKelas;
  final int idMapel;
  final int idGuru;
  final String tugas;
  final int idSiswa;

  PengumpulanPage({
    required this.id,
    required this.idKelas,
    required this.idMapel,
    required this.idGuru,
    required this.tugas,
    required this.idSiswa,
  });

  @override
  _PengumpulanPageState createState() => _PengumpulanPageState();
}

class _PengumpulanPageState extends State<PengumpulanPage> {
  final TextEditingController _linkController = TextEditingController();
  final TugasSiswa _tugasSiswa = Get.find();

  @override
  void dispose() {
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Tugas'),
        backgroundColor: Color(0xFFFBFFDF),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("../assets/FrBg2.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tugas anda : ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Stack(
                children: [
                  Container(
                    width: screenWidth,
                    height: screenWidth / 3,
                    decoration: BoxDecoration(
                      color: Color(
                          0xFF06C798), // Opacity disetel ke 0.8 (80% opacity)
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: Text(
                        widget.tugas,
                        style: TextStyle(
                          color: Colors
                              .black, // Ubah warna teks menjadi hitam untuk kontras dengan latar belakang putih yang lebih transparan
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: IconButton(
                      icon: Icon(Icons.fullscreen),
                      onPressed: () {
                        _showExpandedDialog(context);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                'Upload Link',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _linkController,
                      decoration: InputDecoration(
                        hintText: 'Tempel link disini',
                        fillColor: Color(0xFF06C798),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.paste),
                    onPressed: () {
                      _pasteFromClipboard();
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _showConfirmationDialog(context);
                },
                child: Text('Kumpulkan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color(0xFF06C798), // Warna seperti kode sebelumnya
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi"),
          content: Text("Apakah Anda yakin ingin mengumpulkan tugas?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                _submitTugas(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _submitTugas(BuildContext context) async {
    await _tugasSiswa.submitTugas(
      widget.id,
      widget.idKelas,
      widget.idSiswa,
      widget.idMapel,
      widget.idGuru,
      _linkController.text,
    );
    _showSuccessDialog(context);
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 60,
              ),
              SizedBox(height: 10),
              Text(
                "Berhasil",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Tutup dialog
                  Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => TugasPage(),
                    ),
                  );
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showExpandedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Text(
              widget.tugas,
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      },
    );
  }

  void _pasteFromClipboard() {
    Clipboard.getData('text/plain').then((value) {
      if (value != null) {
        setState(() {
          _linkController.text = value.text ?? '';
        });
      }
    });
  }
}
