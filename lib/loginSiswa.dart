import 'package:flutter/material.dart';
import 'homeSiswa.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ambil_tugassiswaController.dart';
import 'ambil_materisiswaController.dart';
import 'ambil_namasiswaController.dart';
import 'ambil_tugasSebelumnya.dart';

class User {
  final int id;
  final String email;
  final String password;
  final int idKelas; // Tambahkan properti id_kelas

  User({required this.id, required this.email, required this.password, required this.idKelas});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      idKelas: json['id_kelas'], // Ambil nilai id_kelas dari JSON
    );
  }

  @override
  String toString() {
    return 'User{id: $id, email: $email, password: $password, id_kelas: $idKelas}';
  }
}

class LoginSiswaController extends GetxController {
  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var userKelasId = 0.obs;
  final NamaSiswa _NamaSiswa = Get.put(NamaSiswa());
  late int idSiswa;

  final TugasSiswa _TugasSiswa = Get.put(TugasSiswa());
  final TugasSebelumnyaController _TugasSebelumnyaController = Get.put(TugasSebelumnyaController());
  final MateriSiswa _MateriSiswa = Get.put(MateriSiswa());

  Future<void> login(BuildContext context) async {
    try {
      isLoading(true);

      var response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/siswa'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        var users = data.map((user) => User.fromJson(user)).toList();

        User? user;
        try {
          user = users.firstWhere(
            (user) => user.email == emailController.text && user.password == passwordController.text,
          );
        } catch (e) {
          user = null;
        }

        if (user != null) {
          isLoggedIn(true);
          userKelasId.value = user.id; // Simpan id_kelas pengguna
          _TugasSiswa.setIdKelas(user.idKelas); // Kirim id_kelas ke AmbilTugasSiswaController
          _TugasSiswa.setIdSiswa(user.id);
          _TugasSebelumnyaController.setId(user.idKelas, user.id); // Kirim id_kelas ke AmbilTugas_TugasSebelumnyaControllerController
          _MateriSiswa.setIdSiswa(user.idKelas);
          _NamaSiswa.idSiswa = user.id;
          print("Login sukses");
          print(user.password);
          Get.to(MyHomeSiswaPage(), arguments: userKelasId.value);
        } else {
          print("Login gagal: Invalid email or password");
          Get.snackbar('Login Failed', 'Invalid email or password');
        }
      } else {
        print("Login gagal");
        Get.snackbar('Login Failed', 'Failed to fetch user data');
      }
    } catch (e) {
      print("Error: $e");
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      isLoading(false);
    }
  }
}

class LoginSiswaPage extends StatelessWidget {
    final LoginSiswaController _loginController = Get.put(LoginSiswaController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Siswa'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                '../assets/logoTimi.png',
                height: 200,
              ),
              SizedBox(height: 20),
              Text(
                'Login Siswa',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _loginController.emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        fillColor: Color(0xFFDDEBEB), // Warna area teks
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(10.0), // Border radius
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0), // Padding input
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _loginController.passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        fillColor: Color(0xFFDDEBEB), // Warna area teks
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(10.0), // Border radius
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0), // Padding input
                      ),
                      obscureText: true,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loginController.isLoading.value
                    ? null
                    : () {
                        _loginController.login(context); // Meneruskan context
                      },
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF15D7EF), // Warna tombol
                  minimumSize: Size(150, 50), // Ukuran tombol
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0), // Border radius
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
