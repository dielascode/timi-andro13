import 'package:flutter/material.dart';
import 'homeGuru.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ambil_kelasguruController.dart';
import 'ambil_namaguruController.dart';
import 'ambil_tugasguruController.dart';
import 'ambil_materiguruController.dart';

class User {
  final int id; // Tambahkan properti id
  final String email;
  final String password;

  User({required this.id, required this.email, required this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'], // Ambil nilai id dari JSON
      email: json['email'],
      password: json['password'],
    );
  }

  @override
  String toString() {
    return 'User{id: $id, email: $email, password: $password}';
  }
}

class LoginGuruController extends GetxController {
  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  late int teacherId;
  late int idGuru;
  late int IDGURU;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final KelasGuru _KelasGuru = Get.put(KelasGuru());
  final NamaGuru _NamaGuru = Get.put(NamaGuru());
  final TugasGuru _tugasGuru = Get.put(TugasGuru());
  final MateriGuruController _materiGuruController = Get.put(MateriGuruController());

  Future<void> login(BuildContext context) async {
    try {
      isLoading(true);

      var response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/guru'),
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
          _KelasGuru.teacherId = user.id; // Simpan ID guru di controller
          _NamaGuru.idGuru = user.id;
          _tugasGuru.IDGURU = user.id;
          _materiGuruController.IDGURU = user.id;
          isLoggedIn(true);
          print("login sukses");
          print(user.password);
          Get.to(MyHomeGuruPage());
        } else {
          print("login gagal: Invalid email or password");
          Get.snackbar('Login Failed', 'Invalid email or password');
        }
      } else {
        print("login gagal");
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

class LoginGuruPage extends StatelessWidget {
  final LoginGuruController _loginController = Get.put(LoginGuruController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Guru'),
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
              SizedBox(height: 10),
              Text(
                'Login Guru',
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
                    TextField(
                      controller: _loginController.emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        fillColor: Color(0xFFDDEBEB), // Warna area teks
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0), // Border radius
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0), // Padding input
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _loginController.passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        fillColor: Color(0xFFDDEBEB), // Warna area teks
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0), // Border radius
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
