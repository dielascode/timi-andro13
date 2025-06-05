import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// import 'detailModulSiswa.dart';
import 'detailTugasSiswa.dart';
import 'ambil_tugassiswaController.dart';
import 'ambil_materisiswaController.dart';
import 'ambil_namasiswaController.dart';
import 'lihatTugasSebelumnya.dart';
import 'main.dart';

class MyHomeSiswaPage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomeSiswaPage> {
  int _selectedIndex = 0;
  final TugasSiswa _tugasSiswa = Get.put(TugasSiswa());
  // final MateriSiswa _materiSiswa = Get.put(MateriSiswa());

  @override
  void initState() {
    super.initState();
    int idKelas = Get.arguments;
    _tugasSiswa.setIdKelas(idKelas);
    // _materiSiswa.setIdKelas(idKelas);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Function to handle logout
  Future<void> _logout(BuildContext context) async {
    // Perform your logout logic here, like clearing user session, etc.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // After logout, navigate to the ChoosePage
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => ChoosePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
        title: Image.asset(
          '../assets/logoTimi.png', // Adjust the path to your logo asset
          height: 40,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout_sharp),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Logout"),
                    content: Text("Apakah kamu yakin akan logout?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Close"),
                      ),
                      TextButton(
                        onPressed: () {
                          // Call the logout function
                          _logout(context);
                        },
                        child: Text("Logout"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: <Widget>[
          HomePage(),
          TugasPage(),
          ModulPage(),
          MePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Tugas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Modul',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Me',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final NamaSiswa _NamaSiswa = Get.put(NamaSiswa());

  @override
  Widget build(BuildContext context) {
    // Panggil fetchData saat halaman diinisialisasi
    _NamaSiswa.fetchData();

    return Scaffold(
      body: Stack(
        children: [
          // Gambar latar belakang
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('../assets/BackgroundTimi.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Konten utama
          ListView(
            padding: EdgeInsets.only(top: 20), // margin atas
            children: [
              SizedBox(height: 100),
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  _buildMainContainer(context),
                  Positioned(
                    top:
                        0, // Atur nilai ini untuk mengubah seberapa banyak gambar profil tumpang tindih
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.black,
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainContainer(BuildContext context) {
    return Container(
      width: double.infinity, // Membuat kontainer penuh lebar
      margin: EdgeInsets.only(
          top: 50), // Atur nilai ini untuk memindahkan konten ke bawah
      decoration: BoxDecoration(
        color: Colors.white, // Warna latar belakang kontainer
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.0), // Atur border radius bagian kiri atas
          topRight:
              Radius.circular(40.0), // Atur border radius bagian kanan atas
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.1), // Warna bayangan dengan opacity
            blurRadius: 10, // Radius blur bayangan
            offset: Offset(0, 5), // Offset bayangan
          ),
        ],
      ),
      padding: EdgeInsets.all(16.0), // Padding dalam kontainer
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30), // Tambah jarak untuk gambar profil
          Obx(() {
            if (_NamaSiswa.dataList.isEmpty) {
              return CircularProgressIndicator();
            } else {
              var data = _NamaSiswa.dataList.first;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Halo',
                    style: TextStyle(
                      color: Colors.black, // Warna teks
                      fontSize: 18, // Ukuran font
                      fontWeight: FontWeight.bold, // Ketebalan font
                    ),
                  ),
                  Text(
                    data['nama'], // Nama siswa dari basis data
                    style: TextStyle(
                      color: Colors.black, // Warna teks
                      fontSize: 24, // Ukuran font
                      fontWeight: FontWeight.bold, // Ketebalan font
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildDateTimeWidget(), // Widget penampilan waktu
                ],
              );
            }
          }),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Posisi row
            children: [
              _buildShortcutCard(
                context,
                icon: Icons.assignment,
                label: 'Pintasan Tugas Anda',
                onTap: () {
                  // Handle shortcut action
                },
              ),
              _buildShortcutCard(
                context,
                icon: Icons.edit,
                label: 'Pintasan Tugas Anda',
                onTap: () {
                  // Handle shortcut action
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildLatestTasksSection(),
        ],
      ),
    );
  }

  Widget _buildDateTimeWidget() {
    return StreamBuilder<String>(
      stream: _dateTimeStream(),
      builder: (context, snapshot) {
        return Text(
          snapshot.hasData ? snapshot.data! : '',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 16,
          ),
        );
      },
    );
  }

  Stream<String> _dateTimeStream() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      yield DateTime.now()
          .toString(); // Menghasilkan tanggal dan waktu sekarang
    }
  }

  Widget _buildShortcutCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 100, // Tinggi kontainer
          margin: EdgeInsets.symmetric(horizontal: 8.0), // Margin horizontal
          decoration: BoxDecoration(
            color: Color(0xFFFFA726), // Warna latar belakang kontainer
            borderRadius:
                BorderRadius.circular(12.0), // Border radius kontainer
          ),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Posisi kolom dalam kontainer
            children: [
              Icon(icon,
                  size: 40, color: Colors.white), // Ikon dengan warna putih
              SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center, // Teks rata tengah
                style: TextStyle(
                  color: Colors.white, // Warna teks
                  fontWeight: FontWeight.bold, // Ketebalan teks
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLatestTasksSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Warna latar belakang kontainer
        borderRadius: BorderRadius.circular(12.0), // Border radius kontainer
      ),
      padding: EdgeInsets.all(16.0), // Padding dalam kontainer
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Posisi kolom
        children: [
          Text(
            'Tugas Terbaru',
            style: TextStyle(
              color: Colors.black, // Warna teks
              fontSize: 18, // Ukuran font
              fontWeight: FontWeight.bold, // Ketebalan teks
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 200, // Tinggi kontainer
            decoration: BoxDecoration(
              color: Color(0xFF06C798), // Warna latar belakang kontainer
              borderRadius:
                  BorderRadius.circular(12.0), // Border radius kontainer
            ),
            child: Center(
              child: Text(
                'Daftar Tugas Terbaru',
                style: TextStyle(
                  color: Colors.white, // Warna teks
                  fontSize: 16, // Ukuran font
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TugasPage extends StatelessWidget {
  final TugasSiswa _tugasSiswa = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFBFFDF), // Warna AppBar diubah
        title: Row(
          children: [
            Icon(Icons.school,
                color: Colors.black), // Icon tambahan dengan warna hitam
            SizedBox(width: 8),
            Text(
              'Data Tugas',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.history, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LihatTugasSebelumnyaPage()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Gambar latar belakang
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('../assets/FrBg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Konten utama
          Obx(() {
            if (_tugasSiswa.tugasList.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
              itemCount: _tugasSiswa.tugasList.length,
              itemBuilder: (context, index) {
                var tugas = _tugasSiswa.tugasList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: _buildClassContainer(
                    context,
                    tugas['id'],
                    tugas['id_kelas'],
                    tugas['id_mapel'],
                    tugas['id_guru'],
                    tugas['tugas'],
                    tugas['tanggal'],
                    tugas['tenggat'],
                    tugas['mapel']['nama_mapel'],
                    tugas['guru']['nama'],
                    _tugasSiswa.idSiswa.value,
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildClassContainer(
    BuildContext context,
    int id,
    int idKelas,
    int idMapel,
    int idGuru,
    String tugas,
    String tanggal,
    String tenggat,
    String namaMapel,
    String namaGuru,
    int idSiswa,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFFAE34), // Warna diubah menjadi Color(0xFFFFAE34)
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Guru: $namaGuru",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "Mapel: $namaMapel",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "Tugas: $tugas",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "Tanggal: $tanggal",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Tenggat: $tenggat",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 10, bottom: 10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PengumpulanPage(
                          id: id,
                          idKelas: idKelas,
                          idMapel: idMapel,
                          idGuru: idGuru,
                          tugas: tugas,
                          idSiswa: idSiswa,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: Text(
                    "Kumpulkan",
                    style: TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ModulPage extends StatelessWidget {
  final MateriSiswa _materiSiswa = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFBFFDF),
        title: Row(
          children: [
            Icon(Icons.folder, color: Colors.black),
            SizedBox(width: 8),
            Text(
              'Data Materi',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('../assets/FrBg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Obx(() {
          if (_materiSiswa.materiList.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: _materiSiswa.materiList.length,
            itemBuilder: (context, index) {
              var materi = _materiSiswa.materiList[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: _buildModulContainer(
                  context,
                  materi['materi'],
                  materi['mapel']['nama_mapel'],
                  materi['guru']['nama'],
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildModulContainer(
    BuildContext context,
    String materi,
    String namaMapel,
    String namaGuru,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFFAE34),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Guru: $namaGuru",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              "Mapel: $namaMapel",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              "Materi: $materi",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final Uri uri = Uri.parse(materi);
                    if (await canLaunch(uri.toString())) {
                      await launch(uri.toString());
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Could not launch $materi')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: Text(
                    "Lihat Materi",
                    style: TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MePage extends StatelessWidget {
  final NamaSiswa _NamaSiswa = Get.put(NamaSiswa());
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nisnController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController nomorTeleponController = TextEditingController();
  final TextEditingController namaKelasController = TextEditingController();
  final TextEditingController absenController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Panggil fetchData saat halaman diinisialisasi
    _NamaSiswa.fetchData();

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('../assets/FrBg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Obx(() {
              if (_NamaSiswa.dataList.isEmpty) {
                return CircularProgressIndicator();
              } else {
                var data = _NamaSiswa.dataList.first;

                // Mengisi controller dengan data awal
                namaController.text = data['nama'];
                emailController.text = data['email'];
                nisnController.text = data['nisn'].toString();
                alamatController.text = data['alamat'];
                nomorTeleponController.text = data['notlp'].toString();
                namaKelasController.text = data['id_kelas'].toString();
                absenController.text = data['absen'].toString();
                passwordController.text = data['password'].toString();

                return SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      data['nama'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                    ),
                                    // SizedBox(height: 1),
                                    // Text(
                                    //   '',
                                    //   style: TextStyle(
                                    //     fontWeight: FontWeight.bold,
                                    //   ),
                                    // ),
                                    // SizedBox(height: 4),
                                    Text(
                                      data['email'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.black,
                                  child: Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFFFAE34),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              padding: EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Padding(
                                      padding: EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                        'Nisn',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    subtitle: Text(data['nisn'].toString()),
                                  ),
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Padding(
                                      padding: EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                        'Alamat',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    subtitle: Text(data['alamat']),
                                  ),
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Padding(
                                      padding: EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                        'Nomor Telepon',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    subtitle: Text(data['notlp'].toString()),
                                  ),
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Padding(
                                      padding: EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                        'Kelas',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    subtitle: Text(data['kelas']['nama_kelas']),
                                  ),
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Padding(
                                      padding: EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                        'Absen',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    subtitle: Text(data['absen'].toString()),
                                  ),
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Padding(
                                      padding: EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                        'Password Akun',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    subtitle: Text(data['password'].toString()),
                                  ),
                                  SizedBox(height: 20),
                                  Center(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Tampilkan dialog untuk mengedit data
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text('Edit Data Akun Siswa'),
                                            content: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  TextField(
                                                    controller: namaController,
                                                    decoration: InputDecoration(
                                                      labelText: 'Nama',
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                    ),
                                                    enabled: false,
                                                  ),
                                                  TextField(
                                                    controller: emailController,
                                                    decoration: InputDecoration(
                                                      labelText: 'Email',
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                    ),
                                                  ),
                                                  TextField(
                                                    controller: nisnController,
                                                    decoration: InputDecoration(
                                                      labelText: 'Nisn',
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                    ),
                                                    enabled: false,
                                                  ),
                                                  TextField(
                                                    controller:
                                                        alamatController,
                                                    decoration: InputDecoration(
                                                      labelText: 'Alamat',
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                    ),
                                                  ),
                                                  TextField(
                                                    controller:
                                                        nomorTeleponController,
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'Nomor Telepon',
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                    ),
                                                    keyboardType:
                                                        TextInputType.phone,
                                                  ),
                                                  TextField(
                                                    controller:
                                                        namaKelasController,
                                                    decoration: InputDecoration(
                                                      labelText: 'Kelas',
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                    ),
                                                    enabled: false,
                                                  ),
                                                  TextField(
                                                    controller: absenController,
                                                    decoration: InputDecoration(
                                                      labelText: 'Absen',
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                    ),
                                                    enabled: false,
                                                  ),
                                                  TextField(
                                                    controller:
                                                        passwordController,
                                                    decoration: InputDecoration(
                                                      labelText: 'Password',
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  await _NamaSiswa.editData(
                                                    // Pastikan idSiswa terdefinisi
                                                    nama: namaController.text,
                                                    email: emailController.text,
                                                    nisn: nisnController.text,
                                                    alamat:
                                                        alamatController.text,
                                                    nomorTelepon:
                                                        nomorTeleponController
                                                            .text,
                                                    kelas: namaKelasController
                                                        .text,
                                                    absen: absenController.text,
                                                    password:
                                                        passwordController.text,
                                                  );

                                                  // Tutup dialog
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Simpan'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Batal'),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      child: Text('Edit'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        // primary: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
