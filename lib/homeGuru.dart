import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'detailTugasGuru.dart';
import 'materiGuru.dart';
import 'package:get/get.dart';
import 'ambil_kelasguruController.dart';
import 'ambil_namaguruController.dart';
import 'main.dart';
import 'package:intl/intl.dart';
import 'dart:async'; 

class MyHomeGuruPage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomeGuruPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => ChoosePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              '../assets/logoTimi.png',
              height: 40,
            ),
            SizedBox(width: 8),
            Text(
              '',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
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
          ClassPage(),
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
            label: 'Kelas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Me',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final KelasGuru _KelasGuru = Get.put(KelasGuru());

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final KelasGuru _KelasGuru = Get.put(KelasGuru());
  final NamaGuru _namaGuru = Get.put(NamaGuru());
  late Timer _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    widget._KelasGuru.fetchData();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    _KelasGuru.fetchData();
    _namaGuru.fetchData();
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
          _buildHeader(),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Posisi row
            children: [
              _buildInfoCard('Jumlah Materi diberi', '15'),
              _buildInfoCard('Jumlah Tugas diberi', '10'),
            ],
          ),
          SizedBox(height: 20),
          Text(
            'Tugas Terakhir',
            style: TextStyle(
              color: Colors.black, // Warna teks
              fontSize: 18, // Ukuran font
              fontWeight: FontWeight.bold, // Ketebalan teks
            ),
          ),
          SizedBox(height: 20),
          SlideshowWidget(
            slides: _KelasGuru.dataList
                .map((item) => item['class_name'] as String)
                .toList(),
          ),
          SizedBox(height: 20),
          _buildProgressSection(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Obx(() {
      String namaGuru = _namaGuru.dataList.isNotEmpty
          ? _namaGuru.dataList[0]['nama']
          : "Nama Guru";
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Posisi kolom
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
            namaGuru,
            style: TextStyle(
              color: Colors.black, // Warna teks
              fontSize: 24, // Ukuran font
              fontWeight: FontWeight.bold, // Ketebalan font
            ),
          ),
          SizedBox(height: 10),
          Text(
                  '${_formatDate(_now)}${_formatTime(_now)}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black, // Mengatur warna teks menjadi hitam
                    fontSize: 14,
                  ),
                ),
        ],
      );
    });
  }

  Widget _buildInfoCard(String title, String value) {
    return Expanded(
      child: Container(
        height: 100, // Tinggi kontainer
        margin: EdgeInsets.symmetric(horizontal: 8.0), // Margin horizontal
        decoration: BoxDecoration(
          color: Color(0xFFFFA726), // Warna latar belakang kontainer
          borderRadius: BorderRadius.circular(12.0), // Border radius kontainer
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Posisi kolom dalam kontainer
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white, // Warna teks
                fontWeight: FontWeight.bold, // Ketebalan teks
              ),
            ),
            SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                color: Colors.white, // Warna teks
                fontSize: 24, // Ukuran font
                fontWeight: FontWeight.bold, // Ketebalan teks
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection() {
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
            'Grafik',
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
              color: Color(0xFF06C798), // Ubah warna widget grafik
              borderRadius:
                  BorderRadius.circular(12.0), // Border radius kontainer
            ),
            child: Center(
              child: Text(
                'Grafik dengan rentang bulan Juli - Juni',
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

  String _formatDate(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('hh:mm:ss a').format(dateTime);
  }
}

class SlideshowWidget extends StatefulWidget {
  final List<String> slides;

  const SlideshowWidget({
    Key? key,
    required this.slides,
  }) : super(key: key);

  @override
  _SlideshowWidgetState createState() => _SlideshowWidgetState();
}

class _SlideshowWidgetState extends State<SlideshowWidget> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.85,
      initialPage: 1000,
    );
    _pageController.addListener(_pageListener);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _pageListener() {
    setState(() {
      _currentPage = _pageController.page!.round() % widget.slides.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: PageView.builder(
        controller: _pageController,
        itemBuilder: (context, index) {
          return _buildSlide(index % widget.slides.length);
        },
      ),
    );
  }

  Widget _buildSlide(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: Color(0xFFFFAE34), // Ubah warna widget slideshow
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            widget.slides[index],
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class ClassPage extends StatelessWidget {
  final KelasGuru _kelasGuru = Get.put(KelasGuru());

  @override
  Widget build(BuildContext context) {
    _kelasGuru.fetchData();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFBFFDF), // Warna AppBar diubah
        title: Row(
          children: [
            Icon(Icons.school,
                color: Colors.black), // Icon tambahan dengan warna hitam
            SizedBox(width: 8),
            Text(
              'Kelas Anda',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        automaticallyImplyLeading: false, // Menghilangkan tombol kembali
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
            if (_kelasGuru.dataList.isEmpty) {
              return Center(child: CircularProgressIndicator());
            } else {
              return GridView.builder(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(10.0),
                itemCount: _kelasGuru.dataList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 1.5,
                ),
                itemBuilder: (context, index) {
                  var data = _kelasGuru.dataList[index];
                  return _buildClassContainer(context, data);
                },
              );
            }
          }),
        ],
      ),
    );
  }

  Widget _buildClassContainer(BuildContext context, Map<String, dynamic> data) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFFAE34), // Warna diubah menjadi Color(0xFFFFAE34)
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              data['class_name'],
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailTugasGuru(
                          idKelas: data['id_kelas'],
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Text(
                    'Tugas',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MateriGuru(idKelas: data['id_kelas']),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Text(
                    'Materi',
                    style: TextStyle(fontWeight: FontWeight.bold),
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
  final NamaGuru _namaGuru = Get.put(NamaGuru());
  final TextEditingController namaController = TextEditingController();
  final TextEditingController kodeMengajarController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nomorTeleponController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _namaGuru.fetchData();

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
              if (_namaGuru.dataList.isEmpty) {
                return CircularProgressIndicator();
              } else {
                var data = _namaGuru.dataList.first;

                // Mengisi controller dengan data awal
                namaController.text = data['nama'];
                kodeMengajarController.text = data['kode'].toString();
                emailController.text = data['email'];
                nomorTeleponController.text = data['notlp'].toString();

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
                                        'Kode Mengajar',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    subtitle: Text(data['kode'].toString()),
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
                                  SizedBox(height: 20),
                                  Center(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Tampilkan dialog untuk mengedit data
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text('Edit Data Akun Guru'),
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
                                                    controller:
                                                        kodeMengajarController,
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'Kode Mengajar',
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                    ),
                                                    enabled: false,
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
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  await _namaGuru.editData(
                                                    nama: namaController.text,
                                                    kodeMengajar:
                                                        kodeMengajarController
                                                            .text,
                                                    email: emailController.text,
                                                    nomorTelepon:
                                                        nomorTeleponController
                                                            .text,
                                                  );

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
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Center(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _logout(context);
                                      },
                                      child: Text('Logout/Keluar'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
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

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => ChoosePage()),
    );
  }
}
